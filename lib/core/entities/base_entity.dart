import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BaseEntity extends Equatable {
  final int id;
  final bool sent;
  BaseEntity({@required this.id, @required this.sent});
}
