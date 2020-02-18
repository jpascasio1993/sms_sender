import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:http/http.dart' as http;
import 'package:sms_sender/core/datasources/constants.dart';
import 'package:sms_sender/core/error/exceptions.dart';

import 'package:sms_sender/features/inbox/data/model/inbox_model.dart';

abstract class InboxRemoteSource {
  Future<bool> sendInboxToServer(List<InboxMessage> messages);
}

class InboxRemoteSourceImpl extends InboxRemoteSource {

  final FirebaseDatabase firebaseDatabase;
  final SharedPreferences preferences;
  final String apikey;
  final http.Client client;

  InboxRemoteSourceImpl({
      @required this.firebaseDatabase,
      @required this.preferences,
      @required this.apikey,
      @required this.client
  });  

   @override
  Future<bool> sendInboxToServer(List<InboxMessage> messages) async {
     final String url = await firebaseDatabase
      .reference()
      .child(FirebaseURLS.inboxUrl(preferences))
      .once()
      .then((DataSnapshot snapshot) => snapshot.value);
      
    if ((url == null || (url != null && url.isEmpty)) || 
      (apikey == null) || (apikey !=null && apikey.isEmpty)) 
        throw ServerException(message: inboxRemoteErrorMissingApiUrlKey);

    final response = await client.post('$url', body: {
      'api': apikey,
      'data': messages.map((inboxMessage) => InboxModel()
        .copyWith(
          address: inboxMessage.address,
          id: inboxMessage.id,
          body: inboxMessage.body,
          date: inboxMessage.date,
          dateSent: inboxMessage.dateSent,
          sent: inboxMessage.sent
        ).toJson()
      )
      .toList()
      .toString()
    });

    if ((response != null &&
        response.statusCode == 200 &&
        response.body.toLowerCase() == 'data inserted successfully!')) {
        return true;
    }else {
      throw ServerException(message: inboxRemoteErrorServer);
    }
  }
}