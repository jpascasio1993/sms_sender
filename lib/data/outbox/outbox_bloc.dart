import 'package:bloc/bloc.dart';
import 'package:sms_sender/data/outbox/outbox_event.dart';
import 'package:sms_sender/data/outbox/outbox_state.dart';
import 'package:sms_sender/models/outbox_model.dart';
import 'package:sms_sender/resources/repository.dart';

class OutboxBloc extends Bloc<OutboxEvent, OutboxState> {
  @override
  get initialState => OutboxInitialState();

  @override
  Stream<OutboxState> mapEventToState(
      OutboxState currentState, OutboxEvent event) async* {
    if (event is OutboxFetchAll) {
      List<OutboxModel> outbox = await repository.fetchAllOutbox();
      yield OutboxFetchResult(data: outbox);
    }
  }
}
