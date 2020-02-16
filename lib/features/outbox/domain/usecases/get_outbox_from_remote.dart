 import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';

class GetOutboxFromRemote extends UseCase<List<OutboxModel>, OutboxParams> {
  OutboxRepository repository;

  GetOutboxFromRemote({@required this.repository});
  
  @override
  Future<Either<Failure, List<OutboxModel>>> call(OutboxParams params) async {
    final res = await repository.fetchOutboxRemote();
    return res;
  }
  
}