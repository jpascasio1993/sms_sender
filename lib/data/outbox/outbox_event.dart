import 'package:sms_sender/data/base_event.dart';

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
