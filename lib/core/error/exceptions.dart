final String inboxLocalErrorMessage = 'Local Failure';
final String inboxRemoteErrorMissingApiUrlKey = 'Missing api key/url. Please check.';
final String inboxRemoteErrorServer = 'Failed to post data. Check server response';
final String inboxSmsInsertErrorMessage = 'SMS Insert Error';
final String inboxSmsRetrieveErrorMessage = 'Inbox failed to retrieve';

final String localErrorMessage = 'Local Failure';
final String remoteErrorMessage = 'Remote Error';

class ServerException implements Exception {
  final String message;
  ServerException({this.message});
}

class LocalException implements Exception {
  final String message;
  LocalException({this.message});
}

class SMSException implements Exception {
  final String message;
  SMSException({this.message});
}