import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms/sms.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_source.dart';

class MockSmsQuery extends Mock implements SmsQuery {}

void main() {
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
    inboxSourceImpl = InboxSourceImpl(smsQuery: mockSmsQuery);
  });

  group('[INBOX] data/datasource InboxSource', (){

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