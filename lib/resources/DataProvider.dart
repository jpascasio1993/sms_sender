import 'package:http/http.dart' show Client;
import '../models/ItemModel.dart';
import 'dart:convert';
import 'dart:async';

class DataProvider {
   Client client = Client();

  Future<ItemModel> fetchData() async {
    final response = await client.get('https://jsonplaceholder.typicode.com/posts');
    if(response.statusCode == 200)
    {
      return ItemModel.fromJson(json.decode(response.body));
    }
    else {
      throw Exception('Failed to fetch data');
    }
  }
}