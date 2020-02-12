import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/outbox/domain/entities/outbox.dart';

class OutboxModel extends Outbox {
  OutboxModel(
      {@required int id,
      @required String title,
      @required String body,
      @required String recipient,
      @required String date,
      @required bool sent})
      : super(
            id: id,
            title: title,
            body: body,
            recipient: recipient,
            date: date,
            sent: sent);

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

    // int status = json['status'];

    bool sent = json['status'] != null && json['status'] == 0 ? false: true ;

    return OutboxModel(
        id: id,
        title: title,
        body: body,
        recipient: sendTo,
        date: date,
        sent: sent);
  }
}


// import 'package:intl/intl.dart';
// import 'package:moor_flutter/moor_flutter.dart';
// import 'package:sms_sender/core/database/database.dart';

// class OutboxModel extends OutboxMessagesCompanion {

//    const OutboxModel({
//     Value<int> id,
//     Value<String> title,
//     Value<String> body,
//     Value<String> recipient,
//     Value<String> date,
//     Value<bool> sent,
//   }): super(
//     id: id,
//     title: title,
//     body: body,
//     recipient: recipient,
//     date: date,
//     sent: sent
//   );
  
//   factory OutboxModel.fromJson(Map<String, dynamic> json) {
//     RegExp regex =
//         RegExp(r"^(09|\+639)\d{9}$", caseSensitive: false, multiLine: false);

//     int id = json['_id'] ?? -1;
//     String title = json['title'];
//     String body = json['body'];
//     String sendTo = json['recipient'] ?? '+639162507727';
//     if (regex.hasMatch(sendTo)) {
//       sendTo = sendTo.replaceRange(0, sendTo.length - 10, "+63");
//     } else {
//       sendTo = null;
//     }

//     String date = DateFormat('yyyy-MM-dd hh:mm:ss a').format(
//         json['date_time'] != null
//             ? DateTime.fromMillisecondsSinceEpoch(
//                 int.tryParse(json['date_time']) ??
//                     DateTime.now().toLocal().millisecondsSinceEpoch)
//             // .toLocal()
//             : DateTime.now().toLocal());

    // bool sent = json['status'] != null && json['status'] == 0 ? false: true ;
   
//     return OutboxModel(
//       id: Value(id),
//       title: Value(title),
//       body: Value(body),
//       recipient: Value(sendTo),
//       date: Value(date),
//       sent: Value(sent)
//     );

//     // return OutboxModel(
//     //     id: id,
//     //     title: title,
//     //     body: body,
//     //     sendTo: sendTo,
//     //     date: date,
//     //     status: status);

    
//   }
// }
