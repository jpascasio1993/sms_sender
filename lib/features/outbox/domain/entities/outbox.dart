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
      @required int status})
      : super(id: id, status: status);

  @override
  List<Object> get props => [id, title, body, recipient, date, status];
}
