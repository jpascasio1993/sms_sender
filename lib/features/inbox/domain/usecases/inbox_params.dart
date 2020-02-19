import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class InboxParams extends Equatable {
  final int limit;
  final int offset;
  final bool read;
  final int status;

  InboxParams({this.limit = 20, @required this.offset, this.read, this.status});

  @override
  List<Object> get props => [limit, offset];
}
