import 'package:bloc/bloc.dart';
import 'package:sms_sender/data/base_state.dart';
import 'package:sms_sender/models/sms_model.dart';
import 'package:sms/sms.dart';

abstract class SMSState extends BaseState<List<SmsMessage>> {
  SMSState(data) : super(data: data);

  @override
  bool get isRefetch => data.isNotEmpty;

  @override
  String toString() {
    return 'SMSState';
  }
}

class SMSInitialState extends SMSState {
  SMSInitialState({data}) : super(data ?? List<SmsMessage>());

  @override
  String toString() {
    return 'SMSInitialState';
  }
}

class SMSFetchResult extends SMSState {
  SMSFetchResult({data}) : super(data);

  @override
  String toString() {
    return 'SMSFetchResult';
  }
}
