import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sms_sender/screens/sms/index.dart';

class Routes {
  Map<String, WidgetBuilder> routes = {
    "/": (BuildContext context) => SMSList()
  };

  Routes() {}
}
