import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class OutboxEvent extends Equatable {
  final int limit;
  final int offset;

  OutboxEvent({@required this.limit, @required this.offset});
  
  @override
  List<Object> get props => [limit, offset];
}

class GetOutboxEvent extends OutboxEvent {

  GetOutboxEvent({@required int limit, @required int offset}): super(limit: limit, offset: offset);

  @override
  String toString() {
    return 'GetOutboxEvent';
  }
}

class LoadMoreOutboxEvent extends OutboxEvent {

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

class GetOutboxFromRemoteAndSaveToLocalEvent extends OutboxEvent {

  GetOutboxFromRemoteAndSaveToLocalEvent();

  @override
  String toString() {
    return "GetOutboxFromRemoteAndSaveToLocalEvent";
  }
}