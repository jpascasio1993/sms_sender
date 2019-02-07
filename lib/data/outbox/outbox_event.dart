import 'package:sms_sender/data/base_event.dart';
import 'package:sms_sender/models/outbox_model.dart';

abstract class OutboxEvent extends BaseEvent {
  @override
  String toString() {
    return 'BaseEvent';
  }
}

class OutboxFetchAll extends OutboxEvent {
  @override
  String toString() {
    return 'OutboxFetchAll';
  }
}

class OutboxSendSms extends OutboxEvent {
  OutboxModel outbox;

  OutboxSendSms({this.outbox});

  @override
  String toString() {
    return 'OutboxSendSms';
  }
}
