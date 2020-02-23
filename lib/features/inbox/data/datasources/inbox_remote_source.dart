import 'package:meta/meta.dart';
import 'package:sms_sender/core/database/database.dart';
import 'package:http/http.dart' as http;
import 'package:sms_sender/core/datasources/constants.dart';
import 'package:sms_sender/core/error/exceptions.dart';

import 'package:sms_sender/features/inbox/data/model/inbox_model.dart';

abstract class InboxRemoteSource {
  Future<bool> sendInboxToServer(List<InboxMessage> messages);
}

class InboxRemoteSourceImpl extends InboxRemoteSource {
  final FirebaseReference firebaseReference;
  final String apikey;
  final http.Client client;

  InboxRemoteSourceImpl(
      {@required this.firebaseReference,
      @required this.apikey,
      @required this.client});

  @override
  Future<bool> sendInboxToServer(List<InboxMessage> messages) async {
    final String url = await firebaseReference.inboxUrl();

    if ((url == null || (url != null && url.isEmpty)) ||
        (apikey == null) ||
        (apikey != null && apikey.isEmpty))
      throw ServerException(message: inboxRemoteErrorMissingApiUrlKey);

    if(messages.isEmpty) {
       throw ServerException(message: inboxEmptyListErrorMessage);
    }

    final response = await client.post('$url', body: {
      'api': apikey,
      'data': messages
          .map((inboxMessage) => InboxModel(address: inboxMessage.address,
                  id: inboxMessage.id,
                  body: inboxMessage.body,
                  date: inboxMessage.date,
                  dateSent: inboxMessage.dateSent,
                  status: inboxMessage.status)
              .toPostMap())
          .toList()
          .toString()
    });

    if ((response != null &&
        response.statusCode == 200 &&
        response.body.toLowerCase() == 'data inserted successfully!')) {
      return true;
    } else {
      throw ServerException(message: inboxRemoteErrorServer);
    }
  }
}
