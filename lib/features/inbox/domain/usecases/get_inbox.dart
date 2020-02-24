import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';

class GetInbox implements UseCase<List<InboxMessage>, InboxParams> {
  final InboxRepository repository;
  
  GetInbox({@required this.repository});
  
  @override
  Future<Either<Failure, List<InboxMessage>>> call(InboxParams params) async {
    return await repository.getInbox(params.limit, params.offset, params.status, params.orderingMode);
  }
}
