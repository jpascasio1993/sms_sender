import 'package:sms_sender/resources/sms.dart';
import 'package:sms/sms.dart';
import '../resources/Outbox.dart';
import '../models/outbox_model.dart';

class Repository {
  final outboxResource = OutboxResource();
  final smsResource = SmsResource();

  Future<List<OutboxModel>> fetchAllOutbox() => outboxResource.fetchData();
  Future<List<SmsMessage>> fetchAllSMS() => smsResource.fetchData();
  Future<SmsMessage> sendOutboxSms(OutboxModel outbox) =>
      smsResource.sendOutbox(outbox);
}

Repository repository = Repository();
