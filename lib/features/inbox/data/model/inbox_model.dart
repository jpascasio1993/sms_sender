import 'package:sms/sms.dart';

class InboxModel extends SmsMessage {
  InboxModel(String address, String body) : super(address, body);
  InboxModel.fromJson(Map data) : super.fromJson(data);
}