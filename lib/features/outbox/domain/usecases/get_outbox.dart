import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/outbox/usecase.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';

class GetOutbox implements UseCase<List<OutboxModel>, OutboxParams> {
  final OutboxRepository repository;

  GetOutbox({@required OutboxRepository outboxRepository})
      : repository = outboxRepository;

  @override
  Future<Either<Failure, List<OutboxModel>>> call(OutboxParams params) async {
    return await repository.getOutbox(params.limit, params.offset);
  }
}
