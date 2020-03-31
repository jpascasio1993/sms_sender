import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/outbox/usecase.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';

class DeleteOldInbox extends UseCase<int, InboxParams> {
  final InboxRepository repository;
  
  DeleteOldInbox({@required this.repository});
  
  @override
  Future<Either<Failure, int>> call(InboxParams params) async {
    return await repository.bulkDeleteOldInbox(params.date);
  }
}