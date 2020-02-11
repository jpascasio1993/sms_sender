import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import './bloc.dart';
class InboxBloc extends Bloc<InboxEvent, InboxState> {
  final GetInbox getInbox;
  
  InboxBloc({@required this.getInbox}): assert(getInbox != null);

  @override
  InboxState get initialState => InitialInboxState(inboxList: []);

  @override
  Stream<InboxState> mapEventToState(InboxEvent event) async* {
    if(event is GetInboxEvent) {
      final res = await getInbox(InboxParams(limit: event.limit, offset: event.offset));
      yield RetrievedInboxState.copyWith(state: state, inboxList: res);
    }
    else if(event is LoadMoreInboxEvent) {
      final res = await getInbox(InboxParams(limit: event.limit, offset: event.offset));
      yield RetrievedInboxState.copyWith(state: state, inboxList: (state as InitialInboxState).inboxList + res);
    }
  }
}