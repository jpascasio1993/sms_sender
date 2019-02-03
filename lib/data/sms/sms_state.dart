import 'package:bloc/bloc.dart';
import 'package:sms_sender/data/base_state.dart';
import 'package:sms_sender/models/sms_model.dart';

abstract class SMSState extends BaseState<SMSModel> {
  SMSState(data) : super(data: data);

  @override
  bool get isRefetch => data.results.isNotEmpty;

  @override
  String toString() {
    return 'SMSState';
  }
}

class SMSInitialState extends SMSState {
  SMSInitialState({data}) : super(data ?? SMSModel());

  @override
  String toString() {
    return 'SMSInitialState';
  }
}
