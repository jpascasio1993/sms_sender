
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/domain/usecases/sms_params.dart';
import 'dart:convert';
import '../../../fixtures/fixture_reader.dart';


class MockInboxRepository extends Mock implements InboxRepository {}

void main() {
  MockInboxRepository mockInboxRepository;
  List<SmsMessage> smsMessages;
  GetInbox getInbox;
  SMSParams params;
  setUp(() {
    // SmsQueryKind kind = SmsQueryKind.Sent; 
    mockInboxRepository = MockInboxRepository();
    final Map map = json.decode(fixture('inbox.json'));
    // map.putIfAbsent('kind', () => kind);
    smsMessages = [SmsMessage.fromJson(map)];
    getInbox = GetInbox(repository: mockInboxRepository);
    params = SMSParams(limit: 0, offset: 0);
  });

  test('should retrieve sms messages', () async { 
  
  // arrange 
  when(mockInboxRepository.getInbox(any, any)).thenAnswer((_) async => smsMessages);
  
  // act 
  final res = await getInbox(params);
  
  // assert 
  expect(res, smsMessages);
  verify(mockInboxRepository.getInbox(any, any));

  });
}