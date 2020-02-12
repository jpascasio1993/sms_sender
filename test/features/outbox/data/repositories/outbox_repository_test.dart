import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/error/failures.dart';
import 'package:sms_sender/features/outbox/data/datasources/local_source.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:http/http.dart' as http;
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'dart:convert';
import 'package:sms_sender/features/outbox/data/repositories/outbox_repository_impl.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockRemoteSource extends Mock implements RemoteSource {}

class MockLocalSource extends Mock implements LocalSource {}

void main() {
  MockRemoteSource remoteSource;
  MockLocalSource localSource;
  OutboxRepositoryImpl outboxRepositoryImpl;
  List<OutboxModel> listOutbox = [];
  List sampleData;
  int limit = -1;
  int offset = 0;

  setUp(() {
    sampleData = json.decode(fixture('outbox.json'));
    remoteSource = MockRemoteSource();
    localSource = MockLocalSource();
    outboxRepositoryImpl = OutboxRepositoryImpl(
        remoteSource: remoteSource, localSource: localSource);

    sampleData.forEach((any) => listOutbox.add(OutboxModel.fromJson(any)));
  });

  group('[OUTBOX] data/repositories OutboxRepository :: ', () {
    test('should get outbox list from local source', () async {
      // arrange
      when(localSource.getOutbox(any, any)).thenAnswer((_) async => listOutbox);

      // act
      final res = await outboxRepositoryImpl.getOutbox(limit, offset);

      // assert
      expect(res, Right(listOutbox));
    });

    test('should get outbox from remote and insert to local source', () async {
      // arrange
      when(remoteSource.getOutbox()).thenAnswer((_) async => listOutbox);

      // act
      final res = await outboxRepositoryImpl.fetchOutboxRemote();
      // assert
      expect(res, Right(listOutbox));
    });

    test('should return ServerFailure when failed to fetch data from remote',
        () async {
      // arrange
      when(remoteSource.getOutbox()).thenThrow(ServerException());
      // act
      final res = await outboxRepositoryImpl.fetchOutboxRemote();
      // assert
      expect(res, Left(ServerFailure(message: remoteErrorMessage)));
    });
  });
}
