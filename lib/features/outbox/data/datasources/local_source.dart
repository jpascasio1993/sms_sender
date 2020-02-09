import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

abstract class LocalSource {
  Future<void> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox);
  Future<List<OutboxModel>> getOutbox(int limit, int offset);
}

class LocalSourceImpl implements LocalSource {
  // TODO: add sqlite database

  @override
  Future<void> bulkInsertOutbox(List<OutboxModel> remoteSourceOutbox) async {}

  @override
  Future<List<OutboxModel>> getOutbox(int limit, int offset) async {
    return [];
  }
}
