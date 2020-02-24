import 'package:equatable/equatable.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';

class OutboxParams extends Equatable {
  final int limit;
  final int offset;
  final OrderingMode orderingMode;
  final List<int> status;
  final List<OutboxMessagesCompanion> messages;

  OutboxParams({this.limit = -1, this.offset = 0, this.orderingMode = OrderingMode.desc, this.status, this.messages});

  @override
  List<Object> get props => [limit, offset, orderingMode, status, messages];
}
