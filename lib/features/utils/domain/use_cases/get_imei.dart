import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/utils/datasources/util_source.dart';
import 'package:sms_sender/features/utils/domain/use_cases/util_no_params.dart';

class GetImei extends UseCase<String, UtilNoParams> {
  final UtilSource utilSource;

   GetImei({@required this.utilSource});

  @override
  Future<Either<Failure, String>> call(UtilNoParams params) {
    return Future.sync(() => Right(utilSource.imei));
  }

}