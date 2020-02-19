import 'package:firebase_database/firebase_database.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_sender/core/datasources/constants.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class RemoteSource {
  Future<List<OutboxModel>> getOutbox();
}

class RemoteSourceImpl extends RemoteSource {
  final http.Client client;
  final FirebaseReference firebaseReference;
  final String apiKey;

  RemoteSourceImpl(
      {@required this.client,
      @required this.firebaseReference,
      @required this.apiKey});

  @override
  Future<List<OutboxModel>> getOutbox() async {
    final String url = await firebaseReference.outboxUrl();

    if (url == null || (url != null && url.isEmpty)) return [];
    final response = await client.post('$url', body: {'api': apiKey});
    if (response.statusCode == 200) {
      print('response.body ${response.body}');
      List<OutboxModel> items = [];
      List fetchedData = response.body.toLowerCase() == 'no available data!'
          ? []
          : json.decode(response.body);

      for (var item in fetchedData) {
        items.add(OutboxModel.fromJson(item));
      }

      return items.where((OutboxModel outboxModel) {
        //debugPrint('filterWhere $outboxModel');
        return outboxModel.recipient != null;
      }).toList();
    } else {
      throw ServerException(message: remoteErrorMessage);
    }
  }
}
