import 'package:flutter/material.dart';

class SMSList extends StatefulWidget {
  _SMSListState createState() => _SMSListState();
}

class _SMSListState extends State<SMSList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Sender'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Text'),
      ),
    );
  }
}
