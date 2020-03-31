import 'package:equatable/equatable.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';

class InboxParams extends Equatable {
  final int limit;
  final int offset;
  final OrderingMode orderingMode;
  final bool read;
  final List<int> status;
  final List<InboxMessagesCompanion> messages;
  final String date;

  InboxParams(
      {this.limit = 20,
      this.offset = 0,
      this.orderingMode = OrderingMode.desc,
      this.read,
      this.status,
      this.messages,
      this.date});

  @override
  List<Object> get props => [limit, offset, orderingMode, read, status, messages];
}
