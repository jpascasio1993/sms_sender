import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/core/usecase/outbox/usecase.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';

class SendOutboxSms extends UseCase<bool, OutboxParams> {
  final OutboxRepository repository;

  SendOutboxSms({@required this.repository});

  @override
  Future<Either<Failure, bool>> call(OutboxParams params) async {
    final resMessages = await repository.getOutbox(params.limit, params.offset, params.status, params.orderingMode);

    return resMessages.fold(
      (failure) => Left(failure), 
      (messages) => repository.sendBulkSms(messages)
      .then((res) => res.fold(
        (failure) => Left(failure), 
        (updatedMessages) => repository.bulkUpdateOutbox(updatedMessages.map((val) => OutboxMessagesCompanion(
              id: Value(val.id),
              status: Value(val.status)
            )).toList()
          )
        )
      )
    );
  }
}