import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/inbox/domain/usecases/delete_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_sms_and_save_to_db.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';
import 'package:sms_sender/features/inbox/domain/usecases/update_inbox.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import './bloc.dart';
import 'package:rxdart/rxdart.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  final GetInbox getInbox;
  final GetSmsAndSaveToDb getSmsAndSaveToDb;
  final UpdateInbox updateInbox;
  final DeleteInbox deleteInbox;

  InboxBloc(
      {@required this.getInbox,
      @required this.getSmsAndSaveToDb,
      @required this.updateInbox,
      @required this.deleteInbox})
      : assert(getInbox != null),
        assert(getSmsAndSaveToDb != null);

  @override
  Stream<InboxState> transformEvents(Stream<InboxEvent> events, Stream<InboxState> Function(InboxEvent) next) {
    return super.transformEvents(events.debounceTime(Duration(milliseconds: 250)), next);
  }

  @override
  InboxState get initialState => InitialInboxState(inboxList: []);

  @override
  Stream<InboxState> mapEventToState(InboxEvent event) async* {
    if (state is InboxLoadingState) {
      return;
    }

    if (event is GetInboxEvent) {
      yield InboxLoadingState.copyWith(state: state);

      final res = await getInbox(InboxParams(
          limit: event.limit, offset: event.offset, status: event.status));
      // yield RetrievedInboxState.copyWith(state: state, inboxList: res);
      yield res.fold(
          (failure) =>
              InboxErrorState.copyWith(state: state, message: failure.message),
          (inboxList) {
        return RetrievedInboxState.copyWith(state: state, inboxList: inboxList);
      });
    } else if (event is LoadMoreInboxEvent) {
      yield InboxLoadingState.copyWith(state: state);
      final res =
          await getInbox(InboxParams(limit: event.limit, offset: event.offset));
      yield res.fold(
          (failure) =>
              InboxErrorState.copyWith(state: state, message: failure.message),
          (inboxList) => RetrievedInboxState.copyWith(
              state: state, inboxList: state.inboxList + inboxList));
      // yield RetrievedInboxState.copyWith(state: state, inboxList: (state as InitialInboxState).inboxList + res);
    } else if (event is GetSmsAndSaveToDbEvent) {
      yield InboxLoadingState.copyWith(state: state);
      final res = await getSmsAndSaveToDb(InboxParams(
          limit: event.limit, offset: event.offset, read: event.read));
      final res2 = await getInbox(InboxParams(
          limit: event.limit,
          offset: state.inboxList.length,
          status: event.status));
      yield* res2.fold((failure) async* {
        yield InboxErrorState.copyWith(state: state, message: failure.message);
      }, (inboxList) async* {
        yield res.fold(
            (failure) => InboxErrorState.copyWith(
                state: state, message: failure.message), (success) {
          return RetrievedInboxState.copyWith(
              state: state, inboxList: state.inboxList + inboxList);
        });
      });
    } else if (event is GetMoreInboxEvent) {
      yield InboxLoadingState.copyWith(state: state);

      final res = await getInbox(InboxParams(
          limit: event.limit, offset: event.offset, status: event.status));
      // yield RetrievedInboxState.copyWith(state: state, inboxList: res);
      yield res.fold(
          (failure) =>
              InboxErrorState.copyWith(state: state, message: failure.message),
          (inboxList) {
        return RetrievedInboxState.copyWith(
            state: state, inboxList: state.inboxList + inboxList);
      });
    } else if (event is InboxUpdateEvent) {
      yield InboxLoadingState.copyWith(state: state);
      final res = await updateInbox(InboxParams(messages: event.messages));
      yield* res.fold((failure) async* {
        yield InboxErrorUpdateState.copyWith(
            state: state, message: failure.message);
      }, (success) async* {
        final res2 = await getInbox(
            InboxParams(limit: event.limit, offset: event.offset));
        yield res2.fold(
            (failure) => InboxErrorUpdateState.copyWith(
                state: state, message: failure.message), (inboxList) {
          return RetrievedInboxState.copyWith(
              state: state, inboxList: inboxList);
        });
      });
    } else if(event is InboxDeleteEvent) {
      yield InboxLoadingState.copyWith(state: state);
      final res = await deleteInbox(InboxParams(messages: event.messages));
      yield* res.fold((failure) async* {
        yield InboxErrorDeleteState.copyWith(state: state, message: failure.message);
      },(success) async* {
          final res2 = await getInbox(InboxParams(limit: event.limit, offset: event.offset));
          yield res2.fold(
            (failure) => InboxErrorDeleteState.copyWith(state: state, message: failure.message), 
            (inboxList) => RetrievedInboxState.copyWith(state: state, inboxList: inboxList));
      });
    }
  }
}
