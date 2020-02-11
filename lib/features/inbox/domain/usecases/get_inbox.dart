import 'package:meta/meta.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/usecase/inbox/usecase.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';

class GetInbox extends UseCase<List<SmsMessage>, InboxParams> {
  InboxRepository repository;
  
  GetInbox({@required this.repository});

  @override
  Future<List<SmsMessage>> call(InboxParams params) async {
    return await repository.getInbox(params.limit, params.offset);
  }
}
