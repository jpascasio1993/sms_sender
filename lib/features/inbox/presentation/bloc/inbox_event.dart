import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InboxEvent extends Equatable {}

class GetInboxEvent extends InboxEvent {
  final int limit;
  final int offset;
  final bool sent;

  GetInboxEvent({@required this.limit, @required this.offset, this.sent });

  @override
  List<Object> get props => [limit, offset, sent];

  @override
  String toString() {
    return 'GetInboxEvent';
  }
}

class LoadMoreInboxEvent extends GetInboxEvent {
  LoadMoreInboxEvent({
      @required int limit, 
      @required int offset,
      bool sent, 
      bool read
    }): super(limit: limit, offset: offset, sent: sent);

  @override
  String toString() {
    return 'LoadMoreInboxEvent';
  }
}

class GetSmsAndSaveToDbEvent extends GetInboxEvent {
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
}

class AddInboxEvent extends InboxEvent {
  final Map<String, dynamic> data;

  AddInboxEvent({@required this.data});

  @override
  List<Object> get props => [data];
}