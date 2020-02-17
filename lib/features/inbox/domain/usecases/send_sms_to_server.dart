import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';

class SendSmsToServer implements UseCase<bool, InboxParams> {
  final InboxRepository repository;

  SendSmsToServer({@required this.repository});
  
  @override
  Future<Either<Failure, bool>> call(InboxParams params) async {
    final messages = await repository.getInbox(params.limit, params.offset, params.sent);
    return messages.fold(
      (failure) => Left(failure), 
      (msgs) => repository.sendSmsToServer(msgs));
  }
}