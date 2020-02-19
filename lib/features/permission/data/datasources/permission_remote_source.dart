import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/datasources/constants.dart';

abstract class PermissionRemoteSource {
  Future<bool> setUpFirebase();
}

class PermissionRemoteSourceImpl implements PermissionRemoteSource {
  final FirebaseDatabase firebaseDatabase;
  final FirebaseURLS firebaseURLS;

  PermissionRemoteSourceImpl(
      {@required this.firebaseDatabase, @required this.firebaseURLS});

  @override
  Future<bool> setUpFirebase() async {
    await firebaseDatabase
        .reference()
        .child(firebaseURLS.inboxPostDelay())
        .keepSynced(true);

    await firebaseDatabase
        .reference()
        .child(firebaseURLS.inboxUrl())
        .keepSynced(true);

    await firebaseDatabase
        .reference()
        .child(firebaseURLS.outboxFetchDelay())
        .keepSynced(true);

    await firebaseDatabase
        .reference()
        .child(firebaseURLS.outboxUrl())
        .keepSynced(true);

    return true;
  }
}
