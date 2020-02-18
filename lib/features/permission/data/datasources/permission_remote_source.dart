import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_sender/core/datasources/constants.dart';

abstract class PermissionRemoteSource {
  Future<bool> setUpFirebase();
}

class PermissionRemoteSourceImpl implements PermissionRemoteSource {

  final FirebaseDatabase firebaseDatabase;
  final SharedPreferences preferences;

  PermissionRemoteSourceImpl({@required this.firebaseDatabase, @required this.preferences});

  @override
  Future<bool> setUpFirebase() async {
    await firebaseDatabase
        .reference()
        .child(FirebaseURLS.inboxPostDelay(preferences))
        .keepSynced(true);

    await firebaseDatabase
        .reference()
        .child(FirebaseURLS.inboxUrl(preferences))
        .keepSynced(true);

    await firebaseDatabase
        .reference()
        .child(FirebaseURLS.outboxFetchDelay(preferences))
        .keepSynced(true);

    await firebaseDatabase
        .reference()
        .child(FirebaseURLS.outboxUrl(preferences))
        .keepSynced(true);
        
    return true;
  }
  
}