import 'package:flutter/foundation.dart';
import 'package:sms_scheduler/sms_scheduler.dart';

const int PROCESS_INBOX_ID = 4001;
const int PROCESS_OUTBOX_ID = 4002;

Future<void> testTask() async {
  try{
    debugPrint('test Task');
    await testDelay();
    debugPrint('test Task after delay');
  }catch(error) {
    debugPrint('testTaskerror $error');
  }finally {
    await SmsScheduler.rescheduleTask(PROCESS_INBOX_ID,
        Duration(seconds: 10), testTask);
    // await Future.delayed(Duration(seconds: 10));
  }
}

Future<void> testTask2() async {
  try{
     debugPrint('test Task2');
  }catch(error) {
    debugPrint('testTaskerror $error');
  }finally {
    await SmsScheduler.rescheduleTask(PROCESS_OUTBOX_ID,
        Duration(seconds: 5), testTask2);
    // await Future.delayed(Duration(seconds: 10));
  }
}

Future<void> testDelay() async {
  return await Future.delayed(Duration(seconds: 10));
}