import 'package:sms_sender/utils/http.dart';
import '../models/outbox_model.dart';
import 'dart:convert';
import 'dart:async';

class OutboxResource {
  Future<List<OutboxModel>> fetchData() async {
    final response =
        await httpClient.get('https://jsonplaceholder.typicode.com/posts');
    if (response.statusCode == 200) {
      List<OutboxModel> items = [];
      List fetchedData = json.decode(response.body);
      for (var item in fetchedData) {
        items.add(OutboxModel(item));
      }
      return items;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
