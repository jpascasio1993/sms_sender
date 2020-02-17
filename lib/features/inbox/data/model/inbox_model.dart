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
    bool sent}): super(
      id: id, 
      address: address, 
      body: body, 
      date: date, 
      dateSent: dateSent, 
      sent: sent
    );

  @override
  List<Object> get props => [id, address, body, date, dateSent, sent];
  
  @override
  InboxMessage copyWith({int id, String address, String body, String date, String dateSent, bool sent}) {
    return InboxModel(id: id, address: address, body: body, date: date, dateSent: dateSent, sent: sent);
  }

  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic> {
      '_id': serializer.toJson<int>(id),
      'message': serializer.toJson<String>(address),
      'status': serializer.toJson<bool>(sent),
      'datetime': serializer.toJson<String>(date),
      'sender_number': serializer.toJson<String>(address),
    };
  }
}