import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_version/get_version.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_sender/core/error/exceptions.dart';
import 'package:sms_sender/core/global/constants.dart';

abstract class PermissionLocalSource {
  Future<bool> saveInfo();
  Future<bool> requestPermission(List<PermissionGroup> permissionGroup);
}

class PermissionLocalSourceImpl extends PermissionLocalSource {
  final SharedPreferences preferences;
  final PermissionHandler permissionHandler;
  final FlutterSecureStorage secureStorage;

  PermissionLocalSourceImpl({@required this.preferences, @required this.permissionHandler, @required this.secureStorage});

  @override
  Future<bool> saveInfo() async {
    try {
      await setUpAppInfo();
      await setUpImei();
      return true;
    }catch(error) {
      throw PermissionException(message: permissionFailedToSaveInfo);
    }
  }

   Future<bool> clearSharedPreferenceCache() async {
    SharedPreferences prefs = preferences;
    prefs.reload();
    return prefs.clear();
  }

  Future<void> setUpAppInfo() async {
    SharedPreferences prefs = preferences;
    String projectAppID = await GetVersion.appID;
    await prefs.setString('appId', projectAppID);
  }

  Future<void> setUpImei() async {
    String imei = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true);
    final savedKey = await secureStorage.read(key: SecureStorageKeys.IMEIKEY);
    if(savedKey == null && imei != null || imei != '') {
      debugPrint('No Key, will save imei :: $imei');
      await secureStorage.write(key: SecureStorageKeys.IMEIKEY, value: imei);
    }
  }

  @override
  Future<bool> requestPermission(List<PermissionGroup> permissionGroup) async {
    final permissions = await permissionHandler.requestPermissions(permissionGroup);
    final granted =  permissions.values.where((status) => status.value != PermissionStatus.granted.value).length == 0;
    if(granted) {
      return granted;
    }else {
        throw PermissionException(message: permissionDeniedErrorMesage);
    }
  }
}