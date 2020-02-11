import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'dart:convert';
import '../../../../fixtures/fixture_reader.dart';

class MockGetInbox extends Mock implements GetInbox {}

void main() {

  MockGetInbox mockGetInbox;
  InboxBloc inboxBloc;
  List<SmsMessage> messages;
  setUp((){
    mockGetInbox = MockGetInbox();
    inboxBloc = InboxBloc(getInbox: mockGetInbox);
    messages = [SmsMessage.fromJson(json.decode(fixture('inbox.json')))];
  });

  group('[INBOX] presentation/bloc GetInboxEvent', (){
    test('should retrieve list of sms', () async { 
    
      //arrange
      when(mockGetInbox(any)).thenAnswer((_) async => messages);
      
      //assert 
      final expectedCalls = [
        InitialInboxState(inboxList: []),
        RetrievedInboxState.copyWith(state: inboxBloc.state, inboxList: messages)
      ];

      //act
      expectLater(inboxBloc, emitsInOrder(expectedCalls));

      inboxBloc.add(GetInboxEvent(limit: 0, offset: 0, read: true));
    });
  });

  group('[INBOX] presentation/bloc LoadMoreEvent',(){
    test('should load more messages', () async {
    
      //arrange
      when(mockGetInbox(any)).thenAnswer((_) async => messages);

     //assert 
      final expectedCalls = [
        InitialInboxState(inboxList: []),
        RetrievedInboxState.copyWith(state: inboxBloc.state, inboxList: (inboxBloc.state as InitialInboxState).inboxList + messages)
      ];

      expectLater(inboxBloc, emitsInOrder(expectedCalls));

      //act
      inboxBloc.add(LoadMoreInboxEvent(limit: 0, offset: 0, read: true)); 
    
    });
  });
}