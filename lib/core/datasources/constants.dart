import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_sender/core/global/constants.dart';


abstract class FirebaseURLS {
  final SharedPreferences preferences;
  final FlutterSecureStorage secureStorage;
  FirebaseURLS({@required this.preferences, @required this.secureStorage});
  Future<String>  outboxUrl();
  Future<String>  outboxFetchDelay();
  Future<String>  inboxUrl();
  Future<String> inboxPostDelay();
  Future<String> deviceStatus();
  Future<String>  outboxProcessDelay();
  Future<String> outboxDeleteOld();
  Future<String> inboxDeleteOld();
}

class FirebaseURLSImpl extends FirebaseURLS {
  FirebaseURLSImpl({@required SharedPreferences preferences, @required FlutterSecureStorage secureStorage})
      : super(preferences: preferences, secureStorage: secureStorage);

  @override
  Future<String> deviceStatus() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    FlutterSecureStorage secureStorage = super.secureStorage;
    String imei = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/device_status/$imei';
  }

  @override
  Future<String> inboxPostDelay() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    FlutterSecureStorage secureStorage = super.secureStorage;
    String imei = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/post_delay';
  }

  @override
  Future<String> inboxUrl() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    FlutterSecureStorage secureStorage = super.secureStorage;
    String imei = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/url';
  }

  @override
  Future<String> outboxFetchDelay() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    FlutterSecureStorage secureStorage = super.secureStorage;
    String imei = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/fetch_delay';
  }

  @override
  Future<String> outboxUrl() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    FlutterSecureStorage secureStorage = super.secureStorage;
    String imei = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/url';
  }

  @override
  Future<String> outboxProcessDelay() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    FlutterSecureStorage secureStorage = super.secureStorage;
    String imei = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/process_delay';
  }

  @override
  Future<String> outboxDeleteOld() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    FlutterSecureStorage secureStorage = super.secureStorage;
    String imei = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/delete_old_months_ago';
  }

  @override
  Future<String> inboxDeleteOld() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    FlutterSecureStorage secureStorage = super.secureStorage;
    String imei = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/delete_old_months_ago';
  }
}

abstract class FirebaseReference {
  final FirebaseURLS firebaseURLS;
  final FirebaseDatabase firebaseDatabase;
  FirebaseReference(
      {@required this.firebaseURLS, @required this.firebaseDatabase});

  Future<String> outboxUrl();
  Future<int> outboxFetchDelay();
  Future<String> inboxUrl();
  Future<int> inboxPostDelay();
  Future<String> deviceStatus();
  Future<int> outboxProcessDelay();
  Future<int> deleteOldOutbox();
  Future<int> deleteOldInbox();
}

class FirebaseReferenceImpl extends FirebaseReference {
  FirebaseReferenceImpl(
      {@required FirebaseURLS firebaseURLS,
      @required FirebaseDatabase firebaseDatabase})
      : super(firebaseURLS: firebaseURLS, firebaseDatabase: firebaseDatabase);

  @override
  Future<String> deviceStatus() async {
    return firebaseDatabase
        .reference()
        .child(await firebaseURLS.deviceStatus())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> inboxPostDelay() async {
    return firebaseDatabase
        .reference()
        .child(await firebaseURLS.inboxPostDelay())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<String> inboxUrl() async {
    return firebaseDatabase
        .reference()
        .child(await firebaseURLS.inboxUrl())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> outboxFetchDelay() async {
    return firebaseDatabase
        .reference()
        .child(await firebaseURLS.outboxFetchDelay())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<String> outboxUrl() async {
    return firebaseDatabase
        .reference()
        .child(await firebaseURLS.outboxUrl())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> outboxProcessDelay() async {
    return firebaseDatabase
        .reference()
        .child(await firebaseURLS.outboxProcessDelay())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> deleteOldOutbox() async {
    return firebaseDatabase
    .reference()
    .child(await firebaseURLS.outboxDeleteOld())
    .once()
    .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> deleteOldInbox() async {
    return firebaseDatabase
    .reference()
    .child(await firebaseURLS.inboxDeleteOld())
    .once()
    .then((DataSnapshot snapshot) => snapshot.value);
  }
}
