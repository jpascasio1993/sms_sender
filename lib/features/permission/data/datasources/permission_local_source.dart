import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_version/get_version.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:meta/meta.dart';
import 'package:sms_sender/core/extensions/string_extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_sender/core/error/exceptions.dart';

abstract class PermissionLocalSource {
  Future<bool> saveInfo();
  Future<bool> requestPermission(List<PermissionGroup> permissionGroup);
}

class PermissionLocalSourceImpl extends PermissionLocalSource {
  final SharedPreferences preferences;
  final PermissionHandler permissionHandler;

  PermissionLocalSourceImpl({@required this.preferences, @required this.permissionHandler});

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

    SharedPreferences prefs = preferences;
    String imei = await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: true);
    final storageDirectory = await ExtStorage.getExternalStorageDirectory();
    final persistentDirectory = '$storageDirectory/sms_sender';
    await Directory(persistentDirectory).create();
    debugPrint('test directory: $persistentDirectory');
    final file = File('$persistentDirectory/sms_sender_id.txt');
    final fileExists = await file.exists();

    if(!fileExists && !imei.isNullOrEmpty) {
      await file.writeAsString(imei);
      await prefs.setString('imei', imei);
      return;
    }

    final imeiFromFile = await file.readAsString().catchError((e) => debugPrint('e: $e'));
    if(imeiFromFile.isNullOrEmpty && !imei.isNullOrEmpty) {
      await file.writeAsString(imei);
      await prefs.setString('imei', imei);
      return;
    }

    imei = imeiFromFile;
    await prefs.setString('imei', imei);
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