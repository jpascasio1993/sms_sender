class OutboxStatus {
  static final int unsent = 0;
  static final int sent = 1;
  static final int failed = 2;
  static final int resend = 3;
}

class InboxStatus {
  static final int unprocessed = 0;
  static final int processed = 1;
  static final int failed = 2;
  static final int reprocess = 3;
}

class SecureStorageKeys {
  static final String IMEIKEY = '_IMEIKEY_SMS_SENDER';
}