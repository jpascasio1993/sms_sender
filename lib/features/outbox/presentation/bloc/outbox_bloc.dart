import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox_from_remote.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';
import './bloc.dart';

class OutboxBloc extends Bloc<OutboxEvent, OutboxState> {
  final GetOutbox getOutbox;
  final GetOutboxFromRemote getOutboxFromRemote;

  OutboxBloc({@required this.getOutbox, @required this.getOutboxFromRemote})
      : assert(getOutbox != null);

  @override
  Stream<OutboxState> transformEvents(Stream<OutboxEvent> events, Stream<OutboxState> Function(OutboxEvent) next) {
    // TODO: implement transformEvents
    return super.transformEvents(events, next);
  }

  @override
  OutboxState get initialState => InitialOutboxState(outboxList: []);

  @override
  Stream<OutboxState> mapEventToState(OutboxEvent event) async* {
    
    if(state is OutboxLoadingState) {
      return;
    }

    if (event is GetOutboxEvent) {
      yield OutboxLoadingState.copyWith(state: state);
      final res = await getOutbox(
          OutboxParams(limit: event.limit, offset: event.offset));
      yield res.fold(
          (failure) =>
              OutboxErrorState.copyWith(state: state, message: failure.message),
          (outboxList) => RetrievedOutboxState.copyWith(
              state: state, outboxList: outboxList));
    } else if (event is LoadMoreOutboxEvent) {
      yield OutboxLoadingState.copyWith(state: state);
      final res = await getOutbox(
          OutboxParams(limit: event.limit, offset: event.offset));
      yield res.fold(
          (failure) =>
              OutboxErrorState.copyWith(state: state, message: failure.message),
          (outboxList) => RetrievedOutboxState.copyWith(
              state: state, outboxList: state.outboxList + outboxList));
    } else if (event is GetOutboxFromRemoteAndSaveToLocalEvent) {
      yield OutboxLoadingState.copyWith(state: state);
      final res = await getOutboxFromRemote(
          OutboxParams(limit: event.limit, offset: event.offset));
      final res2 = await getOutbox(OutboxParams(
          limit: event.limit ?? 0, offset: state.outboxList.length));

      yield* res.fold((failure) async* {
        yield OutboxErrorState.copyWith(state: state, message: failure.message);
      }, (remoteOutboxListResult) async* {
        yield res2.fold(
            (failure) => OutboxErrorState.copyWith(
                state: state, message: failure.message), (outboxList) {
          return RetrievedOutboxState.copyWith(
              state: state, outboxList: state.outboxList + outboxList);
        });
      });
    } else if(event is GetMoreOutboxEvent) {
      yield OutboxLoadingState.copyWith(state: state);
       final res = await getOutbox(
          OutboxParams(limit: event.limit, offset: event.offset));
      yield res.fold(
          (failure) =>
              OutboxErrorState.copyWith(state: state, message: failure.message),
          (outboxList) => RetrievedOutboxState.copyWith(
              state: state, outboxList: state.outboxList + outboxList));
    }
  }
}
