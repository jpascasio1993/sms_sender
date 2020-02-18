import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class Failure extends Equatable {
  final String message;
  Failure({@required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure({String message}) : super(message: message);
}

class LocalFailure extends Failure {
  LocalFailure({String message}) : super(message: message);
}

class SMSFailure extends Failure {
  SMSFailure({String message}) : super(message: message);
}
class PermissionFailure extends Failure {
  PermissionFailure({String message}) : super(message: message);
}