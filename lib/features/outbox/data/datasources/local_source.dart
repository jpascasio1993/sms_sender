import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

abstract class LocalSource {
  Future<bool> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox);
  Future<List<OutboxModel>> getOutbox(int limit, int offset, bool sent);
}

class LocalSourceImpl implements LocalSource {
  final AppDatabase appDatabase;

  LocalSourceImpl({@required this.appDatabase});

  @override
  Future<bool> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox) async {
    final list = remoteSourceOutbox
    .where((outbox) => outbox.recipient != null)
    .map((outbox) => OutboxMessagesCompanion
    .insert(body: outbox.body, date: outbox.date, title: outbox.title, recipient: outbox.recipient, sent: Value(outbox.sent)))
    .toList();
    return await appDatabase.outboxMessageDao.insertOutbox(list).catchError((error) => throw LocalException());
  }

  @override
  Future<List<OutboxModel>> getOutbox(int limit, int offset, bool sent) async {
    final res = await appDatabase.outboxMessageDao.getOutboxMessages(limit: limit, offset: offset, sent: sent).catchError((error) => throw LocalException());
    return res.map((outboxMessage) => OutboxModel(
      id: outboxMessage.id, 
      title: outboxMessage.title, 
      body: outboxMessage.body, 
      recipient: outboxMessage.recipient, 
      date: outboxMessage.date, 
      sent: outboxMessage.sent)).toList();
  }
}
