import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class OutboxParams extends Equatable {
  final int limit;
  final int offset;

  OutboxParams({@required this.limit, @required this.offset});

  @override
  List<Object> get props => [limit, offset];
}
