import 'dart:convert';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sms_sender/models/base_model.dart';

class SMSModel extends BaseModel<_SMSModelItem> {
  SMSModel() : super();

  SMSModel.clone({@required SMSModel item}) : super.clone(item: item);
}

class _SMSModelItem {
  int id;
  int thread_id;
  String address;
  String person;
  String date;
  String protocol;
  bool read;
  int status;
  int type;
  String reply_path_present;
  String subject;
  String body;
  String service_center;
  bool locked;
  int sub_id;
  String error_code;
  bool seen;
  String service_msg_sender_address;

  _SMSModelItem(
      {this.id,
      this.thread_id,
      this.address,
      this.person,
      this.date,
      this.protocol,
      this.read,
      this.status,
      this.type,
      this.reply_path_present,
      this.subject,
      this.body,
      this.service_center,
      this.locked,
      this.sub_id,
      this.error_code,
      this.seen,
      this.service_msg_sender_address});
}
