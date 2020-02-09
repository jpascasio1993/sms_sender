import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/outbox/domain/entities/outbox.dart';

class OutboxModel extends Outbox {
  OutboxModel(
      {@required int id,
      @required String title,
      @required String body,
      @required String sendTo,
      @required String date,
      @required int status})
      : super(
            id: id,
            title: title,
            body: body,
            sendTo: sendTo,
            date: date,
            status: status);

  factory OutboxModel.fromJson(Map<String, dynamic> json) {
    RegExp regex =
        RegExp(r"^(09|\+639)\d{9}$", caseSensitive: false, multiLine: false);

    int id = json['_id'] ?? -1;
    String title = json['title'];
    String body = json['body'];
    String sendTo = json['recipient'] ?? '+639162507727';
    if (regex.hasMatch(sendTo)) {
      sendTo = sendTo.replaceRange(0, sendTo.length - 10, "+63");
    } else {
      sendTo = null;
    }

    String date = DateFormat('yyyy-MM-dd hh:mm:ss a').format(
        json['date_time'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(json['date_time']) ??
                    DateTime.now().toLocal().millisecondsSinceEpoch)
            // .toLocal()
            : DateTime.now().toLocal());

    int status = json['status'];

    return OutboxModel(
        id: id,
        title: title,
        body: body,
        sendTo: sendTo,
        date: date,
        status: status);
  }
}
