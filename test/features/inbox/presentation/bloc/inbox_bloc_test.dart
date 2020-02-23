import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_sms_and_save_to_db.dart';
import 'package:sms_sender/features/inbox/domain/usecases/update_inbox.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';
import 'dart:convert';
import '../../../../fixtures/fixture_reader.dart';

class MockGetInbox extends Mock implements GetInbox {}

class MockGetSmsAndSaveToDb extends Mock implements GetSmsAndSaveToDb {}

class MockUpdateInbox extends Mock implements UpdateInbox {}

void main() {
  MockGetSmsAndSaveToDb mockGetSmsAndSaveToDb;
  MockGetInbox mockGetInbox;
  MockUpdateInbox mockUpdateInbox;
  InboxBloc inboxBloc;
  List<InboxMessage> messages;
  List<InboxMessage> messages2;
  List<InboxMessage> emptyMessages;
  setUp(() {
    mockGetSmsAndSaveToDb = MockGetSmsAndSaveToDb();
    mockGetInbox = MockGetInbox();
    mockUpdateInbox = MockUpdateInbox();
    inboxBloc = InboxBloc(
        getInbox: mockGetInbox,
        getSmsAndSaveToDb: mockGetSmsAndSaveToDb,
        updateInbox: mockUpdateInbox);
    messages = [InboxMessage.fromJson(json.decode(fixture('inbox.json')))];
    messages2 = List.from(messages);
    emptyMessages = [];
    // messages = [SmsMessage.fromJson(json.decode(fixture('inbox.json')))];
  });

  group('[INBOX] presentation/bloc GetInboxEvent', () {
    test('should retrieve list of sms', () async {
      //arrange
      when(mockGetInbox(any)).thenAnswer((_) async => Right(messages));

      //assert
      final expectedCalls = [
        InitialInboxState(inboxList: []),
        RetrievedInboxState.copyWith(
            state: inboxBloc.state, inboxList: messages)
      ];

      //act
      expectLater(inboxBloc, emitsInOrder(expectedCalls));

      inboxBloc.add(GetInboxEvent(limit: 0, offset: 0, status: [0]));
    });
  });

  group('[INBOX] presentation/bloc LoadMoreEvent', () {
    test('should load more messages', () async {
      //arrange
      when(mockGetInbox(any)).thenAnswer((_) async => Right(messages));

      //assert
      final expectedCalls = [
        InitialInboxState(inboxList: []),
        RetrievedInboxState.copyWith(
            state: inboxBloc.state,
            inboxList: inboxBloc.state.inboxList + messages)
      ];

      expectLater(inboxBloc, emitsInOrder(expectedCalls));

      //act
      inboxBloc.add(LoadMoreInboxEvent(limit: 0, offset: 0, status: [0]));
    });
  });

  group('[OUTBOX] presentation/bloc GetSmsAndSaveToDbEvent', () {
    test('should fetch from sms database and save to local', () async {
      // arrange
      when(mockGetSmsAndSaveToDb(any)).thenAnswer((_) async => Right(true));

      when(mockGetInbox(any)).thenAnswer((_) async => Right(messages2));

      // assert
      final expectedCalls = [
        InitialInboxState(inboxList: emptyMessages),
        RetrievedInboxState.copyWith(
            state: inboxBloc.state,
            inboxList: inboxBloc.state.inboxList + messages2)
      ];

      expectLater(inboxBloc, emitsInOrder(expectedCalls));

      // act
      inboxBloc.add(
          GetSmsAndSaveToDbEvent(limit: 0, offset: 0, read: false, status: [0]));
    });

    test('should return LocalFailure when failed fetching outbox from remote',
        () async {
      // arrange
      when(mockGetSmsAndSaveToDb(any)).thenAnswer(
          (_) async => Left(SMSFailure(message: inboxSmsInsertErrorMessage)));
      when(mockGetInbox(any)).thenAnswer((_) async => Right(messages2));
      // assert
      final expectedCalls = [
        InitialInboxState(inboxList: emptyMessages),
        InboxErrorState.copyWith(
            state: inboxBloc.state, message: inboxSmsInsertErrorMessage)
      ];

      expectLater(inboxBloc, emitsInOrder(expectedCalls));

      // act
      inboxBloc.add(
          GetSmsAndSaveToDbEvent(limit: 0, offset: 0, read: false, status: [0]));
    });
  });
}
