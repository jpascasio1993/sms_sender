import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/features/outbox/data/datasources/local_source.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
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
    sampleData.forEach((value) => listOutbox.add(OutboxModel.fromJson(value)));
  });

  void setUpMockHttpClientResponse200(){
    when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response(tFixture, 200));
  }

  void setUpMockHttpClientResponse404(){
    when(client.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('[OUTBOX] data/datasources RemoteSource :: ', () {
      test('should return outbox list when response is 200', () async { 
      
        // arrange 
        setUpMockHttpClientResponse200();

        // act 
        final res = await remoteSource.getOutbox();
        
        // assert 
        expect(res, equals(listOutbox));
        
      });

      test('should throw error when response is 404', () async { 
      
        // arrange 
        setUpMockHttpClientResponse404();
        // act 
        final res = remoteSource.getOutbox;
        // assert 
        expect(() => res(), throwsA(TypeMatcher<ServerException>()));
      });

      test('should return empty list when url is empty', () async { 
      
        // arrange 
        setUpMockHttpClientResponse200();
        // act 
        final res = await emptyUrlRemoteSource.getOutbox();
        // assert 
        expect(res, []);
      });
  });
}