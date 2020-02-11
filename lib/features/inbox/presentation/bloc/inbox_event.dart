import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class InboxEvent extends Equatable {}

class GetInboxEvent extends InboxEvent {
  final int limit;
  final int offset;
  final bool read;

  GetInboxEvent({@required this.limit, @required this.offset, this.read });

  @override
  List<Object> get props => [limit, offset, read];

  @override
  String toString() {
    return 'GetInboxEvent';
  }
}

class LoadMoreInboxEvent extends GetInboxEvent {
  LoadMoreInboxEvent({@required int limit, @required int offset, bool read}): super(limit: limit, offset: offset, read: read);

  @override
  String toString() {
    return 'LoadMoreInboxEvent';
  }
}

class AddInboxEvent extends InboxEvent {
  final Map<String, dynamic> data;

  AddInboxEvent({@required this.data});

  @override
  List<Object> get props => [data];
}