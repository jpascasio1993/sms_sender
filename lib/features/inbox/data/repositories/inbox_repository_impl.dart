import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';

final String inboxSmsInsertErrorMessage = 'SMS Insert Error';
final String inboxSmsRetrieveErrorMessage = 'Inbox failed to retrieve';

class InboxRepositoryImpl extends InboxRepository {
  InboxSource inboxSource;
  List<SmsQueryKind> queryKinds;

  InboxRepositoryImpl({ @required this.inboxSource, this.queryKinds = const [SmsQueryKind.Inbox]});

  @override
  Future<Either<Failure, List<InboxMessage>>> getInbox(int limit, int offset, bool sent) async {
   try{
     final res = await inboxSource.getInbox(limit, offset, sent);
     return Right(res);
   }catch(error) {
     return Left(SMSFailure(message: inboxSmsRetrieveErrorMessage));
   }
  }

  @override
  Future<Either<Failure, bool>> getSmsAndSaveToDb(int limit, int offset, bool read) async {
    try {
      final res = await inboxSource.getSms(limit, offset, queryKinds, read);
      print('res ${res.length}');

      final inboxMessages = res.map((message) => InboxMessagesCompanion.insert(
        address: Value(message.address), 
        body: Value(message.body), 
        date: Value(DateFormat('yyyy-MM-dd hh:mm:ss a').format(message.date.toLocal())), 
        dateSent: Value(DateFormat('yyyy-MM-dd hh:mm:ss a').format(message.dateSent.toLocal()))
        )).toList(); 
      final insertRes = await inboxSource.insertInbox(inboxMessages);
      return Right(insertRes);
    }catch(error) {
      return Left(SMSFailure(message: inboxSmsInsertErrorMessage));
    }
  }
}