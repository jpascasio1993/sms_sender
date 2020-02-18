import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseURLS {
  static String outboxUrl(SharedPreferences preferences) {
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/url';
  }

  static String outboxFetchDelay(SharedPreferences preferences) {
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/outbox/$imei/fetch_delay';
  }

  static String inboxUrl(SharedPreferences preferences){
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/url';
  }

  static String inboxPostDelay(SharedPreferences preferences){
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/inbox/$imei/post_delay';
  }

  static String deviceStatus(SharedPreferences preferences){
    SharedPreferences prefs = preferences;
    prefs.reload();
    String imei = prefs.getString('imei');
    String projectAppID = prefs.getString('appId');
    bool debug = projectAppID.contains('debug');
    return '${debug ? "client_updates_debug" : "client_updates"}/device_status/$imei';
  }
}

class FirebaseReference {
    static Future<String> outboxUrl(FirebaseDatabase database, String url) => database
      .reference()
      .child(url)
      .once()
      .then((DataSnapshot snapshot) => snapshot.value);

  static Future<int> outboxFetchDelay(FirebaseDatabase database, String url) => database
      .reference()
      .child(url)
      .once()
      .then((DataSnapshot snapshot) => snapshot.value);

  static Future<String> inboxUrl(FirebaseDatabase database, String url) => database
      .reference()
      .child(url)
      .once()
      .then((DataSnapshot snapshot) => snapshot.value);

  static Future<int> inboxPostDelay(FirebaseDatabase database, String url) => database
      .reference()
      .child(url)
      .once()
      .then((DataSnapshot snapshot) => snapshot.value);

  static Future<String> deviceStatus(FirebaseDatabase database, String url) => database
      .reference()
      .child(url)
      .once()
      .then((DataSnapshot snapshot) => snapshot.value);
}