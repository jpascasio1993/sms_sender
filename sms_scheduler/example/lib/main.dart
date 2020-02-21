import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sms_scheduler/sms_scheduler.dart';
import 'package:sms_scheduler_example/tasks.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SmsScheduler.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void _onStartService() async {
    await SmsScheduler.initialize();
   
  }

  void _addTask() async {
     await SmsScheduler.addTask(PROCESS_INBOX_ID,
        Duration(seconds: 10), testTask);
  }
  void _onRequestPermission() async {
    // await PermissionsPlugin.requestPermissions([
    //   Permission.SEND_SMS,
    //   Permission.READ_SMS,
    //   Permission.READ_CONTACTS
    // ]);
    // final res =await PermissionsPlugin.requestIgnoreBatteryOptimization;
    // final res = await SmsScheduler.requestIgonoreBatteryOptimization;
    // debugPrint('success? $res');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            RaisedButton(onPressed: _onRequestPermission, child: Text('Request Permission')),
            RaisedButton(onPressed: _onStartService, child: Text('Start Service')),
            RaisedButton(onPressed: _addTask, child: Text('Add Task'))
          ],
        ),
      ),
    );
  }
}
