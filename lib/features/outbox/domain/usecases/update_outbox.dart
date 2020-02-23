import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/outbox/usecase.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';

class UpdateOutbox extends UseCase<bool, OutboxParams> {
  final OutboxRepository repository;

  UpdateOutbox({@required this.repository});

  @override
  Future<Either<Failure, bool>> call(OutboxParams params) async {
    return await repository.bulkUpdateOutbox(params.messages);
  }
}
