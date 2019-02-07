import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'sms_event.dart';
import 'sms_state.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/resources/repository.dart';

class SMSBloc extends Bloc<SMSEvent, SMSState> {
  @override
  SMSState get initialState => SMSInitialState();

  @override
  Stream<SMSState> mapEventToState(
      SMSState currentState, SMSEvent event) async* {
    if (event is SMSFetchAllMessage) {
      List<SmsMessage> messages = await repository.fetchAllSMS();
      yield SMSFetchResult(data: messages);
    }
    // yield SMSInitialState();
  }
}
