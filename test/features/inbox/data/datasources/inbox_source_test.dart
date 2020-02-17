import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';
import 'package:sms_sender/features/inbox/data/model/inbox_model.dart';

class MockSmsQuery extends Mock implements SmsQuery {}
class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  MockAppDatabase mockAppDatabase;
  MockSmsQuery mockSmsQuery;
  InboxSourceImpl inboxSourceImpl;
  List<SmsQueryKind> querykinds;
  bool read;
  int limit = -1;
  int offset = 0;
  List<SmsMessage> messages;
  
  setUp((){
    read = false;
    messages = [];
    querykinds = [SmsQueryKind.Inbox];
    mockSmsQuery = MockSmsQuery();
    mockAppDatabase = MockAppDatabase();
    inboxSourceImpl = InboxSourceImpl( appDatabase: mockAppDatabase, smsQuery: mockSmsQuery);
  });

  group('[INBOX] data/datasource InboxSourceImpl', (){

    test('should retrieve list of sms messages through datasource directly', () async { 
  
     //arrange
      when(mockSmsQuery.querySms(count: limit, start: offset, read: read, kinds: querykinds)).thenAnswer((_) async => messages);
     //act
      final res = await inboxSourceImpl.getSms(limit, offset, querykinds, read);

     //assert 
      expect(res, messages);
    });
    
  });
}