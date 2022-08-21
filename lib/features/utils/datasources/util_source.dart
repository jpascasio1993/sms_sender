import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UtilSource {
  String get imei;
}

class UtilSourceImpl extends UtilSource {
  final SharedPreferences preferences;

  UtilSourceImpl({
    @required this.preferences
  });

  @override
  String get imei => preferences.getString('imei');
}