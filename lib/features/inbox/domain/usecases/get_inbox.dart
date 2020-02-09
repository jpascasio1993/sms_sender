import 'package:meta/meta.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/sms_params.dart';

class GetInbox extends UseCase<List<SmsMessage>, SMSParams> {
  InboxRepository repository;
  
  GetInbox({@required this.repository});

  @override
  Future<List<SmsMessage>> call(SMSParams params) async {
    return await repository.getInbox(params.limit, params.offset);
  }
}
