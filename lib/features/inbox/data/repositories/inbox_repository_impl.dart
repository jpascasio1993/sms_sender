import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_remote_source.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';

class InboxRepositoryImpl extends InboxRepository {
  final InboxSource inboxSource;
  final InboxRemoteSource inboxRemoteSource;

  final List<SmsQueryKind> queryKinds;

  InboxRepositoryImpl(
      {@required this.inboxSource,
      @required this.inboxRemoteSource,
      this.queryKinds = const [SmsQueryKind.Inbox]});

  @override
  Future<Either<Failure, List<InboxMessage>>> getInbox(
      int limit, int offset, List<int> status) async {
    try {
      final res = await inboxSource.getInbox(limit, offset, status);
      return Right(res);
    } on SMSException catch (error) {
      return Left(SMSFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, bool>> getSmsAndSaveToDb(
      int limit, int offset, bool read) async {
    try {
      final res = await inboxSource.getSms(limit, offset, queryKinds, read);
      debugPrint('getSms ${res.map((val) => val.id).toList()}');

      final inboxMessages = res
          .map((message) => InboxMessagesCompanion.insert(
              address: Value(message.address),
              body: Value(message.body),
              date: Value(DateFormat('yyyy-MM-dd hh:mm:ss a')
                  .format(message.date.toLocal())),
              dateSent: Value(DateFormat('yyyy-MM-dd hh:mm:ss a')
                  .format(message.dateSent.toLocal()))))
          .toList();
      final insertRes = await inboxSource
      .insertInbox(inboxMessages)
      .then((success) => inboxSource.updateSmsReadStatus(res.map((val) => val.id).toList()));
      return Right(insertRes);
    } on SMSException catch (error) {
      return Left(SMSFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, bool>> sendSmsToServer(
      List<InboxMessage> messages) async {
    try {
      final res = await inboxRemoteSource.sendInboxToServer(messages);
      return Right(res);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    }
  }

  @override
  Future<Either<Failure, bool>> bulkUpdateInbox(
      List<InboxMessagesCompanion> messages) async {
    try {
      final res = await inboxSource.bulkUpdateInbox(messages);
      return Right(res);
    } on SMSException catch (error) {
      return Left(SMSFailure(message: error.message));
    }
  }
}
