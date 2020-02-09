import 'package:dartz/dartz.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

abstract class OutboxRepository {
  Future<Either<Failure, List<OutboxModel>>> getOutbox(int limit, int offset);
  Future<Either<Failure, List<OutboxModel>>> fetchOutboxRemote();
}
