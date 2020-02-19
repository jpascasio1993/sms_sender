import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionEvent extends Equatable {
  final List<PermissionGroup> permissions;

  PermissionEvent({@required this.permissions});

  @override
  List<Object> get props => [permissions];
}

class RequestPermissionEvent extends PermissionEvent {
  RequestPermissionEvent({@required List<PermissionGroup> permissions})
      : super(permissions: permissions);

  @override
  String toString() {
    return 'RequestPermissionEvent';
  }
}
