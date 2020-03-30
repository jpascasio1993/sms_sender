
import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_scheduler/sms_scheduler.dart';
import 'package:sms_sender/core/datasources/constants.dart';
import 'package:sms_sender/core/global/constants.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_sms_and_save_to_db.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';
import 'package:sms_sender/features/inbox/domain/usecases/send_sms_to_server.dart';
import 'package:sms_sender/features/outbox/domain/usecases/delete_old_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox_from_remote.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';
import 'package:sms_sender/features/outbox/domain/usecases/send_outbox_sms.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sms_sender/core/extensions/date_time_extension.dart';
import './injectors.dart';


const int PROCESS_INBOX_ID = 4001;
const int PROCESS_OUTBOX_ID = 4002;
const int REFETCH_INBOX_ID = 5001;
const int REFETCH_OUTBOX_ID = 5002;
const int PROCESS_DELETE_OLD_OUTBOX = 5003;
const String PROCESS_INBOX_PORT_NAME = 'process_inbox';
const String PROCESS_OUTBOX_PORT_NAME = 'process_outbox';
const String SUCCESS_BATCH_UPDATE_REFETCH_INBOX =
    'SUCCESS_BATCH_UPDATE_REFETCH_INBOX';
const String SUCCESS_REFETCH_INBOX = 'SUCCESS_REFETCH_INBOX';
const String SUCCESS_REFETCH_OUTBOX = 'SUCCESS_REFETCH_OUTBOX';

final Injector injector = Injector.asNewInstance();
final Lock lock = Lock();

Future<void> processInbox() async {
  await lock.synchronized(() async {
     await injector.init();
  });
  SmsScheduler scheduler = injector.serviceLocator.get<SmsScheduler>();
  final firebaseReference = injector.serviceLocator.get<FirebaseReference>();
  
  try {
    DateTime date = DateTime.now();
    

    final SendPort mainSendPort =
        IsolateNameServer.lookupPortByName(PROCESS_INBOX_PORT_NAME);
    final SendSmsToServer sendSmsToServer = injector.serviceLocator.get<SendSmsToServer>();
    final result = await sendSmsToServer(InboxParams(
      limit: 25,
      offset: 0,
      status: [InboxStatus.unprocessed, InboxStatus.failed, InboxStatus.reprocess]
    ));
    bool success = await result.fold((failure) => false , (success) => success);
    mainSendPort?.send(
            {'action': SUCCESS_REFETCH_INBOX, 'data': success});

    final firebaseDatabase = injector.serviceLocator.get<FirebaseDatabase>();
    final firebaseUrls = injector.serviceLocator.get<FirebaseURLS>();
    await firebaseDatabase.reference().child(firebaseUrls.deviceStatus()).update({
      'inbox': {
        'timestamp': DateFormat('yyyy-MM-dd hh:mm:ss a').format(date),
        'server_timestamp': ServerValue.timestamp
      }
    });
    debugPrint('inbox sent to server? $success');
  }catch(error) {
    debugPrint('processInbox error task $error');
  }finally {
      int delay = await firebaseReference.inboxPostDelay().catchError((error) => 30);
      await scheduler.rescheduleTask(PROCESS_INBOX_ID,
      Duration(seconds: delay), processInbox);
  }
}

Future<void> fetchInbox() async {
    await lock.synchronized(() async {
      await injector.init();
    });
    SmsScheduler scheduler = injector.serviceLocator.get<SmsScheduler>();
   
    try {
        DateTime date = DateTime.now();
        debugPrint('fetchInbox started $date');
        // await scheduler.smsRead([259, 258, 257, 249]);
        final SendPort mainSendPort =
            IsolateNameServer.lookupPortByName(PROCESS_INBOX_PORT_NAME);

        final firebaseDatabase = injector.serviceLocator.get<FirebaseDatabase>();
        final firebaseUrls = injector.serviceLocator.get<FirebaseURLS>();
       

        GetSmsAndSaveToDb getSmsAndSaveToDb = injector.serviceLocator.get<GetSmsAndSaveToDb>();
        final result = await getSmsAndSaveToDb(InboxParams(limit: 30, offset: 0, read: false ));

        bool success = await result.fold((failure) => false, (success) => success);
        mainSendPort?.send({'action': SUCCESS_REFETCH_INBOX, 'data': success});
        await firebaseDatabase.reference().child(firebaseUrls.deviceStatus()).update({
          'inbox_refetch': {
            'timestamp': DateFormat('yyyy-MM-dd hh:mm:ss a').format(date),
            'server_timestamp': ServerValue.timestamp
          }
        });
        debugPrint('fetched unread inbox? $success');
    }catch(error) {
        debugPrint('fetchInbox error task $error');
    }finally {
        await scheduler.rescheduleTask(REFETCH_INBOX_ID,
        Duration(seconds: 10), fetchInbox);
    }
}

Future<void> fetchOutbox() async {
    return;
    // await lock.synchronized(() async {
    //   await injector.init();
    // });
    
    // SmsScheduler scheduler = injector.serviceLocator.get<SmsScheduler>();
    // final firebaseReference = injector.serviceLocator.get<FirebaseReference>();
    // final GetOutboxFromRemote getOutboxFromRemote  = injector.serviceLocator.get<GetOutboxFromRemote>();
    // try{
    //     DateTime date = DateTime.now();
    //     final SendPort mainSendPort =
    //         IsolateNameServer.lookupPortByName(PROCESS_OUTBOX_PORT_NAME);
       
    //     final result = await getOutboxFromRemote(null);
    //     bool success = await result.fold((failure) => false, (success) => true);
    //     mainSendPort?.send({'action': SUCCESS_REFETCH_OUTBOX, 'data': success});
    //      final firebaseDatabase = injector.serviceLocator.get<FirebaseDatabase>();
    //     final firebaseUrls = injector.serviceLocator.get<FirebaseURLS>();
    //     await firebaseDatabase.reference().child(firebaseUrls.deviceStatus()).update({
    //       'outbox_refetch': {
    //         'timestamp': DateFormat('yyyy-MM-dd hh:mm:ss a').format(date),
    //         'server_timestamp': ServerValue.timestamp
    //       }
    //     });
    //     debugPrint('fetched outbox? $success');
    // }catch(error) {
    //     debugPrint('fetchOutbox error: $error');
    // }finally {
    //   int delay = await firebaseReference.outboxFetchDelay().catchError((error) => 30);
    //   await scheduler.rescheduleTask(REFETCH_OUTBOX_ID,
    //   Duration(seconds: delay), fetchOutbox);
    // }
}


Future<void> processOutbox() async {
   await lock.synchronized(() async {
      await injector.init();
    });
    
    SmsScheduler scheduler = injector.serviceLocator.get<SmsScheduler>();
    final sendOutboxSms = injector.serviceLocator.get<SendOutboxSms>();
    final firebaseReference = injector.serviceLocator.get<FirebaseReference>();
    try{
      DateTime date = DateTime.now();
        final SendPort mainSendPort =
            IsolateNameServer.lookupPortByName(PROCESS_OUTBOX_PORT_NAME);
       
      final result = await sendOutboxSms(OutboxParams(limit: 1, offset: 0, status: [OutboxStatus.unsent, OutboxStatus.failed, OutboxStatus.resend], orderingMode: OrderingMode.asc));
      bool success = await result.fold((failure) => false, (success) => success);
      mainSendPort?.send({'action': SUCCESS_REFETCH_OUTBOX, 'data': success});
      final firebaseDatabase = injector.serviceLocator.get<FirebaseDatabase>();
      final firebaseUrls = injector.serviceLocator.get<FirebaseURLS>();
      await firebaseDatabase.reference().child(firebaseUrls.deviceStatus()).update({
        'outbox': {
          'timestamp': DateFormat('yyyy-MM-dd hh:mm:ss a').format(date),
          'server_timestamp': ServerValue.timestamp
        }
      });
      debugPrint('outbox sent as sms message? $success');
    }catch(error) {
      debugPrint('processOutbox error: $error');
    }finally {
      int delay = await firebaseReference.outboxProcessDelay().catchError((error) => 20);
      await scheduler.rescheduleTask(PROCESS_OUTBOX_ID,
      Duration(seconds: delay), processOutbox);
    }
}

Future<void> processDeleteOldOutbox() async {
    await lock.synchronized(() async {
      await injector.init();
    });

    SmsScheduler scheduler = injector.serviceLocator.get<SmsScheduler>();
    final deleteOldOutbox = injector.serviceLocator.get<DeleteOldOutbox>();
    final firebaseReference = injector.serviceLocator.get<FirebaseReference>();

    try {
      DateTime date = DateTime.now();
      final SendPort mainSendPort =
            IsolateNameServer.lookupPortByName(PROCESS_OUTBOX_PORT_NAME);
      final firebaseUrls = injector.serviceLocator.get<FirebaseURLS>();
      final firebaseDatabase = injector.serviceLocator.get<FirebaseDatabase>();
      final months = await firebaseReference.deleteOldOutbox()
        .timeout(new Duration(minutes: 1))
        .catchError((error) => 3);
      final DateTime finalDate = DateTime(date.year, date.month+months, date.day, 23, 59, 59);
      await firebaseDatabase.reference().child(firebaseUrls.deviceStatus()).update({
        'outbox_delete_old': {
          'timestamp': DateFormat('yyyy-MM-dd hh:mm:ss a').format(date),
          'server_timestamp': ServerValue.timestamp
        }
      });
      
      final result = await deleteOldOutbox(OutboxParams(date: finalDate.toStringEx()));
      bool success = await result.fold((failure) => false, (rows) {
        debugPrint('delete affected rows: $rows');
        return true;
      });
      mainSendPort?.send({'action': SUCCESS_REFETCH_OUTBOX, 'data': success});
      // debugPrint('Old outbox delete ${finalDate.toStringEx()}');
      debugPrint('Old outbox delete? $success');
    }catch(error) {
      debugPrint('processDeleteOldOutbox error: $error');
    }finally {
      await scheduler.rescheduleTask(PROCESS_DELETE_OLD_OUTBOX,
      Duration(seconds: 30), processDeleteOldOutbox);
    }
}