import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SMSParams extends Equatable {
  final int limit;
  final int offset;

  SMSParams({@required this.limit, @required this.offset});

  @override
  List<Object> get props => [limit, offset];
}
