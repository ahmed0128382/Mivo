import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  static int iosVersionCode = 1;

  static DeviceInfo? instance;
  String deviceID = "";
  String versionCode = "0";
  String version = "0";
  String model = "";
  String packageName = "";
  String osVersion = "";

  static DeviceInfo? getInstance() {
    if (instance == null) {
      instance = new DeviceInfo();
      return instance;
    } else {
      return instance;
    }
  }

  Future<void> deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      packageName = packageInfo.packageName;
      deviceID = androidInfo.id;
      version = packageInfo.version;
      versionCode = packageInfo.buildNumber;
      model = androidInfo.model!;
      osVersion = "${androidInfo.version.sdkInt}" ;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      packageName = packageInfo.packageName;
      deviceID = iosInfo.identifierForVendor!;
      version = packageInfo.version;
      versionCode = version; //version is the unique things at the ios
      model = iosInfo.utsname.machine!;
      osVersion = iosInfo.systemVersion!;
    }

  }
}
