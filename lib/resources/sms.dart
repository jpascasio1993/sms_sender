import 'package:sms/sms.dart';
import 'dart:collection';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:collection';

class SmsResource {
  SmsQuery query = SmsQuery();
  Future<List<SmsMessage>> fetchData() async {
    List<SmsMessage> allSms = await query.getAllSms;
    return UnmodifiableListView(allSms);
  }
}
