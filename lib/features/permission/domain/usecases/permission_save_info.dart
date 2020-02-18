import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/permission/domain/repositories/permission_repository.dart';
import 'package:sms_sender/features/permission/domain/usecases/permission_no_params.dart';

class PermissionSaveInfo extends UseCase<bool, PermissionNoParams> {
  final PermissionRepository repository;
  PermissionSaveInfo({@required this.repository});

  @override
  Future<Either<Failure, bool>> call(PermissionNoParams params) async {
    return await repository.saveInfo();
  }
  
}