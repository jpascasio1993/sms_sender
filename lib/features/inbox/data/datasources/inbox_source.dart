import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms/sms.dart';
import 'package:sms_scheduler/sms_scheduler.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';

abstract class InboxSource {
  Future<List<SmsMessage>> getSms(
      int limit, int offset, List<SmsQueryKind> kinds, bool read);
  Future<List<InboxMessage>> getInbox(int limit, int offset, List<int> status, OrderingMode orderingMode);
  Future<bool> insertInbox(List<InboxMessagesCompanion> messages);
  Future<bool> bulkUpdateInbox(List<InboxMessagesCompanion> messages);
  Future<bool> updateSmsReadStatus(List<int> ids);
  Future<bool> bulkDeleteInbox(List<InboxMessagesCompanion> messages);
}

class InboxSourceImpl extends InboxSource {
  final SmsQuery smsQuery;
  final AppDatabase appDatabase;
  final SmsScheduler smsScheduler;

  InboxSourceImpl({
    @required this.appDatabase,
    @required this.smsQuery,
    @required this.smsScheduler
  });

  @override
  Future<List<SmsMessage>> getSms(
      int limit, int offset, List<SmsQueryKind> kinds, bool read) async {
    List<SmsMessage> messages = await smsQuery.querySms(
        start: offset, count: limit, kinds: kinds, read: read);
    if(messages.isEmpty) {
      throw SMSException(message: inboxSmsEmptyList);
    }

    return messages;
  }

  @override
  Future<List<InboxMessage>> getInbox(int limit, int offset, List<int> status, OrderingMode orderingMode) async {
    final res = await appDatabase.inboxMessageDao
        .getInboxMessages(limit: limit, offset: offset, status: status, orderingMode: orderingMode)
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
    if(messages.isEmpty) {
      throw SMSException(message: inboxLocalEmptyListUpdateErrorMessage);
    }
    final res = await appDatabase.inboxMessageDao
        .updateInbox(messages)
        .catchError((error) =>
            throw SMSException(message: inboxLocalErrorMessageUpdate));
    return res;
  }

  @override
  Future<bool> updateSmsReadStatus(List<int> ids) async {
    return await smsScheduler.smsRead(ids).catchError((error) => throw SMSException(message: inboxSmsUpdateReadStatus));
  }

  @override
  Future<bool> bulkDeleteInbox(List<InboxMessagesCompanion> messages) async {
    if(messages.isEmpty) {
      throw SMSException(message: inboxLocalEmptyListDeleteErrorMessage);
    }
    final res = await appDatabase.inboxMessageDao
    .batchDeleteInbox(messages)
    .catchError((error) => throw SMSException(message: inboxLocalErrorMessageDelete));

    return res;
  }
}
