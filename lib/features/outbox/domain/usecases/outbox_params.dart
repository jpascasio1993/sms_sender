import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class OutboxParams extends Equatable {
  final int limit;
  final int offset;
  final bool sent;

  OutboxParams({@required this.limit, @required this.offset, this.sent});

  @override
  List<Object> get props => [limit, offset, sent];
}
