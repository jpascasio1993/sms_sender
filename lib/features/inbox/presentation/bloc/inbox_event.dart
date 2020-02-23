import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/database/database.dart';

@immutable
abstract class InboxEvent extends Equatable {
  final int limit;
  final int offset;
  final List<int> status;

  InboxEvent({@required this.limit, @required this.offset, this.status});

  @override
  List<Object> get props => [limit, offset, status];
}

class GetInboxEvent extends InboxEvent {
  GetInboxEvent({@required int limit, @required int offset, List<int> status})
      : super(limit: limit, offset: offset, status: status);

  @override
  String toString() {
    return 'GetInboxEvent';
  }
}

class LoadMoreInboxEvent extends InboxEvent {
  LoadMoreInboxEvent({@required int limit, @required int offset, List<int> status})
      : super(limit: limit, offset: offset, status: status);

  @override
  String toString() {
    return 'LoadMoreInboxEvent';
  }
}

class GetSmsAndSaveToDbEvent extends InboxEvent {
  final bool read;
  GetSmsAndSaveToDbEvent(
      {@required int limit, @required int offset, List<int> status, this.read = false})
      : super(limit: limit, offset: offset, status: status);

  @override
  String toString() {
    return 'GetSmsAndSaveToDbEvent';
  }

  @override
  List<Object> get props => [limit, offset, status, read];
}

class GetMoreInboxEvent extends InboxEvent {
  GetMoreInboxEvent({@required int limit, @required int offset, List<int> status})
      : super(limit: limit, offset: offset, status: status);

  @override
  String toString() {
    return 'GetMoreInboxEvent';
  }
}

class InboxUpdateEvent extends InboxEvent {
  final List<InboxMessagesCompanion> messages;

  InboxUpdateEvent(
      {@required this.messages, @required int limit, @required int offset})
      : super(limit: limit, offset: offset);

  @override
  String toString() {
    return 'InboxUpdateEvent';
  }
}

class AddInboxEvent extends InboxEvent {
  final Map<String, dynamic> data;

  AddInboxEvent({@required this.data});

  @override
  List<Object> get props => [data];
}
