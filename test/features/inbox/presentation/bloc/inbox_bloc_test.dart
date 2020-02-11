import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_inbox.dart';
import 'package:sms_sender/features/inbox/presentation/bloc/bloc.dart';

class MockGetInbox extends Mock implements GetInbox {}

void main() {

  MockGetInbox mockGetInbox;
  InboxBloc inboxBloc;

  setUp((){
    mockGetInbox = MockGetInbox();
    inboxBloc = InboxBloc(getInbox: mockGetInbox);
  });

  group('[INBOX] presentation/bloc', (){
    test('', () async { 
    
     //arrange
    
     //act
    
     //assert 
    
    });
  });
}