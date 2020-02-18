import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionParams extends Equatable{
  final List<PermissionGroup> permissionGroups;
  PermissionParams({this.permissionGroups});
  @override
  List<Object> get props => [permissionGroups];
}