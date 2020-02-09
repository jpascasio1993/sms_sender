import 'package:sms/sms.dart';

abstract class InboxRepository {
  Future<List<SmsMessage>> getInbox(int limit, int offset);
}