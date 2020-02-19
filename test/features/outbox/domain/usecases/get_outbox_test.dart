import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/domain/repositories/outbox_repository.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';

class MockOutboxRepository extends Mock implements OutboxRepository {}

void main() {
  GetOutbox getOutboxUseCase;
  MockOutboxRepository mockOutboxRepository;
  int offset = 0;
  int limit = 0;
  int status;
  List<OutboxModel> outboxRes;
  OutboxParams params;
  
  setUp(() {
    offset = 0;
    limit = 0;
    outboxRes = [
      OutboxModel(
          id: 0,
          body: 'test',
          recipient: '09123456789',
          date: '2020-02-09 21:13:10',
          status: 0,
          title: 'title')
    ];
    params = OutboxParams(limit: limit, offset: offset);
    mockOutboxRepository = MockOutboxRepository();
    getOutboxUseCase = GetOutbox(outboxRepository: mockOutboxRepository);
  });

  group('[OUTBOX] domain/usecases GetOutboxUseCase :: ', (){
    test('Should get outbox list', () async {
        // arrange
      when(mockOutboxRepository.getOutbox(limit, offset, status))
          .thenAnswer((_) async => Right(outboxRes));

      // act
      final result = await getOutboxUseCase(params);

      // assert
      expect(result, Right(outboxRes));

      verify(mockOutboxRepository.getOutbox(limit, offset, status));
    });
  });
  
}
