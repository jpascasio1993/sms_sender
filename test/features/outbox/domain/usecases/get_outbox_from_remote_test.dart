import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox_from_remote.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';

class MockOutboxRepository extends Mock implements OutboxRepository {}

void main() {

  MockOutboxRepository mockOutboxRepository;
  GetOutboxFromRemote getOutboxFromRemote;
  List<OutboxModel> outboxList;

  setUp(() {
    mockOutboxRepository = MockOutboxRepository();
    getOutboxFromRemote = GetOutboxFromRemote(repository: mockOutboxRepository);
    outboxList = [];
  });

  group('[OUTBOX] domain/usecases GetOutboxFromRemote', (){
  
    test('should get outbox from remote', () async {
    
      // arrange 
      when(mockOutboxRepository.fetchOutboxRemote()).thenAnswer((_) async => Right(outboxList));

      // act 
      final res = await getOutboxFromRemote(OutboxParams(limit: 0, offset: 0));

      // assert 
      expect(res, Right(outboxList));

      verify(mockOutboxRepository.fetchOutboxRemote());
      
    });

    test('should return ServerFailure when fetching from remote', () async {
    
      // arrange 
      when(mockOutboxRepository.fetchOutboxRemote()).thenAnswer((_) async => Left(ServerFailure(message: remoteErrorMessage)));

      // act 
      final res = await getOutboxFromRemote(OutboxParams(limit: 0, offset: 0));

      // assert 
      expect(res, Left(ServerFailure(message: remoteErrorMessage)));

      verify(mockOutboxRepository.fetchOutboxRemote());
      
    });
  
  });

}