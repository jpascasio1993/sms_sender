
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/data/repositories/outbox_repository_impl.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetOutbox extends Mock implements GetOutbox {}


void main(){
  OutboxBloc outboxBloc;
  MockGetOutbox mockGetOutbox;
  List<OutboxModel> outboxList;
  List<OutboxModel> emptyList;
  List sampleData;
  int limit;
  int offset;
  OutboxParams params;
  
  setUp((){
    limit = 0;
    offset = 0;
    emptyList = [];
    outboxList = [];
    mockGetOutbox = MockGetOutbox();
    outboxBloc = OutboxBloc(getOutbox: mockGetOutbox);
    sampleData = json.decode(fixture('outbox.json'));
    sampleData.forEach((any) => outboxList.add(OutboxModel.fromJson(any)));
    params = OutboxParams(limit: limit, offset: offset);
  });

 

  group('[OUTBOX] presentation/bloc Outbox BLOC GetOutboxEvent ::',(){

    test('initial state should be empty list', () async { 
      expect(outboxBloc.initialState, InitialOutboxState(outboxList: emptyList));
    });

    test('should call local repository and return list of outbox', () async { 
     //arrange
      when(mockGetOutbox(any)).thenAnswer((_) async => Right(outboxList));

     //act
      outboxBloc.add(GetOutboxEvent(limit: limit, offset: offset));
      await untilCalled(mockGetOutbox(any));
      
     //assert
      verify(mockGetOutbox(params));
    });

    test('should fail getting outbox', () async { 
    
     //arrange
      when(mockGetOutbox(any)).thenAnswer((_) async => Left(LocalFailure(message: localErrorMessage)));

     //assert 
      final expectedCalls = [
        InitialOutboxState(outboxList: emptyList),
        OutboxErrorState.copyWith(state: outboxBloc.state, message: localErrorMessage)
      ];

      expectLater(outboxBloc, emitsInOrder(expectedCalls));

      //act
      outboxBloc.add(GetOutboxEvent(limit: limit, offset: offset)); 

    });

    test('should get outbox list', () async { 
    
     //arrange
      when(mockGetOutbox(any)).thenAnswer((_) async => Right(outboxList));

     //assert 
      final expectedCalls = [
        InitialOutboxState(outboxList: emptyList),
        RetrievedOutboxState.copyWith(state: outboxBloc.state, outboxList: outboxList)
      ];

      expectLater(outboxBloc, emitsInOrder(expectedCalls));

      //act
      outboxBloc.add(GetOutboxEvent(limit: limit, offset: offset)); 

    });
  });

  group('[OUTBOX] presentation/bloc LoadMoreEvent',(){
    test('should load more outbox messages', () async {
    
      //arrange
      when(mockGetOutbox(any)).thenAnswer((_) async => Right(outboxList));

     //assert 
      final expectedCalls = [
        InitialOutboxState(outboxList: emptyList),
        RetrievedOutboxState.copyWith(state: outboxBloc.state, outboxList: (outboxBloc.state as InitialOutboxState).outboxList + outboxList)
      ];

      expectLater(outboxBloc, emitsInOrder(expectedCalls));

      //act
      outboxBloc.add(LoadMoreOutboxEvent(limit: limit, offset: offset)); 
    
    });
  });


  
}