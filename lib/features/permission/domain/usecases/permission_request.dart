import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/permission/domain/repositories/permission_repository.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_params.dart';

class PermissionRequest extends UseCase<bool, PermissionParams> {
  final PermissionRepository repository;

  PermissionRequest({@required this.repository});

  @override
  Future<Either<Failure, bool>> call(PermissionParams params) async {
    return await repository.requestPermission(params.permissionGroups);
  }
}