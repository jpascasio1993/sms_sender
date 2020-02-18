import 'package:dartz/dartz.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_sender/core/error/failures.dart';

abstract class PermissionRepository {
  Future<Either<Failure, bool>> saveInfo();
  Future<Either<Failure, bool>> requestPermission(List<PermissionGroup> permissionGroup);
}