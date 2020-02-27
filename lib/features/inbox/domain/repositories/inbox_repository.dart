import 'package:dartz/dartz.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/failures.dart';

abstract class InboxRepository {
  Future<Either<Failure, List<InboxMessage>>> getInbox(
      int limit, int offset, List<int> status, OrderingMode orderingMode);
  Future<Either<Failure, bool>> getSmsAndSaveToDb(
      int limit, int offset, bool read);
  Future<Either<Failure, bool>> sendSmsToServer(List<InboxMessage> messages);
  Future<Either<Failure, bool>> bulkUpdateInbox(
      List<InboxMessagesCompanion> messages);
  Future<Either<Failure, bool>> bulkDeleteInbox(List<InboxMessagesCompanion> messages);
}
