import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_sms_and_save_to_db.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import './bloc.dart';
class InboxBloc extends Bloc<InboxEvent, InboxState> {
  final GetInbox getInbox;
  final GetSmsAndSaveToDb getSmsAndSaveToDb;
  
  InboxBloc({@required this.getInbox, @required this.getSmsAndSaveToDb}): assert(getInbox != null), assert(getSmsAndSaveToDb != null);

  @override
  InboxState get initialState => InitialInboxState(inboxList: []);

  @override
  Stream<InboxState> mapEventToState(InboxEvent event) async* {

    if(event is GetInboxEvent) {
      final res = await getInbox(InboxParams(limit: event.limit, offset: event.offset, sent: event.sent));
      // yield RetrievedInboxState.copyWith(state: state, inboxList: res);
      yield res.fold(
        (failure) => InboxErrorState.copyWith(state: state, message: failure.message), 
        (inboxList){
          return RetrievedInboxState.copyWith(state: state, inboxList: inboxList);
        });
    }
    else if(event is LoadMoreInboxEvent) {
      final res = await getInbox(InboxParams(limit: event.limit, offset: event.offset));
      yield res.fold(
        (failure) => InboxErrorState.copyWith(state: state, message: failure.message), 
        (inboxList) => RetrievedInboxState.copyWith(state: state, inboxList: state.inboxList + inboxList));
      // yield RetrievedInboxState.copyWith(state: state, inboxList: (state as InitialInboxState).inboxList + res);
    }
    else if(event is GetSmsAndSaveToDbEvent){
      final res = await getSmsAndSaveToDb(InboxParams(limit: event.limit, offset: event.offset, read: event.read));
      final res2 = await getInbox(InboxParams(limit: event.limit, offset: state.inboxList.length, sent: event.sent));
      yield* res2.fold(
         (failure) async* {
             yield InboxErrorState.copyWith(state: state, message: failure.message);
         }, 
         (inboxList) async* {
            yield res.fold(
                  (failure) => InboxErrorState.copyWith(state: state, message: failure.message), 
                  (success){
                    return RetrievedInboxState.copyWith(state: state, inboxList: state.inboxList + inboxList);
                  });
         });
     
    }
  }
}