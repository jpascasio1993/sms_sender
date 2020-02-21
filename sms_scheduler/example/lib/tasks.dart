import 'package:flutter/foundation.dart';
import 'package:sms_scheduler/sms_scheduler.dart';

const int PROCESS_INBOX_ID = 4001;
void testTask() async {
  try{
    debugPrint('test Task');
  }catch(error) {
    debugPrint('testTaskerror $error');
  }finally {
     await SmsScheduler.addTask(PROCESS_INBOX_ID,
        Duration(seconds: 10), testTask);
  }
    
 
}