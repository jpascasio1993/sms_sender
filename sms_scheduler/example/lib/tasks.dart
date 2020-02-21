import 'package:flutter/foundation.dart';
import 'package:sms_scheduler/sms_scheduler.dart';

const int PROCESS_INBOX_ID = 4001;
const int PROCESS_OUTBOX_ID = 4002;

void testTask() async {
  try{
    debugPrint('test Task');
  }catch(error) {
    debugPrint('testTaskerror $error');
  }finally {
    await SmsScheduler.addTask(PROCESS_INBOX_ID,
        Duration(seconds: 10), testTask);
    // await Future.delayed(Duration(seconds: 10));
  }
}

void testTask2() async {
  try{
    throw Exception('test');
  }catch(error) {
    debugPrint('testTaskerror $error');
  }finally {
    await SmsScheduler.addTask(PROCESS_OUTBOX_ID,
        Duration(seconds: 5), testTask2);
    // await Future.delayed(Duration(seconds: 10));
  }
}