import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_sms_and_save_to_db.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'dart:convert';
import '../../../../fixtures/fixture_reader.dart';

class MockGetInbox extends Mock implements GetInbox {}
class MockGetSmsAndSaveToDb extends Mock implements GetSmsAndSaveToDb {}
void main() {
  MockGetSmsAndSaveToDb mockGetSmsAndSaveToDb;
  MockGetInbox mockGetInbox;
  InboxBloc inboxBloc;
  List<InboxMessage> messages;
  setUp((){
    mockGetSmsAndSaveToDb = MockGetSmsAndSaveToDb();
    mockGetInbox = MockGetInbox();
    inboxBloc = InboxBloc(getInbox: mockGetInbox, getSmsAndSaveToDb: mockGetSmsAndSaveToDb);
    messages = [InboxMessage.fromJson(json.decode(fixture('inbox.json')))];
    // messages = [SmsMessage.fromJson(json.decode(fixture('inbox.json')))];
  });

  group('[INBOX] presentation/bloc GetInboxEvent', (){
    test('should retrieve list of sms', () async { 
    
      //arrange
      when(mockGetInbox(any)).thenAnswer((_) async => Right(messages));
      
      //assert 
      final expectedCalls = [
        InitialInboxState(inboxList: []),
        RetrievedInboxState.copyWith(state: inboxBloc.state, inboxList: messages)
      ];

      //act
      expectLater(inboxBloc, emitsInOrder(expectedCalls));

      inboxBloc.add(GetInboxEvent(limit: 0, offset: 0, sent: true));
    });
  });

  group('[INBOX] presentation/bloc LoadMoreEvent',(){
    test('should load more messages', () async {
    
      //arrange
      when(mockGetInbox(any)).thenAnswer((_) async => Right(messages));

     //assert 
      final expectedCalls = [
        InitialInboxState(inboxList: []),
        RetrievedInboxState.copyWith(state: inboxBloc.state, inboxList: (inboxBloc.state as InitialInboxState).inboxList + messages)
      ];

      expectLater(inboxBloc, emitsInOrder(expectedCalls));

      //act
      inboxBloc.add(LoadMoreInboxEvent(limit: 0, offset: 0, sent: true)); 
    
    });
  });
}