import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OutboxEvent extends Equatable {}

class GetOutboxEvent extends OutboxEvent {
  final int limit;
  final int offset;

  GetOutboxEvent({@required this.limit, @required this.offset});

  @override
  List<Object> get props => [limit, offset];

  @override
  String toString() {
    return 'GetOutboxEvent';
  }
}

class LoadMoreOutboxEvent extends GetOutboxEvent {
  LoadMoreOutboxEvent({@required int limit, @required int offset}): super(limit: limit, offset: offset);

  @override
  String toString() {
    return 'LoadMoreOutboxEvent';
  }
}

class AddOutboxEvent extends OutboxEvent {
  final Map<String, dynamic> data;

  AddOutboxEvent({@required this.data});

  @override
  List<Object> get props => [data];
}