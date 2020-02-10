import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';

@immutable
abstract class OutboxState extends Equatable {}

class InitialOutboxState extends OutboxState {
  final List<OutboxModel> outboxList = [];

  @override
  List<Object> get props => [outboxList];

  @override
  String toString() {
    return 'InitialOutboxState';
  }
}

class RetrievedOutboxState extends OutboxState {
  final List<OutboxModel> outboxList;
  RetrievedOutboxState({@required this.outboxList});

  @override
  List<Object> get props => [outboxList];

  @override
  String toString() {
    return 'RetrievedOutboxState';
  }
}

class OutboxError extends OutboxState {
  final String message;
  OutboxError({@required this.message});

  @override
  List<Object> get props => [message];
  
  @override
  String toString() {
    return 'OutboxError';
  }
}