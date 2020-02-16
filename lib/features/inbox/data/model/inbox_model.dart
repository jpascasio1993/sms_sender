import 'package:equatable/equatable.dart';
import 'package:sms_sender/core/database/database.dart';

class InboxModel extends InboxMessage with EquatableMixin{
  @override
  List<Object> get props => [id, address, body, date, dateSent, sent];
}