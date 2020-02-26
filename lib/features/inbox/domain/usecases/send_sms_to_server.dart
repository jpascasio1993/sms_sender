import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/global/constants.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';

class SendSmsToServer implements UseCase<bool, InboxParams> {
  final InboxRepository repository;

  SendSmsToServer({@required this.repository});
  
  @override
  Future<Either<Failure, bool>> call(InboxParams params) async {
    final messages = await repository.getInbox(params.limit, params.offset, params.status, params.orderingMode);
    return messages.fold(
      (failure) => Left(failure), 
      (msgs) => repository.sendSmsToServer(msgs).then((res) async {
        
        final updateSuccess = await repository.bulkUpdateInbox(
          msgs.map((msg) {
            int status = res.isRight() ? InboxStatus.processed: InboxStatus.failed;
             return InboxMessagesCompanion(
                id: Value(msg.id),
                status: Value(status),
                priority: Value(status != InboxStatus.processed ? msg.priority+1 : msg.priority)
              );
          }).toList()
        );
        return await updateSuccess.fold((failure) => Right(false), (success) => Right(success));
      }));
  }
}