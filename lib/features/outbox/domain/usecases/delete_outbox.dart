import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';

class DeleteOutbox extends UseCase<bool, OutboxParams> {
  final OutboxRepository repository;
  DeleteOutbox({@required this.repository});
  
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.bulkDeleteOutbox(params.messages);
  }
}