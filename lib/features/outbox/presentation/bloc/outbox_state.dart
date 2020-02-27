import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

@immutable
abstract class OutboxState extends Equatable {
  final List<OutboxModel> outboxList;
  OutboxState({@required this.outboxList});
  OutboxState.fromState({@required OutboxState state})
      : outboxList = state.outboxList;

  @override
  List<Object> get props => [outboxList];
}

class InitialOutboxState extends OutboxState {
  InitialOutboxState({@required List<OutboxModel> outboxList})
      : super(outboxList: outboxList);
  InitialOutboxState.fromState({@required OutboxState state})
      : super.fromState(state: state);

  @override
  String toString() {
    return 'InitialOutboxState';
  }
}

class RetrievedOutboxState extends OutboxState {
  RetrievedOutboxState._({@required OutboxState state})
      : super.fromState(state: state);

  factory RetrievedOutboxState.copyWith(
      {@required OutboxState state, List<OutboxModel> outboxList}) {
    return RetrievedOutboxState._(
        state: InitialOutboxState(outboxList: outboxList));
  }

  @override
  String toString() {
    return 'RetrievedOutboxState';
  }
}

class OutboxErrorState extends OutboxState {
  final String message;

  OutboxErrorState._({@required OutboxState state, this.message})
      : super.fromState(state: state);

  factory OutboxErrorState.copyWith(
      {@required OutboxState state, String message}) {
    return OutboxErrorState._(state: state, message: message);
  }

  @override
  List<Object> get props => [outboxList, message];

  @override
  String toString() {
    return 'OutboxErrorState';
  }
}

class OutboxErrorUpdateState extends OutboxState {
  final String message;

  OutboxErrorUpdateState._({@required OutboxState state, this.message})
      : super.fromState(state: state);

  factory OutboxErrorUpdateState.copyWith(
      {@required OutboxState state, String message}) {
    return OutboxErrorUpdateState._(state: state, message: message);
  }

  @override
  List<Object> get props => [outboxList, message];

  @override
  String toString() {
    return 'OutboxErrorState';
  }
}

class OutboxErrorDeleteState extends OutboxState {
  final String message;
  OutboxErrorDeleteState._({@required OutboxState state, this.message}): super.fromState(state: state);

  factory OutboxErrorDeleteState.copyWith({@required OutboxState state, String message}) {
    return OutboxErrorDeleteState._(state: state, message: message);
  }

  @override
  List<Object> get props => [outboxList, message];

  @override
  String toString() {
    return 'OutboxErrorDeleteState';
  }
}

class OutboxLoadingState extends OutboxState {
  OutboxLoadingState._({@required OutboxState state})
      : super.fromState(state: state);

  factory OutboxLoadingState.copyWith({@required OutboxState state}) {
    return OutboxLoadingState._(
        state: InitialOutboxState(outboxList: state.outboxList));
  }
  @override
  String toString() {
    return 'OutboxLoadingState';
  }
}
