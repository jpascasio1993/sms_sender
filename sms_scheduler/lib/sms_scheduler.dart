import 'dart:async';

import 'package:flutter/services.dart';

class SmsScheduler {
  static const MethodChannel _channel =
      const MethodChannel('sms_scheduler');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
