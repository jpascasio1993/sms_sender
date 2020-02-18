import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/features/inbox/data/datasources/inbox_remote_source.dart';
import 'dart:convert';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}
class MockSharedPreference extends Mock implements SharedPreferences {}

void main() {
  
  MockHttpClient mockHttpClient;
  MockFirebaseDatabase mockFirebaseDatabase;
  MockSharedPreference mockSharedPreference;
  InboxRemoteSourceImpl inboxRemoteSource;
  InboxRemoteSourceImpl inboxRemoteSource2;
  List<InboxMessage> messages;
  
  setUp(() {
    mockHttpClient = MockHttpClient();
    mockFirebaseDatabase = MockFirebaseDatabase();
    mockSharedPreference = MockSharedPreference();
    inboxRemoteSource = InboxRemoteSourceImpl(firebaseDatabase: mockFirebaseDatabase, preferences: mockSharedPreference, apikey: 'apikey', client: mockHttpClient);
    inboxRemoteSource2 = InboxRemoteSourceImpl(firebaseDatabase: mockFirebaseDatabase, preferences: mockSharedPreference, apikey: 'apikey', client: mockHttpClient);
    messages = [InboxMessage.fromJson(json.decode(fixture('inbox.json')))];

  });

  void setupFirebase() {
    when(mockFirebaseDatabase.reference().child(any).once().then(any)).thenAnswer((_) async => url);
  }

  void setUpPostInboxResponse200() {
    when(mockHttpClient.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('data inserted successfully!', 200));
  }

  void setUpPostInboxResponse404() {
    when(mockHttpClient.post(any, body: anyNamed('body'))).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('[INBOX] data/datasource InboxRemoteSourceImpl', (){
  
    test('should post sms messages to server wirh response 200', () async {
    
      // arrange
      setupFirebase();  
      setUpPostInboxResponse200();

      // act 
      final res = await inboxRemoteSource.sendInboxToServer(messages);

      // assert 
      expect(res, true);
    });

    test('should post sms messages to server with response 404', () async {
    
      // arrange
      setupFirebase();
      setUpPostInboxResponse404();

      // act 
      final res =  inboxRemoteSource.sendInboxToServer;

      // assert 
      expect(() => res(messages), throwsA(TypeMatcher<ServerException>()));

    });

    test('should throw error if api key and uri is empty', () async {
    
      // arrange
      setupFirebase(); 
      setUpPostInboxResponse200();
      
      // act 
      final res = inboxRemoteSource2.sendInboxToServer;

      // assert 
      expect(() => res(messages), throwsA(TypeMatcher<ServerException>()));

    });
  
  });
}