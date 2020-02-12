import 'package:meta/meta.dart';
import 'package:sms_sender/core/entities/base_entity.dart';

class Outbox extends BaseEntity {
  final String title;
  final String body;
  final String recipient;
  final String date;

  Outbox(
      {@required int id,
      @required this.title,
      @required this.body,
      @required this.recipient,
      @required this.date,
      @required bool sent})
      : super(id: id, sent: sent);

  @override
  List<Object> get props => [id, title, body, recipient, date, sent];
}

class OutboxStatus {
  static final int unsent = 0;
  static final int sent = 1;
  static final int failed = 2;
  static final int resend = 3;
}
