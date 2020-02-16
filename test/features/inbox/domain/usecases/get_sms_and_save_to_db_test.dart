import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/inbox/data/repositories/inbox_repository_impl.dart';
import 'package:sms_sender/features/inbox/domain/repositories/inbox_repository.dart';
import 'package:sms_sender/features/inbox/domain/usecases/get_sms_and_save_to_db.dart';
import 'package:sms_sender/features/inbox/domain/usecases/inbox_params.dart';

class MockInboxRepository extends Mock implements InboxRepository {}

void main() {

  MockInboxRepository mockInboxRepository;
  GetSmsAndSaveToDb getSmsAndSaveToDb;
  
  setUp(() {
    mockInboxRepository = MockInboxRepository();
    getSmsAndSaveToDb = GetSmsAndSaveToDb(repository: mockInboxRepository);
  });

  group('[INBOX] domain/usecases GetSmsAndSaveToDb', (){
  
    test('should successfully saved sms to local db', () async {
    
      // arrange 
      when(mockInboxRepository.getSmsAndSaveToDb(0, 0, false)).thenAnswer((_) async => Right(true));

      // act 
      final res = await getSmsAndSaveToDb(InboxParams(limit: 0, offset: 0, read: false, sent: false));

      // assert 
      expect(res, Right(true));

      verify(mockInboxRepository.getSmsAndSaveToDb(0, 0, false));    
    });

    test('should return SMSFailure when saving sms to local db', () async {
    
      // arrange 
      when(mockInboxRepository.getSmsAndSaveToDb(0, 0, false)).thenAnswer((_) async => Left(SMSFailure(message: inboxSmsInsertErrorMessage)));

      // act 
      final res = await getSmsAndSaveToDb(InboxParams(limit: 0, offset: 0, read: false, sent: false));

      // assert 
      expect(res, Left(SMSFailure(message: inboxSmsInsertErrorMessage)));

      verify(mockInboxRepository.getSmsAndSaveToDb(0, 0, false));    
    });
  
  });

}