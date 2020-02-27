import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/database/database.dart';

@immutable
abstract class OutboxEvent extends Equatable {
  final int limit;
  final int offset;

  OutboxEvent({this.limit, this.offset});

  @override
  List<Object> get props => [limit, offset];
}

class GetOutboxEvent extends OutboxEvent {
  GetOutboxEvent({@required int limit, @required int offset})
      : super(limit: limit, offset: offset);

  @override
  String toString() {
    return 'GetOutboxEvent';
  }
}

class LoadMoreOutboxEvent extends OutboxEvent {
  LoadMoreOutboxEvent({@required int limit, @required int offset})
      : super(limit: limit, offset: offset);

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
  GetOutboxFromRemoteAndSaveToLocalEvent(
      {@required int limit, @required int offset})
      : super(limit: limit, offset: offset);

  @override
  String toString() {
    return "GetOutboxFromRemoteAndSaveToLocalEvent";
  }
}

class GetMoreOutboxEvent extends OutboxEvent {
  GetMoreOutboxEvent({@required int limit, @required int offset})
      : super(limit: limit, offset: offset);

  @override
  String toString() {
    return 'GetMoreOutboxEvent';
  }
}

class OutboxUpdateEvent extends OutboxEvent {
  final List<OutboxMessagesCompanion> messages;

  OutboxUpdateEvent(
      {@required this.messages, @required int limit, @required int offset})
      : super(limit: limit, offset: offset);

  @override
  String toString() {
    return 'OutboxUpdateEvent';
  }
}

class OutboxDeleteEvent extends OutboxEvent {
  final List<OutboxMessagesCompanion> messages;

  OutboxDeleteEvent({@required this.messages, @required int limit, @required int offset}): super(limit: limit, offset: offset);

  @override
  String toString() {
    return 'OutboxDeleteEvent';
  }
}
