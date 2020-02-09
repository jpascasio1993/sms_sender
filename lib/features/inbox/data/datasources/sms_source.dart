import 'package:meta/meta.dart';
import 'package:sms/sms.dart';


abstract class SmsSource {
  Future<List<SmsMessage>> getSms(int limit, int offset);
}

class SmsSourceImpl extends SmsSource{
  SmsQuery smsQuery;

  SmsSourceImpl({@required this.smsQuery});  

  @override
  Future<List<SmsMessage>> getSms(int limit, int offset) async {
    return await smsQuery.querySms(start: offset, count: limit);
  }

}