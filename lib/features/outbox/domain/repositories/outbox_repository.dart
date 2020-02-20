import 'package:dartz/dartz.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

abstract class OutboxRepository {
  Future<Either<Failure, List<OutboxModel>>> getOutbox(
      int limit, int offset, int status);
  Future<Either<Failure, List<OutboxModel>>> fetchOutboxRemote();
  Future<Either<Failure, bool>> bulkUpdateOutbox(
      List<OutboxMessagesCompanion> messages);
}
