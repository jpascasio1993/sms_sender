import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

abstract class LocalSource {
  Future<void> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox);
  Future<List<OutboxModel>> getOutbox(int limit, int offset);
}

class LocalSourceImpl implements LocalSource {
  final AppDatabase appDatabase;

  LocalSourceImpl({@required this.appDatabase});

  @override
  Future<void> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox) async {
    final list = remoteSourceOutbox
    .where((outbox) => outbox.recipient != null)
    .map((outbox) => OutboxMessagesCompanion
    .insert(body: outbox.body, date: outbox.date, title: outbox.title, recipient: outbox.recipient, sent: Value(outbox.sent)))
    .toList();
  }

  @override
  Future<List<OutboxModel>> getOutbox(int limit, int offset) async {
    return [];
  }
}
