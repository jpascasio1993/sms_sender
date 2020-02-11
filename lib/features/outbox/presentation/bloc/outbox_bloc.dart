import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';
import './bloc.dart';
class OutboxBloc extends Bloc<OutboxEvent, OutboxState> {
  final GetOutbox getOutbox;
  
  OutboxBloc({@required this.getOutbox}): assert(getOutbox != null);

  @override
  OutboxState get initialState => InitialOutboxState(outboxList: []);

  @override
  Stream<OutboxState> mapEventToState(OutboxEvent event) async* {
    if(event is GetOutboxEvent) {
      final res = await getOutbox(OutboxParams(limit: event.limit, offset: event.offset));
      yield res.fold(
      (failure) => OutboxErrorState.copyWith(state: state, message: failure.message), 
      (outboxList) => RetrievedOutboxState.copyWith(state: state, outboxList: outboxList));
    }
    else if(event is LoadMoreOutboxEvent) {
      final res = await getOutbox(OutboxParams(limit: event.limit, offset: event.offset));
      yield res.fold(
        (failure) => OutboxErrorState.copyWith(state: state, message: failure.message), 
      (outboxList) => RetrievedOutboxState.copyWith(state: state, outboxList: (state as InitialOutboxState).outboxList + outboxList));
    }
  }
}