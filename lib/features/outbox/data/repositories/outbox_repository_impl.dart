import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/outbox/data/datasources/local_source.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';

class OutboxRepositoryImpl implements OutboxRepository {
  final RemoteSource remoteSource;
  final LocalSource localSource;

  OutboxRepositoryImpl(
      {@required this.remoteSource, @required this.localSource});

  @override
  Future<Either<Failure, List<OutboxModel>>> getOutbox(
      int limit, int offset, List<int> status, OrderingMode orderingMode) async {
    try {
      final res = await localSource.getOutbox(limit, offset, status, orderingMode);
      return Right(res);
    } on LocalException catch (error) {
      return Left(LocalFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, List<OutboxModel>>> fetchOutboxRemote() async {
    try {
      final res = await remoteSource.getOutbox();
      await localSource.bulkInsertOutbox(res);
      return Right(res);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on LocalException catch (error) {
      return Left(LocalFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, bool>> bulkUpdateOutbox(
      List<OutboxMessagesCompanion> messages) async {
    try {
      final res = await localSource.bulkUpdateOutbox(messages);
      return Right(res);
    } on LocalException catch (error) {
      return Left(LocalFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, List<OutboxModel>>> sendBulkSms(List<OutboxModel> messages) async {
      try {
        final res = await localSource.sendBulkSms(messages);
        return Right(res);
      } on LocalException catch(error) {
        return Left(LocalFailure(message: error.message));
      }
  }
}
