import 'package:equatable/equatable.dart';
import 'package:sms_sender/core/database/database.dart';

class InboxParams extends Equatable {
  final int limit;
  final int offset;
  final bool read;
  final int status;
  final List<InboxMessagesCompanion> messages;

  InboxParams(
      {this.limit = 20,
      this.offset = 0,
      this.read,
      this.status,
      this.messages});

  @override
  List<Object> get props => [limit, offset];
}
