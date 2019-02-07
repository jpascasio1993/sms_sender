import 'package:sms_sender/data/base_state.dart';

import 'package:sms_sender/models/outbox_model.dart';

abstract class OutboxState extends BaseState<List<OutboxModel>> {
  OutboxState(data) : super(data: data);

  @override
  String toString() {
    return 'OutboxState';
  }
}

class OutboxInitialState extends OutboxState {
  OutboxInitialState({data}) : super(data ?? List<OutboxModel>());

  @override
  String toString() {
    return 'OutboxInitialState';
  }
}

class OutboxFetchResult extends OutboxState {
  OutboxFetchResult({data}) : super(data);

  @override
  String toString() {
    return 'OutboxFetchResult';
  }
}
