final String inboxLocalErrorMessage = 'Local Failure';
final String inboxLocalErrorMessageUpdate = 'Failed to update inbox';
final String inboxRemoteErrorMissingApiUrlKey =
    'Missing api key/url. Please check.';
final String inboxRemoteErrorServer =
    'Failed to post data. Check server response';
final String inboxSmsInsertErrorMessage = 'SMS Insert Error';
final String inboxSmsRetrieveErrorMessage = 'Inbox failed to retrieve';

final String localErrorMessage = 'Local Failure';
final String outboxLocalErrorMessageUpdate = 'Failed to update outbox';
final String remoteErrorMessage = 'Remote Error';
final String permissionRequestErrorMessage = 'Failed to request permission.';
final String permissionFailedToSaveInfo = 'Failed to save info';
final String permissionDeniedErrorMesage = 'Permission denied';

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

class PermissionException implements Exception {
  final String message;
  PermissionException({this.message});
}
