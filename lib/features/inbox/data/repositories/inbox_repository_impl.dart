import 'package:meta/meta.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';

class InboxRepositoryImpl extends InboxRepository {
  InboxSource inboxSource;
  List<SmsQueryKind> queryKinds;
  bool read;

  InboxRepositoryImpl({@required this.inboxSource, this.queryKinds = const [SmsQueryKind.Inbox], this.read});

  @override
  Future<List<SmsMessage>> getInbox(int limit, int offset) {
    return inboxSource.getSms(limit, offset, queryKinds, read);
  }
  
}