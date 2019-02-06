import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'sms_event.dart';
import 'sms_state.dart';
import 'package:sms/sms.dart';
import 'dart:collection';

class SMSBloc extends Bloc<SMSEvent, SMSState> {
  SmsQuery query = SmsQuery();
  @override
  // TODO: implement initialState
  SMSState get initialState => SMSInitialState();

  @override
  Stream<SMSState> mapEventToState(
      SMSState currentState, SMSEvent event) async* {
    print('event $event');
    if (event is SMSFetchAllMessage) {
      List<SmsMessage> messages = await query.getAllSms;
      yield SMSFetchResult(data: UnmodifiableListView(messages));
    }
    // yield SMSInitialState();
  }
}
