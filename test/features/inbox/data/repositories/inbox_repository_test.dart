import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';
import 'package:sms_sender/features/inbox/data/repositories/inbox_repository_impl.dart';

class MockInboxSource extends Mock implements InboxSource {}

void main() {
  MockInboxSource mockInboxSource;
  InboxRepositoryImpl inboxRepository;
  List<SmsMessage> messages;
  int limit = -1;
  int offset = 0;
  List<SmsQueryKind> querykinds;
  bool read;
  setUp((){
    messages = [];
    querykinds = [SmsQueryKind.Inbox];
    mockInboxSource = MockInboxSource();
    read = false;
    inboxRepository = InboxRepositoryImpl(inboxSource: mockInboxSource, queryKinds: querykinds, read: read);
  });

  group('[INBOX] data/datasources InboxRepositoryImpl :: ', (){
    test('should get list of sms messages through the repository', () async { 
  
    //arrange
      when(mockInboxSource.getSms(any, any, any, any)).thenAnswer((_) async => messages);

    //act
      final res = await inboxRepository.getInbox(limit, offset);

    //assert 
      expect(res, messages);
    });
  });
}