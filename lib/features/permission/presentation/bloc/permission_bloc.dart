import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_scheduler/sms_scheduler.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_no_params.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_params.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_request.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_save_info.dart';
import 'package:sms_sender/features/permission/presentation/bloc/permission_event.dart';
import 'package:sms_sender/features/permission/presentation/bloc/permission_state.dart';
import 'package:sms_sender/tasks.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  final SharedPreferences preferences;
  final PermissionSaveInfo permissionSaveInfo;
  final PermissionRequest permissionRequest;
  final SmsScheduler smsScheduler;
  PermissionBloc(
      {@required this.preferences,
      @required this.permissionSaveInfo,
      @required this.permissionRequest,
      @required this.smsScheduler});

  @override
  PermissionState get initialState => InitialPermissionState();

  @override
  Stream<PermissionState> mapEventToState(PermissionEvent event) async* {
    // if (event is RequestPermissionEvent) {
    //   final res = await permissionSaveInfo(PermissionNoParams());
    //   yield* res.fold((failure) async* {
    //     yield PermissionErrorState(message: failure.message);
    //   }, (success) async* {
    //     final res2 = await permissionRequest(
    //         PermissionParams(permissionGroups: event.permissions));
    //     yield* res2.fold((failure) async* {
    //       yield PermissionErrorState(message: failure.message);
    //     }, (success) async* {
    //       // await setUpAppInfo();
    //       // await setUpImei();
    //       final ignoreBattOptimization = await ignoreBatteryOptimization();
    //       final defaultSms = await setAsDefaultSMS();
    //       debugPrint('ignoreBattOptimization $ignoreBattOptimization');
    //       debugPrint('defaultSms $defaultSms');
    //       if(!ignoreBattOptimization || !defaultSms) {
    //         yield PermissionDeniedState();
    //       }else {
    //         await setupTasks();
    //         await startScheduler();
    //         yield PermissionGrantedState();
    //       }
    //     });
    //   });
    // }
    if (event is RequestPermissionEvent) {
        final res = await permissionRequest(
            PermissionParams(permissionGroups: event.permissions));
        yield* res.fold((failure) async* {
            yield PermissionDeniedState();
        },(success)async *{
            final res2 = await permissionSaveInfo(PermissionNoParams());
            yield* res2.fold(
              (failure) async* { yield PermissionErrorState(message: failure.message); }, 
              (success) async* {
                final ignoreBattOptimization = await ignoreBatteryOptimization();
                final defaultSms = await setAsDefaultSMS();
                print('RequestPermissionEventz $ignoreBattOptimization || $defaultSms');
                if(!ignoreBattOptimization || !defaultSms) {
                    yield PermissionDeniedState();
                }else {
                    await setupTasks();
                    await startScheduler();
                    yield  PermissionGrantedState();
                }
               
              });
        });
    }
  }

  Future<bool> clearSharedPreferenceCache() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    return prefs.clear();
  }

  // Future<void> setUpAppInfo() async {
  //   SharedPreferences prefs = preferences;
  //   String projectAppID = await GetVersion.appID;
  //   await prefs.setString('appId', projectAppID);
  // }

  // Future<void> setUpImei() async {
  //   SharedPreferences prefs = preferences;
  //   // prefs.refreshCache();
  //   String imei =
  //       await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true);
  //   debugPrint('imei $imei');
  //   if (imei != null || imei != '') {
  //     await prefs.setString('imei', imei);
  //   }
  // }

  Future<bool> ignoreBatteryOptimization() async {
    return await smsScheduler.requestIgonoreBatteryOptimization;
  }

  Future<bool> setAsDefaultSMS() async {
    return await smsScheduler.setAsDefaultApp;
  }

  Future<void> setupTasks() async {
      await smsScheduler.addTask(PROCESS_INBOX_ID,
        Duration(seconds: 10), processInbox);
      await smsScheduler.addTask(REFETCH_INBOX_ID,
       Duration(seconds: 10), fetchInbox);
      await smsScheduler.addTask(REFETCH_OUTBOX_ID,
      Duration(seconds: 10), fetchOutbox);
      await smsScheduler.addTask(PROCESS_OUTBOX_ID,
      Duration(seconds: 10), processOutbox);
      await smsScheduler.addTask(PROCESS_DELETE_OLD_OUTBOX,
      Duration(seconds: 30), processDeleteOldOutbox);
      await smsScheduler.addTask(PROCESS_DELETE_OLD_INBOX,
      Duration(seconds: 30), processDeleteOldInbox);
  }

  Future<bool> startScheduler() async {
    return await smsScheduler.initialize();
  }
}
