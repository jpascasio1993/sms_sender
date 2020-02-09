import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:sms_sender/features/outbox/data/repositories/outbox_repository_impl.dart';
import 'dart:convert';
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  
  MockHttpClient client;
  RemoteSourceImpl emptyUrlRemoteSource;
  RemoteSourceImpl remoteSource;
  List sampleData;
  final String url = 'asd';
  String tFixture;
  List<OutboxModel> listOutbox;
  setUp(() {
    tFixture = fixture('outbox.json');
    sampleData = json.decode(tFixture);
    listOutbox = [];
    client = MockHttpClient();
    remoteSource = RemoteSourceImpl(client: client, url: url);
    emptyUrlRemoteSource = RemoteSourceImpl(client: client, url: '');
    sampleData.forEach((any) => listOutbox.add(OutboxModel.fromJson(any)));
  });

  void setUpMockHttpClientResponse200(){
    when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response(tFixture, 200));
  }

  void setUpMockHttpClientResponse404(){
    when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('should get data from remote source', () {
      test('when response is 200', () async { 
      
        // arrange 
        setUpMockHttpClientResponse200();
        // act 
        final res = await remoteSource.getOutbox();
        // assert 
        expect(res, listOutbox);
      });

      test('when response is 404', () async { 
      
        // arrange 
        setUpMockHttpClientResponse404();
        // act 
        final res = remoteSource.getOutbox;
        // assert 
        expect(() => res(), throwsA(TypeMatcher<ServerException>()));
      });

      test('when url is empty', () async { 
      
        // arrange 
        setUpMockHttpClientResponse200();
        // act 
        final res = await emptyUrlRemoteSource.getOutbox();
        // assert 
        expect(res, []);
      });
  });
}