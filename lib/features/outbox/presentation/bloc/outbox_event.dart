import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OutboxEvent extends Equatable {}

class GetOutbox extends OutboxEvent {
  final int limit;
  final int offset;

  GetOutbox({@required this.limit, @required this.offset});

  @override
  List<Object> get props => [limit, offset];

  @override
  String toString() {
    return 'GetOutboxEvent';
  }
}

class LoadMoreOutbox extends GetOutbox {
  LoadMoreOutbox({@required int limit, @required int offset}): super(limit: limit, offset: offset);

  @override
  String toString() {
    return 'LoadMoreOutboxEvent';
  }
}