import 'package:http/http.dart' show Client;

class Http {
  Client _client = Client();
  static final Http _http = new Http._internal();
  factory Http() => _http;
  Http._internal();

  Client get client => _client;
}

Client httpClient = Http().client;