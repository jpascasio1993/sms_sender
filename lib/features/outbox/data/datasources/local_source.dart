import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

abstract class LocalSource {
  Future<bool> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox);
  Future<List<OutboxModel>> getOutbox(int limit, int offset, int status);
}

class LocalSourceImpl implements LocalSource {
  final AppDatabase appDatabase;

  LocalSourceImpl({@required this.appDatabase});

  @override
  Future<bool> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox) async {
    final list = remoteSourceOutbox
    .where((outbox) => outbox.recipient != null)
    .map((outbox) => OutboxMessagesCompanion
    .insert(body: Value(outbox.body), date: Value(outbox.date), title: Value(outbox.title), recipient: Value(outbox.recipient), status: Value(outbox.status)))
    .toList();
    return await appDatabase.outboxMessageDao.insertOutbox(list).catchError((error) => throw LocalException(message: localErrorMessage));
  }

  @override
  Future<List<OutboxModel>> getOutbox(int limit, int offset, int status) async {
    final res = await appDatabase.outboxMessageDao.getOutboxMessages(limit: limit, offset: offset, status: status).catchError((error) => throw LocalException(message: localErrorMessage));
    return res.map((outboxMessage) => OutboxModel(
      id: outboxMessage.id, 
      title: outboxMessage.title, 
      body: outboxMessage.body, 
      recipient: outboxMessage.recipient, 
      date: outboxMessage.date, 
      status: outboxMessage.status)).toList();
  }
}
