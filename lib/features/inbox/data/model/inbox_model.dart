import 'package:equatable/equatable.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';

class InboxModel extends InboxMessage with EquatableMixin{
  
  InboxModel({
    int id, 
    String address, 
    String body, 
    String date, 
    String dateSent, 
    int status}): super(
      id: id, 
      address: address, 
      body: body, 
      date: date, 
      dateSent: dateSent, 
      status: status
    );

  @override
  List<Object> get props => [id, address, body, date, dateSent, status];
  
  @override
  InboxMessage copyWith({int id, String address, String body, String date, String dateSent, int status}) {
    return InboxModel(id: id, address: address, body: body, date: date, dateSent: dateSent, status: status);
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic> {
      '_id': serializer.toJson<int>(id),
      'message': serializer.toJson<String>(body),
      'status': serializer.toJson<int>(status),
      'datetime': serializer.toJson<String>(date),
      'sender_number': serializer.toJson<String>(address),
    };
  }

  Map<String, dynamic> toPostMap({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic> {
      '"_id"': '"${serializer.toJson<int>(id)}"',
      '"sender_number"': '"${serializer.toJson<String>(address)}"',
      '"message"': '"${serializer.toJson<String>(body).toString().replaceAll('"', '\\"')}"',
      '"date_time"': '"${serializer.toJson<String>(date)}"',
      '"status"': '"${serializer.toJson<int>(status)}"'
    };
  }
}