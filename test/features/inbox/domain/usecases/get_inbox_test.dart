
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/inbox/data/repositories/inbox_repository_impl.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms/sms.dart';
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
  bool sent = false;
  setUp(() {
    // SmsQueryKind kind = SmsQueryKind.Sent; 
    mockInboxRepository = MockInboxRepository();
    final Map map = json.decode(fixture('inbox.json'));
    // map.putIfAbsent('kind', () => kind);
    smsMessages = [InboxMessage.fromJson(map)];
    getInbox = GetInbox(repository: mockInboxRepository);
    params = InboxParams(limit: limit, offset: offset, sent: sent);
  });

  group('[INBOX] domain/usecases GetInbox', (){
    test('should retrieve sms messages', () async { 
  
    // arrange 
    when(mockInboxRepository.getInbox(limit, offset, sent)).thenAnswer((_) async => Right(smsMessages));
    
    // act 
    final res = await getInbox(params);
    
    // assert 
    expect(res, Right(smsMessages));
    verify(mockInboxRepository.getInbox(any, any, any));

    });

    test('should return SMSFailure when retrieving sms messages', () async { 
  
    // arrange 
    when(mockInboxRepository.getInbox(limit, offset, sent)).thenAnswer((_) async => Left(SMSFailure(message: inboxSmsRetrieveErrorMessage)));
    
    // act 
    final res = await getInbox(params);
    
    // assert 
    expect(res, Left(SMSFailure(message: inboxSmsRetrieveErrorMessage)));
    verify(mockInboxRepository.getInbox(any, any, any));

    });
  });
}