import 'package:bloc/bloc.dart';
import 'package:sms_sender/data/outbox/outbox_event.dart';
import 'package:sms_sender/data/outbox/outbox_state.dart';
import 'package:sms_sender/models/outbox_model.dart';
import 'package:sms_sender/resources/repository.dart';
import 'package:sms/sms.dart';

class OutboxBloc extends Bloc<OutboxEvent, OutboxState> {
  @override
  get initialState => OutboxInitialState();

  @override
  Stream<OutboxState> mapEventToState(
      OutboxState currentState, OutboxEvent event) async* {
    if (event is OutboxFetchAll) {
      List<OutboxModel> outbox = await repository.fetchAllOutbox();
      yield OutboxFetchResult(data: outbox);
    } else if (event is OutboxSendSms) {
      SmsMessage msg = await repository.sendOutboxSms(event.outbox);
      // SmsSender sender = new SmsSender();
      // String address = "+639065280984";
      // sender.sendSms(SmsMessage(address,
      //     "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."));
      print('msg ${msg.body}');
      //print('test msg');
      yield currentState;
    }
  }
}
