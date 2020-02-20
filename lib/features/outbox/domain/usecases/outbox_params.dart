import 'package:equatable/equatable.dart';
import 'package:sms_sender/core/database/database.dart';

class OutboxParams extends Equatable {
  final int limit;
  final int offset;
  final int status;
  final List<OutboxMessagesCompanion> messages;

  OutboxParams({this.limit = -1, this.offset = 0, this.status, this.messages});

  @override
  List<Object> get props => [limit, offset, status];
}
