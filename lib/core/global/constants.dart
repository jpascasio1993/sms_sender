class OutboxStatus {
  static final int unsent = 0;
  static final int sent = 1;
  static final int failed = 2;
  static final int resend = 3;
}