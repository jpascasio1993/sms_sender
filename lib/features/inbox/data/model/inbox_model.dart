import 'package:sms_sender/core/database/database.dart';

class InboxModel extends InboxMessage implements Comparable<InboxMessage> {
  @override
  int compareTo(InboxMessage other) {
    return other.id - this.id;
  }
}