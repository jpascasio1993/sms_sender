import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'sms_event.dart';
import 'sms_state.dart';

class SMSBloc extends Bloc<SMSEvent, SMSState> {
  @override
  // TODO: implement initialState
  SMSState get initialState => SMSInitialState();

  @override
  Stream<SMSState> mapEventToState(
      SMSState currentState, SMSEvent event) async* {}
}
