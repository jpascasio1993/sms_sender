import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FirebaseURLS {
  final SharedPreferences preferences;
  FirebaseURLS({@required this.preferences});
  String outboxUrl();
  String outboxFetchDelay();
  String inboxUrl();
  String inboxPostDelay();
  String deviceStatus();
  String outboxProcessDelay();
  String outboxDeleteOld();
}

class FirebaseURLSImpl extends FirebaseURLS {
  FirebaseURLSImpl({@required SharedPreferences preferences})
      : super(preferences: preferences);

  @override
  String deviceStatus() {
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/device_status/$imei';
  }

  @override
  String inboxPostDelay() {
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/post_delay';
  }

  @override
  String inboxUrl() {
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/url';
  }

  @override
  String outboxFetchDelay() {
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/fetch_delay';
  }

  @override
  String outboxUrl() {
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/url';
  }

  @override
  String outboxProcessDelay() {
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/process_delay';
  }

  @override
  String outboxDeleteOld() {
     SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/delete_old_months';
  }

  // static String outboxUrl(SharedPreferences preferences) {
  // SharedPreferences prefs = preferences;
  // prefs.reload();
  // String imei = prefs.getString('imei');
  // String projectAppID = prefs.getString('appId');
  // bool debug = projectAppID.contains('debug');
  // return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/url';
  // }

  // static String outboxFetchDelay(SharedPreferences preferences) {
  //   SharedPreferences prefs = preferences;
  //   prefs.reload();
  //   String imei = prefs.getString('imei');
  //   String projectAppID = prefs.getString('appId');
  //   bool debug = projectAppID.contains('debug');
  //   return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/fetch_delay';
  // }

  // static String inboxUrl(SharedPreferences preferences) {
  // SharedPreferences prefs = preferences;
  // prefs.reload();
  // String imei = prefs.getString('imei');
  // String projectAppID = prefs.getString('appId');
  // bool debug = projectAppID.contains('debug');
  // return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/url';
  // }

  // static String inboxPostDelay(SharedPreferences preferences) {
  // SharedPreferences prefs = preferences;
  // prefs.reload();
  // String imei = prefs.getString('imei');
  // String projectAppID = prefs.getString('appId');
  // bool debug = projectAppID.contains('debug');
  // return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/post_delay';
  // }

  // static String deviceStatus(SharedPreferences preferences) {
  // SharedPreferences prefs = preferences;
  // prefs.reload();
  // String imei = prefs.getString('imei');
  // String projectAppID = prefs.getString('appId');
  // bool debug = projectAppID.contains('debug');
  // return '${debug ? "client_updates_debug" : "client_updates"}/device_status/$imei';
  // }
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
}

class FirebaseReferenceImpl extends FirebaseReference {
  FirebaseReferenceImpl(
      {@required FirebaseURLS firebaseURLS,
      @required FirebaseDatabase firebaseDatabase})
      : super(firebaseURLS: firebaseURLS, firebaseDatabase: firebaseDatabase);

  @override
  Future<String> deviceStatus() {
    return firebaseDatabase
        .reference()
        .child(firebaseURLS.deviceStatus())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> inboxPostDelay() {
    return firebaseDatabase
        .reference()
        .child(firebaseURLS.inboxPostDelay())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<String> inboxUrl() {
    return firebaseDatabase
        .reference()
        .child(firebaseURLS.inboxUrl())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> outboxFetchDelay() {
    return firebaseDatabase
        .reference()
        .child(firebaseURLS.outboxFetchDelay())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<String> outboxUrl() {
    return firebaseDatabase
        .reference()
        .child(firebaseURLS.outboxUrl())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> outboxProcessDelay() {
    return firebaseDatabase
        .reference()
        .child(firebaseURLS.outboxProcessDelay())
        .once()
        .then((DataSnapshot snapshot) => snapshot.value);
  }

  @override
  Future<int> deleteOldOutbox() {
    return firebaseDatabase
    .reference()
    .child(firebaseURLS.outboxDeleteOld())
    .once()
    .then((DataSnapshot snapshot) => snapshot.value);
  }
  // static Future<String> outboxUrl(FirebaseDatabase database, String url) =>
  // database
  //     .reference()
  //     .child(url)
  //     .once()
  //     .then((DataSnapshot snapshot) => snapshot.value);

  // static Future<int> outboxFetchDelay(FirebaseDatabase database, String url) =>
  //     database
  //         .reference()
  //         .child(url)
  //         .once()
  //         .then((DataSnapshot snapshot) => snapshot.value);

  // static Future<String> inboxUrl(FirebaseDatabase database, String url) =>
  //     database
  //         .reference()
  //         .child(url)
  //         .once()
  //         .then((DataSnapshot snapshot) => snapshot.value);

  // static Future<int> inboxPostDelay(FirebaseDatabase database, String url) =>
  //     database
  //         .reference()
  //         .child(url)
  //         .once()
  //         .then((DataSnapshot snapshot) => snapshot.value);

  // static Future<String> deviceStatus(FirebaseDatabase database, String url) =>
  //     database
  //         .reference()
  //         .child(url)
  //         .once()
  //         .then((DataSnapshot snapshot) => snapshot.value);
}
