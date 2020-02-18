 import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/src/permission_enums.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/permission/data/datasources/permission_local_source.dart';
import 'package:sms_sender/features/permission/data/datasources/permission_remote_source.dart';
import 'package:sms_sender/features/permission/domain/repositories/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {

  final PermissionLocalSource localSource;
  final PermissionRemoteSource remoteSource;

  PermissionRepositoryImpl({@required this.localSource, @required this.remoteSource});
  
  @override
  Future<Either<Failure, bool>> saveInfo() async {
      try {
          await localSource.saveInfo();
          await remoteSource.setUpFirebase();
          return Right(true);
      } on PermissionException catch(e) {
        return Left(PermissionFailure(message: e.message));
      }
  }

  @override
  Future<Either<Failure, bool>> requestPermission(List<PermissionGroup> permissionGroup) async {
    try{
      final granted = await localSource.requestPermission(permissionGroup);
      return Right(granted);
    } on PermissionException catch(e) {
      return Left(PermissionFailure(message: e.message));
    }
    
  }
}