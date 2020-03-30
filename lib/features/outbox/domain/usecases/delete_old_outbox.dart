import 'package:dartz/dartz.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/outbox/usecase.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';

class DeleteOldOutbox extends UseCase<int, OutboxParams> {
  final OutboxRepository repository;
  DeleteOldOutbox({this.repository});
  @override
  Future<Either<Failure, int>> call(OutboxParams params) async {
    return await repository.bulkDeleteOldOutbox(params.date);
  }
}