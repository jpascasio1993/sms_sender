import 'package:meta/meta.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/features/inbox/data/datasources/sms_source.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';

class InboxRepositoryImpl extends InboxRepository {
  SmsSource smsSource;

  InboxRepositoryImpl({@required this.smsSource});

  @override
  Future<List<SmsMessage>> getInbox(int limit, int offset) {
    return smsSource.getSms(limit, offset);
  }
  
}