import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

@immutable
abstract class OutboxState extends Equatable {}

class InitialOutboxState extends OutboxState {
  final List<OutboxModel> outboxList;

  InitialOutboxState({@required this.outboxList});
  InitialOutboxState.fromState({@required InitialOutboxState state}): outboxList = state.outboxList ?? [];
  
  @override
  List<Object> get props => [outboxList];

  @override
  String toString() {
    return 'InitialOutboxState';
  }
}

class RetrievedOutboxState extends InitialOutboxState {

  RetrievedOutboxState._({@required InitialOutboxState state}): super.fromState(state: state);

  factory RetrievedOutboxState.copyWith({
    @required InitialOutboxState state,
    List<OutboxModel> outboxList
  }) {
    return RetrievedOutboxState._(state: InitialOutboxState(outboxList: outboxList));
  }

  @override
  List<Object> get props => [outboxList];

  @override
  String toString() {
    return 'RetrievedOutboxState';
  }
}

class OutboxErrorState extends InitialOutboxState {
  final String message;

  OutboxErrorState._({@required InitialOutboxState state, this.message}): super.fromState(state: state);

  factory OutboxErrorState.copyWith({
    @required InitialOutboxState state,
    String message
  }) {
    return OutboxErrorState._(state: state, message: message);
  }

  @override
  List<Object> get props => [outboxList, message];
  
  @override
  String toString() {
    return 'OutboxError';
  }
}