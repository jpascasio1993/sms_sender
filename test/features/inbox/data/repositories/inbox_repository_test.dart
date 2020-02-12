import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';
import 'package:sms_sender/features/inbox/data/repositories/inbox_repository_impl.dart';

class MockInboxSource extends Mock implements InboxSource {}
class MockAppDatabase extends Mock implements AppDatabase {}
class MockInboxMessageDao extends Mock implements InboxMessageDao {}

void main() {
  MockInboxSource mockInboxSource;
  MockAppDatabase mockAppDatabase;
  MockInboxMessageDao mockInboxMessageDao;
  InboxRepositoryImpl inboxRepository;
  List<InboxMessage> messages;
  int limit = -1;
  int offset = 0;
  List<SmsQueryKind> querykinds;
  bool sent;
  setUp((){
    messages = [];
    querykinds = [SmsQueryKind.Inbox];
    mockInboxSource = MockInboxSource();
    sent = false;
    mockAppDatabase = MockAppDatabase();
    mockInboxMessageDao = MockInboxMessageDao();
    inboxRepository = InboxRepositoryImpl(inboxSource: mockInboxSource, queryKinds: querykinds);
  });

  group('[INBOX] data/datasources InboxRepositoryImpl :: ', (){
    test('should get list of sms messages through the repository', () async { 
  
    //arrange
    // when(mockInboxSource.getSms(any, any, any, any)).thenAnswer((_) async => messages);
    // when(mockAppDatabase.inboxMessageDao).thenReturn(mockInboxMessageDao);
    when(mockInboxSource.getInbox(any, any, any)).thenAnswer((_) async => messages);

    //act
      final res = await inboxRepository.getInbox(limit, offset, sent);
    //assert 
      expect(res, Right(messages));
    });
  });
}