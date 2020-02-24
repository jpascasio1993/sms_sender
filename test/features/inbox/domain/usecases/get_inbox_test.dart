
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';
import 'dart:convert';
import '../../../../fixtures/fixture_reader.dart';


class MockInboxRepository extends Mock implements InboxRepository {}

void main() {
  MockInboxRepository mockInboxRepository;
  List<InboxMessage> smsMessages;
  GetInbox getInbox;
  InboxParams params;
  int limit = 0;
  int offset = 0;
  List<int> status = [0];
  setUp(() {
    // SmsQueryKind kind = SmsQueryKind.Sent; 
    mockInboxRepository = MockInboxRepository();
    final Map map = json.decode(fixture('inbox.json'));
    // map.putIfAbsent('kind', () => kind);
    smsMessages = [InboxMessage.fromJson(map)];
    getInbox = GetInbox(repository: mockInboxRepository);
    params = InboxParams(limit: limit, offset: offset, status: status);
  });

  group('[INBOX] domain/usecases GetInbox', (){
    test('should retrieve sms messages', () async { 
  
    // arrange 
    when(mockInboxRepository.getInbox(limit, offset, status, OrderingMode.desc)).thenAnswer((_) async => Right(smsMessages));
    
    // act 
    final res = await getInbox(params);
    
    // assert 
    expect(res, Right(smsMessages));
    verify(mockInboxRepository.getInbox(any, any, any, OrderingMode.desc));

    });

    test('should return SMSFailure when retrieving sms messages', () async { 
  
    // arrange 
    when(mockInboxRepository.getInbox(any, any, any, any)).thenAnswer((_) async => Left(SMSFailure(message: inboxSmsRetrieveErrorMessage)));
    
    // act 
    final res = await getInbox(params);
    
    // assert 
    expect(res, Left(SMSFailure(message: inboxSmsRetrieveErrorMessage)));
    verify(mockInboxRepository.getInbox(any, any, any, any));

    });
  });
}