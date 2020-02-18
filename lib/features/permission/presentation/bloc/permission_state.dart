import 'package:equatable/equatable.dart';

abstract class PermissionState extends Equatable {
  @override
  List<Object> get props => null;
}

class InitialPermissionState extends PermissionState {
    @override
    String toString() {
      return 'InitialPermissionState';
    }
}

class PermissionGrantedState extends PermissionState {
  @override
  String toString() {
    return 'PermissionGrantedState';
  }
}

class PermissionDeniedState extends PermissionState {
  @override
  String toString() {
    return 'PermissionDeniedState';
  }
}

class PermissionErrorState extends PermissionState {
  final String message;
  PermissionErrorState({this.message});

  @override
  String toString() {
    return 'PermissionErrorState';
  }
}