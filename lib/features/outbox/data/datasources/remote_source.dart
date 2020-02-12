import 'package:meta/meta.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/features/outbox/data/model/outbox_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class RemoteSource {
  Future<List<OutboxModel>> getOutbox();
}

class RemoteSourceImpl extends RemoteSource {
  final http.Client client;
  final String url;

  RemoteSourceImpl({@required this.client, @required this.url});

  @override
  Future<List<OutboxModel>> getOutbox() async {
    if (url == null || (url != null && url.isEmpty)) return [];
    final response = await client
        .post('$url', body: {'api': 'AIzaSyC3N-q-3HMMCRTIdfZLk75AtA_1Zn5SO1A'});
    if (response.statusCode == 200) {
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
      throw ServerException();
    }
  }
}
