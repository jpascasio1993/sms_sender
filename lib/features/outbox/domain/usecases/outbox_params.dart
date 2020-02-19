import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class OutboxParams extends Equatable {
  final int limit;
  final int offset;
  final int status;

  OutboxParams({@required this.limit, @required this.offset, this.status});

  @override
  List<Object> get props => [limit, offset, status];
}
