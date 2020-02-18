import 'package:equatable/equatable.dart';

abstract class PermissionEvent extends Equatable {
  @override
  List<Object> get props => null;
}

class RequestPermissionEvent extends PermissionEvent {
  
  @override
  String toString() {
    return 'RequestPermissionEvent';
  }  
}