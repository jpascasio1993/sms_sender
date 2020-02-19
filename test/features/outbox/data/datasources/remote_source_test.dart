import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_sender/core/datasources/constants.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/features/outbox/data/datasources/remote_source.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'dart:convert';
import 'package:matcher/matcher.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockSharedPreference extends Mock implements SharedPreferences {}

class MockDataReference extends Mock implements DatabaseReference {}

class MockDataSnapShot extends Mock implements DataSnapshot {}

class MockFirebaseURLS extends Mock implements FirebaseURLS {}

class MockFirebaseReference extends Mock implements FirebaseReference {}

void main() {
  MockHttpClient client;
  MockFirebaseDatabase mockFirebaseDatabase;
  MockSharedPreference mockSharedPreference;
  MockDataReference mockDataReference;
  MockDataSnapShot mockDataSnapShot;
  MockFirebaseURLS mockFirebaseURLS;
  MockFirebaseReference mockFirebaseReference;
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
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockSharedPreference = MockSharedPreference();
    mockDataReference = MockDataReference();
    mockDataSnapShot = MockDataSnapShot();
    mockFirebaseURLS = MockFirebaseURLS();
    mockFirebaseReference = MockFirebaseReference();
    remoteSource = RemoteSourceImpl(
        client: client, firebaseReference: mockFirebaseReference, apiKey: '');
    emptyUrlRemoteSource = RemoteSourceImpl(
        client: client, firebaseReference: mockFirebaseReference, apiKey: '');
    sampleData.forEach((value) => listOutbox.add(OutboxModel.fromJson(value)));
  });

  void setupFirebase() {
    // when(mockFirebaseDatabase.reference()).thenAnswer((_) => mockDataReference);
    // when(mockDataReference.child(any)).thenAnswer((_) => mockDataReference);
    // when(mockDataReference.once()).thenAnswer((_) async => mockDataSnapShot);
    // when(mockDataSnapShot.value).thenAnswer((_) => url);
    // when(mockFirebaseURLS.).thenAnswer((_) => url);
    when(mockFirebaseReference.outboxUrl()).thenAnswer((_) async => url);
  }

  void setUpMockHttpClientResponse200() {
    when(client.post(any, body: anyNamed('body')))
        .thenAnswer((_) async => http.Response(tFixture, 200));
  }

  void setUpMockHttpClientResponse404() {
    when(client.post(any, body: anyNamed('body')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('[OUTBOX] data/datasources RemoteSource :: ', () {
    test('should return outbox list when response is 200', () async {
      // arrange
      setupFirebase();
      setUpMockHttpClientResponse200();

      // act
      final res = await remoteSource.getOutbox();

      // assert
      expect(res, equals(listOutbox));
    });

    test('should throw error when response is 404', () async {
      // arrange
      setupFirebase();
      setUpMockHttpClientResponse404();

      // act
      final res = remoteSource.getOutbox;
      // assert
      expect(() => res(), throwsA(TypeMatcher<ServerException>()));
    });

    test('should return empty list when url is empty', () async {
      // arrange
      when(mockFirebaseReference.outboxUrl()).thenAnswer((_) async => '');
      setUpMockHttpClientResponse200();

      // act
      final res = await emptyUrlRemoteSource.getOutbox();
      // assert
      expect(res, []);
    });
  });
}
