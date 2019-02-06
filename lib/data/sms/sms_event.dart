import 'package:bloc/bloc.dart';
import 'package:sms_sender/data/base_event.dart';
import 'package:sms_sender/models/sms_model.dart';

abstract class SMSEvent extends BaseEvent {
  @override
  String toString() {
    return 'SMSEvent';
  }
}

class SMSPermission extends SMSEvent {
  @override
  String toString() {
    return 'SMSPermission';
  }
}

class SMSFetchAllMessage extends SMSEvent {
  @override
  String toString() {
    return 'SMSFetchAllMessage';
  }
}
