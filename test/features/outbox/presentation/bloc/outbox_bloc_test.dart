
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'dart:convert';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox.dart';
import 'package:sms_sender/features/outbox/domain/usecases/get_outbox_from_remote.dart';
import 'package:sms_sender/features/outbox/domain/usecases/outbox_params.dart';
import 'package:sms_sender/features/outbox/presentation/bloc/bloc.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockGetOutbox extends Mock implements GetOutbox {}
class MockGetOutboxFromRemote extends Mock implements GetOutboxFromRemote {}

void main(){
  OutboxBloc outboxBloc;
  MockGetOutbox mockGetOutbox;
  MockGetOutboxFromRemote mockGetOutboxFromRemote;
  List<OutboxModel> outboxList;
  List<OutboxModel> emptyList;
  List<OutboxModel> outboxList2;
  List sampleData;
  int limit;
  int offset;
  OutboxParams params;
  
  setUp((){
    limit = 0;
    offset = 0;
    emptyList = [];
    outboxList = [];
    outboxList2 = [];
    mockGetOutbox = MockGetOutbox();
    mockGetOutboxFromRemote = MockGetOutboxFromRemote();
    outboxBloc = OutboxBloc(getOutbox: mockGetOutbox, getOutboxFromRemote: mockGetOutboxFromRemote);
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
        RetrievedOutboxState.copyWith(state: outboxBloc.state, outboxList: outboxBloc.state.outboxList + outboxList)
      ];

      expectLater(outboxBloc, emitsInOrder(expectedCalls));

      //act
      outboxBloc.add(LoadMoreOutboxEvent(limit: limit, offset: offset)); 
    
    });
  });

  group('[OUTBOX] presentation/bloc GetOutboxFromRemoteAndSaveToLocalEvent', (){
    
    test('should fetch from outbox from remote and save to local', () async {
    
      // arrange 
      when(mockGetOutboxFromRemote(any)).thenAnswer((_) async => Right(outboxList));
      
      when(mockGetOutbox(any)).thenAnswer((_) async => Right(outboxList2));

      // assert 
      final expectedCalls = [
        InitialOutboxState(outboxList: emptyList),
        RetrievedOutboxState.copyWith(state: outboxBloc.state, outboxList: outboxBloc.state.outboxList + outboxList2)
      ];

      expectLater(outboxBloc, emitsInOrder(expectedCalls));
      
      // act 
      outboxBloc.add(GetOutboxFromRemoteAndSaveToLocalEvent(limit: limit, offset: offset));
    });

    test('should return ServerFailure when failed fetching outbox from remote', () async {
    
      // arrange 
      when(mockGetOutboxFromRemote(any)).thenAnswer((_) async => Left(ServerFailure(message: remoteErrorMessage)));
      when(mockGetOutbox(any)).thenAnswer((_) async => Right(outboxList2));
      // assert 
      final expectedCalls = [
        InitialOutboxState(outboxList: emptyList),
        OutboxErrorState.copyWith(state: outboxBloc.state, message: remoteErrorMessage)
      ];

      expectLater(outboxBloc, emitsInOrder(expectedCalls));

      // act
      outboxBloc.add(GetOutboxFromRemoteAndSaveToLocalEvent(limit: limit, offset: offset));
    });


    test('should return LocalFailure when saving remote data to local', () async {
    
      // arrange 
      when(mockGetOutboxFromRemote(any)).thenAnswer((_) async => Left(LocalFailure(message: localErrorMessage)));
      when(mockGetOutbox(any)).thenAnswer((_) async => Right(outboxList2));
      
      // assert 
      final expectedCalls = [
        InitialOutboxState(outboxList: emptyList),
        OutboxErrorState.copyWith(state: outboxBloc.state, message: localErrorMessage)
      ];

      expectLater(outboxBloc, emitsInOrder(expectedCalls));

      // act
      outboxBloc.add(GetOutboxFromRemoteAndSaveToLocalEvent(limit: limit, offset: offset));
    });

  });
  
}