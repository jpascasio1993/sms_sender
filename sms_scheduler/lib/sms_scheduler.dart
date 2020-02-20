import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String _backgroundName = 'plugins.flutter.io/sms_scheduler_background';

// This is the entrypoint for the background isolate. Since we can only enter
// an isolate once, we setup a MethodChannel to listen for method invokations
// from the native portion of the plugin. This allows for the plugin to perform
// any necessary processing in Dart (e.g., populating a custom object) before
// invoking the provided callback.
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

    if (closure == null) {
      print('Fatal: could not find callback');
      exit(-1);
    }
    closure();
  });

  _channel.invokeMethod<void>('sms_scheduler.initialized');
  debugPrint('invokeMethod sms_scheduler.initialized');
}

class SmsScheduler {
  static const String _channelName = 'plugins.flutter.io/sms_scheduler';
  static const MethodChannel _channel =
      const MethodChannel(_channelName, JSONMethodCodec());

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

  static Future<bool> apply() async {
    final dynamic result = await _channel.invokeMethod('sms_scheduler.apply');
    return result == null ? false : result;
  }

  static Future<bool> start() async {
    final dynamic result = await _channel.invokeMethod('sms_scheduler.start');
    return result == null ? false : result;
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

  static Future<bool> result(int callbackId) async {
    final dynamic result = await _channel
        .invokeMethod('sms_scheduler.background_reply', <dynamic>[callbackId]);
    return result == null ? false : result;
  }
}
