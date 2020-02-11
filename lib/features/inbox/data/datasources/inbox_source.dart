import 'package:meta/meta.dart';
import 'package:sms/sms.dart';


abstract class InboxSource {
  Future<List<SmsMessage>> getSms(int limit, int offset, List<SmsQueryKind> kinds, bool read);
}

class InboxSourceImpl extends InboxSource{
  SmsQuery smsQuery;

  InboxSourceImpl({@required this.smsQuery});  

  @override
  Future<List<SmsMessage>> getSms(int limit, int offset, List<SmsQueryKind> kinds, bool read) async {
    return await smsQuery.querySms(start: offset, count: limit, kinds: kinds, read: read);
  }
}