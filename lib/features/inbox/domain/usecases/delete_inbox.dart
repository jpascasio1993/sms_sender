import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';

class DeleteInbox extends UseCase<bool, InboxParams> {
  final InboxRepository repository;
  DeleteInbox({@required this.repository});
  
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await repository.bulkDeleteInbox(params.messages);
  }
}