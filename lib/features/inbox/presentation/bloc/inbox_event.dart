import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InboxEvent extends Equatable {
  final int limit;
  final int offset;
  final bool sent;

  InboxEvent({@required this.limit, @required this.offset, this.sent});
}

class GetInboxEvent extends InboxEvent {
  

  GetInboxEvent({@required int limit, @required int offset, bool sent }): super(limit: limit, offset: offset, sent: sent);

  @override
  List<Object> get props => [limit, offset, sent];

  @override
  String toString() {
    return 'GetInboxEvent';
  }
}

class LoadMoreInboxEvent extends InboxEvent {
  LoadMoreInboxEvent({
      @required int limit, 
      @required int offset,
      bool sent
    }): super(limit: limit, offset: offset, sent: sent);

  @override
  List<Object> get props => [limit, offset, sent];

  @override
  String toString() {
    return 'LoadMoreInboxEvent';
  }
}

class GetSmsAndSaveToDbEvent extends InboxEvent {
  final bool read;
  GetSmsAndSaveToDbEvent({
      @required int limit, 
      @required int offset,
      bool sent, 
      this.read
    }): super(limit: limit, offset: offset, sent: sent);

  @override
  String toString() {
    return 'GetSmsAndSaveToDbEvent';
  }

  @override
  List<Object> get props => [limit, offset, sent, read];
}

class AddInboxEvent extends InboxEvent {
  final Map<String, dynamic> data;

  AddInboxEvent({@required this.data});

  @override
  List<Object> get props => [data];
}