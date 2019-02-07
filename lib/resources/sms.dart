import 'package:sms/sms.dart';
import 'dart:collection';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:collection';
import 'package:sms_sender/models/outbox_model.dart';

class SmsResource {
  SmsQuery query = SmsQuery();
  Future<List<SmsMessage>> fetchData() async {
    List<SmsMessage> allSms = await query.getAllSms;
    return UnmodifiableListView(allSms);
  }

  Future<SmsMessage> sendOutbox(OutboxModel outbox) async {
    SmsSender sender = new SmsSender();
    // SmsMessage msg = await sender.sendSms(SmsMessage(address,
    //     "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."));
    SmsMessage sms =
        await sender.sendSms(SmsMessage(outbox.sendTo, outbox.body));
    return sms;
  }
}
