import 'package:meta/meta.dart';
import 'package:sms_sender/core/entities/base_entity.dart';

class Outbox extends BaseEntity {
  final String title;
  final String body;
  final String sendTo;
  final String date;

  Outbox(
      {@required int id,
      @required this.title,
      @required this.body,
      @required this.sendTo,
      @required this.date,
      @required int status})
      : super(id: id, status: status);

  @override
  List<Object> get props => [id, title, body, sendTo, date, status];
}

class OutboxStatus {
  static final int unsent = 0;
  static final int sent = 1;
  static final int failed = 2;
  static final int resend = 3;
}
