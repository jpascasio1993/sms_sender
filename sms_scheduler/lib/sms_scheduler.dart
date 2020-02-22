import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
const String _backgroundName = 'plugins.flutter.io/sms_scheduler_background';

void _smsSchedulerCallbackDispatcher() {
  const MethodChannel _channel =
      MethodChannel(_backgroundName, JSONMethodCodec());

  // Setup Flutter state needed for MethodChannels.
  WidgetsFlutterBinding.ensureInitialized();

  // This is where the magic happens and we handle background events from the
  // native portion of the plugin.
  _channel.setMethodCallHandler((MethodCall call) async {
    final dynamic args = call.arguments;
    //final dynamic callbackId = (args as List).length > 1 ? args[1] : -1;
    final CallbackHandle handle = CallbackHandle.fromRawHandle(args[0]);

    // PluginUtilities.getCallbackFromHandle performs a lookup based on the
    // callback handle and returns a tear-off of the original callback.
    final Function closure = PluginUtilities.getCallbackFromHandle(handle);
    print('gonna check closure');
    if (closure == null) {
      print('Fatal: could not find callback');
      exit(-1);
    }
    await closure();
  });

  _channel.invokeMethod<void>('sms_scheduler.initialized');
  debugPrint('invokeMethod sms_scheduler.initialized');
}
class SmsScheduler {
  
  static const MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/sms_scheduler', JSONMethodCodec());

  static const MethodChannel _smsMutationChannel =
      const MethodChannel('plugins.flutter.io/sms_mutation', JSONMethodCodec());

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

   static Future<bool> initialize() async {
    final CallbackHandle handle =
        PluginUtilities.getCallbackHandle(_smsSchedulerCallbackDispatcher);
    if (handle == null) {
      return false;
    }
    final dynamic result = await _channel
        .invokeMethod('sms_scheduler.start', <dynamic>[handle.toRawHandle()]);
    return result == null ? false : result;
  }

  static Future<bool> refreshScheduler() async {
    final dynamic result = await _channel.invokeMethod('sms_scheduler.refreshScheduler');
    return result == null ? false : result;
  }

  static Future<bool> start() async {
    return await initialize();
  }

  static Future<bool> stop() async {
    final dynamic result = await _channel.invokeMethod('sms_scheduler.stop');
    return result == null ? false : result;
  }

  static Future<bool> addTask(
      int id, Duration delay, dynamic Function() callback) async {
    final CallbackHandle handle = PluginUtilities.getCallbackHandle(callback);
    if (handle == null) {
      return false;
    }
    final dynamic result = await _channel.invokeMethod('sms_scheduler.addTask',
        <dynamic>[id, delay.inMilliseconds, handle.toRawHandle()]);
    return result == null ? false : result;
  }

  static Future<bool> rescheduleTask(
      int id, Duration delay, dynamic Function() callback) async {
    final CallbackHandle handle = PluginUtilities.getCallbackHandle(callback);
    if (handle == null) {
      return false;
    }
    final dynamic result = await _channel.invokeMethod('sms_scheduler.rescheduleTask',
        <dynamic>[id, delay.inMilliseconds, handle.toRawHandle()]);
    return result == null ? false : result;
  }

  static Future<bool> result(int callbackId) async {
    final dynamic result = await _channel
        .invokeMethod('sms_scheduler.background_reply', <dynamic>[callbackId]);
    return result == null ? false : result;
  }

  static Future<bool> smsRead(List<int> ids) async {
    final dynamic result = await _smsMutationChannel.invokeMethod('sms_scheduler.sms_read');
    return result == null ? false : result;
  }

  static Future<bool> get requestIgonoreBatteryOptimization async {
    final dynamic result = await _channel.invokeMethod('sms_scheduler.request_ignore_battery_optimization');
    return result == null ? false : result;
  }

  static Future<bool> get setAsDefaultApp async {
    final dynamic result = await _channel.invokeMethod('sms_scheduler.defaultApp');
    return result == null ? false : result;
  }
}
