import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BaseEntity extends Equatable {
  final int id;
  final int status;
  BaseEntity({@required this.id, @required this.status});
}
