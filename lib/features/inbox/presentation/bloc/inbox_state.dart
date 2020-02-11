import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sms/sms.dart';

@immutable
abstract class InboxState extends Equatable {}

class InitialInboxState extends InboxState {
  final List<SmsMessage> inboxList;

  InitialInboxState({@required this.inboxList});
  InitialInboxState.fromState({@required InitialInboxState state}): inboxList = state.inboxList ?? [];
  
  @override
  List<Object> get props => [inboxList];

  @override
  String toString() {
    return 'InitialInboxState';
  }
}

class RetrievedInboxState extends InitialInboxState {

  RetrievedInboxState._({@required InitialInboxState state}): super.fromState(state: state);

  factory RetrievedInboxState.copyWith({
    @required InitialInboxState state,
    List<SmsMessage> inboxList
  }) {
    return RetrievedInboxState._(state: InitialInboxState(inboxList: inboxList));
  }

  @override
  List<Object> get props => [inboxList];

  @override
  String toString() {
    return 'RetrievedInboxState';
  }
}

class InboxErrorState extends InitialInboxState {
  final String message;

  InboxErrorState._({@required InitialInboxState state, this.message}): super.fromState(state: state);

  factory InboxErrorState.copyWith({
    @required InitialInboxState state,
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