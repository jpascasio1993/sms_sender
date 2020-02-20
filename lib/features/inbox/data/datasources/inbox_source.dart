import 'package:meta/meta.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';

abstract class InboxSource {
  Future<List<SmsMessage>> getSms(
      int limit, int offset, List<SmsQueryKind> kinds, bool read);
  Future<List<InboxMessage>> getInbox(int limit, int offset, int status);
  Future<bool> insertInbox(List<InboxMessagesCompanion> messages);
  Future<bool> bulkUpdateInbox(List<InboxMessagesCompanion> messages);
}

class InboxSourceImpl extends InboxSource {
  final SmsQuery smsQuery;
  final AppDatabase appDatabase;

  InboxSourceImpl({
    @required this.appDatabase,
    @required this.smsQuery,
  });

  @override
  Future<List<SmsMessage>> getSms(
      int limit, int offset, List<SmsQueryKind> kinds, bool read) async {
    return await smsQuery.querySms(
        start: offset, count: limit, kinds: kinds, read: read);
  }

  @override
  Future<List<InboxMessage>> getInbox(int limit, int offset, int status) async {
    final res = await appDatabase.inboxMessageDao
        .getInboxMessages(limit: limit, offset: offset, status: status)
        .catchError((error) =>
            throw SMSException(message: inboxSmsRetrieveErrorMessage));
    return res;
  }

  @override
  Future<bool> insertInbox(List<InboxMessagesCompanion> messages) async {
    final res = await appDatabase.inboxMessageDao
        .insertInbox(messages)
        .catchError(
            (error) => throw SMSException(message: inboxSmsInsertErrorMessage));
    return res;
  }

  @override
  Future<bool> bulkUpdateInbox(List<InboxMessagesCompanion> messages) async {
    final res = await appDatabase.inboxMessageDao
        .updateInbox(messages)
        .catchError((error) =>
            throw SMSException(message: inboxLocalErrorMessageUpdate));
    return res;
  }
}
