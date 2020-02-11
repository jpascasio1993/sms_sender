import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class InboxParams extends Equatable {
  final int limit;
  final int offset;

  InboxParams({@required this.limit, @required this.offset});

  @override
  List<Object> get props => [limit, offset];
}
