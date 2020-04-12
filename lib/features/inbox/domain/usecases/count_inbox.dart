import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';

class CountInbox extends UseCase<int, InboxParams> {
  final InboxRepository repository;
  CountInbox({@required this.repository});

  @override
  Future<Either<Failure, int>> call(InboxParams params) {
    return repository.countInbox(params.status);
  }

  
}