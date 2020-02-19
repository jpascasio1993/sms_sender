import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/database/database.dart';

@immutable
abstract class InboxState extends Equatable {
  final List<InboxMessage> inboxList;
  InboxState({@required this.inboxList});
  InboxState.fromState({@required InboxState state}): inboxList = state.inboxList;

  @override
  List<Object> get props => [inboxList];
}

class InitialInboxState extends InboxState {
  
  InitialInboxState({@required List<InboxMessage> inboxList}): super(inboxList: inboxList);
  // inboxList = state.inboxList ?? [], super(inboxList:  );
  InitialInboxState.fromState({@required InboxState state}): super.fromState(state: state);

  @override
  String toString() {
    return 'InitialInboxState';
  }
}

class RetrievedInboxState extends InboxState {

  RetrievedInboxState._({@required InboxState state}): super.fromState(state: state);

  factory RetrievedInboxState.copyWith({
    @required InboxState state,
    List<InboxMessage> inboxList
  }) {
    return RetrievedInboxState._(state: InitialInboxState(inboxList: inboxList));
  }

  @override
  String toString() {
    return 'RetrievedInboxState';
  }
}

class InboxErrorState extends InboxState {
  final String message;

  InboxErrorState._({@required InboxState state, this.message}): super.fromState(state: state);

  factory InboxErrorState.copyWith({
    @required InboxState state,
    String message
  }) {
    return InboxErrorState._(state: state, message: message);
  }

  @override
  List<Object> get props => [inboxList, message];
  
  @override
  String toString() {
    return 'InboxError';
  }
}

class InboxLoadingState extends InboxState {
  InboxLoadingState._({@required InboxState state}): super.fromState(state: state);

  factory InboxLoadingState.copyWith({
    @required InboxState state,
    String message
  }) {
    return InboxLoadingState._(state: state);
  }
  
  @override
  String toString() {
    return 'InboxLoadingState';
  }
}