
import 'package:flutter/foundation.dart';
import 'package:sms_scheduler/sms_scheduler.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_remote_source.dart';
import 'package:sms_sender/features/inbox/data/model/inbox_model.dart';
import './injectors.dart';

const int PROCESS_INBOX_ID = 4001;
const int PROCESS_OUTBOX_ID = 4002;
final Injector injector = Injector.asNewInstance();
// Future<void> processInbox() async {
//   try {
//     // final stringify = InboxModel()
//     // .copyWith(
//     //   status: 0,
//     //   id: 0,
//     //   dateSent: 'test',
//     //   date: 'test',
//     //   body: '"body"',
//     //   address: "address"
//     // ).toJson().toString();
//     // final data = {
//     //   'body': stringify
//     // };
//     // debugPrint('testInboxMOdel $data');
//     InboxMessage inboxMessage = InboxMessage(
//       id: 0, 
//       dateSent: '2020-02-22 16:22:00', 
//       date: '2020-02-22 16:22:00',
//       body: '"body"',
//       address: '09560497719',
//       status: 0
//     );
//     InboxRemoteSourceImpl inboxRemote = di.serviceLocator.get<InboxRemoteSource>();
//     bool res = await inboxRemote.sendInboxToServer([
//       inboxMessage
//     ]);

//     debugPrint('sent $res');
//   }catch(error) {
//     debugPrint('error task $error');
//   }finally {

//   }
// }

Future<void> processInbox() async {
  try {
    // final stringify = InboxModel()
    // .copyWith(
    //   status: 0,
    //   id: 0,
    //   dateSent: 'test',
    //   date: 'test',
    //   body: '"body"',
    //   address: "address"
    // ).toJson().toString();
    // final data = {
    //   'body': stringify
    // };
    // debugPrint('testInboxMOdel $data');
    
    await injector.init();
    InboxMessage inboxMessage = InboxMessage(
      id: 0, 
      dateSent: '2020-02-22 16:22:00', 
      date: '2020-02-22 16:22:00',
      body: '"body"',
      address: '09560497719',
      status: 0
    );
    InboxRemoteSourceImpl inboxRemote = injector.serviceLocator.get<InboxRemoteSource>();
    bool res = await inboxRemote.sendInboxToServer([
      inboxMessage
    ]);

    debugPrint('sent $res');
  }catch(error) {
    debugPrint('error task $error');
  }finally {
       await SmsScheduler.rescheduleTask(PROCESS_INBOX_ID,
        Duration(seconds: 10), processInbox);
  }
}