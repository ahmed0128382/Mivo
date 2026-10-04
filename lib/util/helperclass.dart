import 'dart:convert';
import 'dart:io';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:http/http.dart' as http;

class Helper {
  static Future<String> Downloadfile(
    String strURL,
    String filename,
  ) async {
    var Direction = await getTemporaryDirectory();
    final filepath = '${Direction.path}/$filename';

    final responseData = await http.get(Uri.parse(strURL));

    File file = File(filepath);
    await file.writeAsBytes(responseData.bodyBytes);

    return filepath;
  }

  String utf8convert(String text) {
    var encoded = utf8.encode(text);
    List<int> intList = List<int>.from(encoded);
    String result = Utf8Decoder().convert(List<int>.from(intList));
    return result;
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }

    return null;
  }

  CutName(String name) {
    if (name.length > 23) {
      return name.substring(0, 23) + '...';
    } else {
      return name;
    }
  }

  CutName2({required String name}) {
    if (name.length > 15) {
      return name.substring(0, 15) + '...';
    } else {
      return name;
    }
  }

  CutName3({required String name}) {
    if (name.length > 11) {
      return name.substring(0, 11) + '...';
    } else {
      return name;
    }
  }

  CutName4({required String name}) {
    if (name.length > 7) {
      return name.substring(0, 7) + '...';
    } else {
      return name;
    }
  }

  CutName5({required String name}) {
    if (name.length > 9) {
      return name.substring(0, 9) + '...';
    } else {
      return name;
    }
  }

  CutName7({required String name}) {
    if (name.length > 5) {
      return name.substring(0, 5) + '..';
    } else {
      return name;
    }
  }

  void checkVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  ids() async {
    deviceId = await getId();
  }

  PlayMusic({path}) async {
    final player = AudioPlayer();
    await player.setAsset(path, preload: false);
    await player.play();
  }

  PlaylinkMusic({path}) async {
    final player = AudioPlayer();

    await player.setUrl(
      path,
      preload: false,
    );

    await player.play();
  }

  RequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  Future<void> launchInBrowser(url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      Dialogs().showtoast('This Account Invalid');
    }
  }

  Getage({
    year,
    day,
    month,
  }) {
    String diff = (((DateTime(
          int.parse(year ?? ''),
          int.parse(month ?? ''),
          int.parse(day ?? ''),
        ).difference(DateTime.now()).inDays) /
        365)
      .round() +
        1)
      .abs()
      .toString();

    return diff;
  }

  getTimeago({time}) {
    return timeago
        .format(DateTime.tryParse(time ?? '') as DateTime)
        .toString();
  }

  getdayago({String? time}) {
    final createdAt = DateTime.parse(time ?? '');

    final now = DateTime.now().toUtc();
    final difference = now.difference(createdAt).inDays;

    if (difference == 0) {
      return ' التعارف 1 الأيام ';
    }

    return ' التعارف $difference الأيام ';
  }

  String k_m_b_generator(num? value) {
    final num number = value ?? 0;

    if (number > 999 && number < 99999) {
      return "${(number / 1000).toStringAsFixed(1)} K";
    } else if (number > 99999 && number < 999999) {
      return "${(number / 1000).toStringAsFixed(0)} K";
    } else if (number > 999999 && number < 999999999) {
      return "${(number / 1000000).toStringAsFixed(1)} M";
    } else if (number > 999999999) {
      return "${(number / 1000000000).toStringAsFixed(1)} B";
    } else {
      return number.toString();
    }
  }

  String CheckQuantaty({quantity}) {
    switch (quantity) {
      case '1':
        return 'assets/image/1x.png';

      case '5':
        return 'assets/image/5x.png';

      case '10':
        return 'assets/image/10x.png';

      case '20':
        return 'assets/image/20x.png';

      case '30':
        return 'assets/image/30x.png';

      default:
        return 'assets/image/1x.png';
    }
  }

  CheckLevel({required int Karisma}) {
    if (50000 >= Karisma) {
      return 1;
    } else if (Karisma > 50000 && 100000 >= Karisma) {
      return 2;
    } else if (Karisma > 100000 && 300000 >= Karisma) {
      return 3;
    } else if (Karisma > 300000 && 500000 >= Karisma) {
      return 4;
    } else if (Karisma > 500000 && 700000 >= Karisma) {
      return 5;
    } else if (Karisma > 700000 && 900000 >= Karisma) {
      return 6;
    } else if (Karisma > 900000 && 1300000 >= Karisma) {
      return 7;
    } else if (Karisma > 1300000 && 1500000 >= Karisma) {
      return 8;
    } else if (Karisma > 1500000 && 1700000 >= Karisma) {
      return 9;
    } else if (Karisma > 1700000 && 2000000 >= Karisma) {
      return 10;
    } else if (Karisma > 2000000 && 2500000 >= Karisma) {
      return 11;
    } else if (Karisma > 2500000 && 3500000 >= Karisma) {
      return 12;
    } else if (Karisma > 3500000 && 4000000 >= Karisma) {
      return 13;
    } else if (Karisma > 4000000 && 4500000 >= Karisma) {
      return 14;
    } else if (Karisma > 4500000 && 5500000 >= Karisma) {
      return 15;
    } else if (Karisma > 5500000 && 6000000 >= Karisma) {
      return 16;
    } else if (Karisma > 6000000 && 6500000 >= Karisma) {
      return 17;
    } else if (Karisma > 6500000 && 7000000 >= Karisma) {
      return 18;
    } else if (Karisma > 7000000 && 7500000 >= Karisma) {
      return 19;
    } else if (Karisma > 7500000 && 8000000 >= Karisma) {
      return 20;
    } else if (Karisma > 8000000 && 9000000 >= Karisma) {
      return 21;
    } else if (Karisma > 9000000 && 11000000 >= Karisma) {
      return 22;
    } else if (Karisma > 11000000 && 13000000 >= Karisma) {
      return 23;
    } else if (Karisma > 13000000 && 17000000 >= Karisma) {
      return 24;
    } else if (Karisma > 17000000 && 23000000 >= Karisma) {
      return 25;
    } else if (Karisma > 23000000 && 29000000 >= Karisma) {
      return 26;
    } else if (Karisma > 29000000 && 37000000 >= Karisma) {
      return 27;
    } else if (Karisma > 37000000 && 45000000 >= Karisma) {
      return 28;
    } else if (Karisma > 45000000 && 54000000 >= Karisma) {
      return 29;
    } else if (Karisma > 54000000 && 64000000 >= Karisma) {
      return 30;
    } else if (Karisma > 64000000 && 74000000 >= Karisma) {
      return 31;
    } else if (Karisma > 74000000 && 84000000 >= Karisma) {
      return 32;
    } else if (Karisma > 84000000 && 104000000 >= Karisma) {
      return 33;
    } else if (Karisma > 104000000 && 114000000 >= Karisma) {
      return 34;
    } else if (Karisma > 114000000 && 124000000 >= Karisma) {
      return 35;
    } else if (Karisma > 124000000 && 134000000 >= Karisma) {
      return 36;
    } else if (Karisma > 134000000 && 144000000 >= Karisma) {
      return 37;
    } else if (Karisma > 144000000 && 154000000 >= Karisma) {
      return 38;
    } else if (Karisma > 154000000 && 164000000 >= Karisma) {
      return 39;
    } else if (Karisma > 164000000 && 174000000 >= Karisma) {
      return 40;
    } else if (Karisma > 174000000 && 184000000 >= Karisma) {
      return 41;
    } else if (Karisma > 184000000 && 194000000 >= Karisma) {
      return 42;
    } else if (Karisma > 194000000 && 204000000 >= Karisma) {
      return 43;
    } else if (Karisma > 204000000 && 214000000 >= Karisma) {
      return 44;
    } else if (Karisma > 214000000 && 224000000 >= Karisma) {
      return 45;
    } else if (Karisma > 224000000 && 234000000 >= Karisma) {
      return 46;
    } else if (Karisma > 234000000 && 244000000 >= Karisma) {
      return 47;
    } else if (Karisma > 244000000 && 254000000 >= Karisma) {
      return 48;
    } else if (Karisma > 254000000 && 264000000 >= Karisma) {
      return 49;
    } else if (Karisma > 264000000 && 274000000 >= Karisma) {
      return 50;
    } else {
      return 51;
    }
  }

  bool validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(patttern);

    if (value.length == 0) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }

    return true;
  }
}

void navigateTo({
  required BuildContext context,
  required Widget screen,
}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) =>
          screen,
      transitionDuration: const Duration(
        milliseconds: 300,
      ),
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

void navigatereplacementTo(
  BuildContext context,
  Widget screen,
) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) =>
          screen,
      transitionDuration: const Duration(
        milliseconds: 300,
      ),
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

void ShowGlopalLoading() {
  SmartDialog.showLoading();
}

void DismissGlopalLoading() {
  SmartDialog.dismiss();
}

List UserLevel = [
  {'Level': '1', 'karisma': 0, 'image': 'assets/image/rl1.png'},
  {'Level': '2', 'karisma': 4000, 'image': 'assets/image/rl1.png'},
  {'Level': '3', 'karisma': 6000, 'image': 'assets/image/rl1.png'},
  {'Level': '4', 'karisma': 10000, 'image': 'assets/image/rl1.png'},
  {'Level': '5', 'karisma': 15000, 'image': 'assets/image/rl1.png'},
  {'Level': '6', 'karisma': 21000, 'image': 'assets/image/rl1.png'},
  {'Level': '7', 'karisma': 28000, 'image': 'assets/image/rl1.png'},
  {'Level': '8', 'karisma': 36000, 'image': 'assets/image/rl1.png'},
  {'Level': '9', 'karisma': 45000, 'image': 'assets/image/rl1.png'},
  {'Level': '10', 'karisma': 55000, 'image': 'assets/image/rl1.png'},
  {'Level': '11', 'karisma': 66000, 'image': 'assets/image/rl2.png'},
  {'Level': '12', 'karisma': 78000, 'image': 'assets/image/rl2.png'},
  {'Level': '13', 'karisma': 91000, 'image': 'assets/image/rl2.png'},
  {'Level': '14', 'karisma': 105000, 'image': 'assets/image/rl2.png'},
  {'Level': '15', 'karisma': 120000, 'image': 'assets/image/rl2.png'},
  {'Level': '16', 'karisma': 136000, 'image': 'assets/image/rl2.png'},
  {'Level': '17', 'karisma': 151000, 'image': 'assets/image/rl2.png'},
  {'Level': '18', 'karisma': 169000, 'image': 'assets/image/rl2.png'},
  {'Level': '19', 'karisma': 188000, 'image': 'assets/image/rl2.png'},
  {'Level': '20', 'karisma': 208000, 'image': 'assets/image/rl2.png'},
  {'Level': '21', 'karisma': 229000, 'image': 'assets/image/rl3.png'},
  {'Level': '22', 'karisma': 251000, 'image': 'assets/image/rl3.png'},
  {'Level': '23', 'karisma': 274000, 'image': 'assets/image/rl3.png'},
  {'Level': '24', 'karisma': 298000, 'image': 'assets/image/rl3.png'},
  {'Level': '25', 'karisma': 323000, 'image': 'assets/image/rl3.png'},
  {'Level': '26', 'karisma': 349000, 'image': 'assets/image/rl3.png'},
  {'Level': '27', 'karisma': 276000, 'image': 'assets/image/rl3.png'},
  {'Level': '28', 'karisma': 304000, 'image': 'assets/image/rl3.png'},
  {'Level': '29', 'karisma': 333000, 'image': 'assets/image/rl3.png'},
  {'Level': '30', 'karisma': 363000, 'image': 'assets/image/rl3.png'},
  {'Level': '31', 'karisma': 394000, 'image': 'assets/image/rl4.png'},
  {'Level': '32', 'karisma': 426000, 'image': 'assets/image/rl4.png'},
  {'Level': '33', 'karisma': 459000, 'image': 'assets/image/rl4.png'},
  {'Level': '34', 'karisma': 469000, 'image': 'assets/image/rl4.png'},
  {'Level': '35', 'karisma': 528000, 'image': 'assets/image/rl4.png'},
  {'Level': '36', 'karisma': 564000, 'image': 'assets/image/rl4.png'},
  {'Level': '37', 'karisma': 601000, 'image': 'assets/image/rl4.png'},
  {'Level': '38', 'karisma': 639000, 'image': 'assets/image/rl4.png'},
  {'Level': '39', 'karisma': 678000, 'image': 'assets/image/rl4.png'},
  {'Level': '40', 'karisma': 718000, 'image': 'assets/image/rl4.png'},
  {'Level': '41', 'karisma': 759000, 'image': 'assets/image/rl5.png'},
  {'Level': '42', 'karisma': 801000, 'image': 'assets/image/rl5.png'},
  {'Level': '43', 'karisma': 844000, 'image': 'assets/image/rl5.png'},
  {'Level': '44', 'karisma': 888000, 'image': 'assets/image/rl5.png'},
  {'Level': '45', 'karisma': 933000, 'image': 'assets/image/rl5.png'},
  {'Level': '46', 'karisma': 979000, 'image': 'assets/image/rl5.png'},
  {'Level': '47', 'karisma': 1026000, 'image': 'assets/image/rl5.png'},
  {'Level': '48', 'karisma': 1074000, 'image': 'assets/image/rl5.png'},
  {'Level': '49', 'karisma': 1123000, 'image': 'assets/image/rl5.png'},
  {'Level': '50', 'karisma': 1173000, 'image': 'assets/image/rl5.png'},
  {'Level': '51', 'karisma': 1224000, 'image': 'assets/image/rl6.png'},
  {'Level': '52', 'karisma': 1276000, 'image': 'assets/image/rl6.png'},
  {'Level': '53', 'karisma': 1329000, 'image': 'assets/image/rl6.png'},
  {'Level': '54', 'karisma': 1383000, 'image': 'assets/image/rl6.png'},
  {'Level': '55', 'karisma': 1438000, 'image': 'assets/image/rl6.png'},
  {'Level': '56', 'karisma': 1494000, 'image': 'assets/image/rl6.png'},
  {'Level': '57', 'karisma': 1551000, 'image': 'assets/image/rl6.png'},
  {'Level': '58', 'karisma': 1609000, 'image': 'assets/image/rl6.png'},
  {'Level': '59', 'karisma': 1668000, 'image': 'assets/image/rl6.png'},
  {'Level': '60', 'karisma': 1728000, 'image': 'assets/image/rl6.png'},
  {'Level': '61', 'karisma': 1789000, 'image': 'assets/image/rl7.png'},
  {'Level': '62', 'karisma': 1851000, 'image': 'assets/image/rl7.png'},
  {'Level': '63', 'karisma': 1914000, 'image': 'assets/image/rl7.png'},
  {'Level': '64', 'karisma': 1978000, 'image': 'assets/image/rl7.png'},
  {'Level': '65', 'karisma': 2043000, 'image': 'assets/image/rl7.png'},
  {'Level': '66', 'karisma': 2109000, 'image': 'assets/image/rl7.png'},
  {'Level': '67', 'karisma': 2176000, 'image': 'assets/image/rl7.png'},
  {'Level': '68', 'karisma': 2244000, 'image': 'assets/image/rl7.png'},
  {'Level': '69', 'karisma': 2312000, 'image': 'assets/image/rl7.png'},
  {'Level': '70', 'karisma': 2383000, 'image': 'assets/image/rl7.png'},
  {'Level': '71', 'karisma': 2454000, 'image': 'assets/image/rl8.png'},
  {'Level': '72', 'karisma': 2526000, 'image': 'assets/image/rl8.png'},
  {'Level': '73', 'karisma': 2599000, 'image': 'assets/image/rl8.png'},
  {'Level': '74', 'karisma': 2673000, 'image': 'assets/image/rl8.png'},
  {'Level': '75', 'karisma': 2748000, 'image': 'assets/image/rl8.png'},
  {'Level': '76', 'karisma': 2824000, 'image': 'assets/image/rl8.png'},
  {'Level': '77', 'karisma': 2901000, 'image': 'assets/image/rl8.png'},
  {'Level': '78', 'karisma': 2979000, 'image': 'assets/image/rl8.png'},
  {'Level': '79', 'karisma': 3058000, 'image': 'assets/image/rl8.png'},
  {'Level': '80', 'karisma': 3138000, 'image': 'assets/image/rl8.png'},
  {'Level': '81', 'karisma': 3219000, 'image': 'assets/image/rl9.png'},
  {'Level': '82', 'karisma': 3301000, 'image': 'assets/image/rl9.png'},
  {'Level': '83', 'karisma': 3384000, 'image': 'assets/image/rl9.png'},
  {'Level': '84', 'karisma': 3468000, 'image': 'assets/image/rl9.png'},
  {'Level': '85', 'karisma': 3553000, 'image': 'assets/image/rl9.png'},
  {'Level': '86', 'karisma': 3639000, 'image': 'assets/image/rl9.png'},
  {'Level': '87', 'karisma': 3726000, 'image': 'assets/image/rl9.png'},
  {'Level': '88', 'karisma': 3814000, 'image': 'assets/image/rl9.png'},
  {'Level': '89', 'karisma': 3903000, 'image': 'assets/image/rl9.png'},
  {'Level': '90', 'karisma': 3993000, 'image': 'assets/image/rl9.png'},
  {'Level': '91', 'karisma': 4084000, 'image': 'assets/image/rl10.png'},
  {'Level': '92', 'karisma': 4176000, 'image': 'assets/image/rl10.png'},
  {'Level': '93', 'karisma': 4269000, 'image': 'assets/image/rl10.png'},
  {'Level': '94', 'karisma': 4363000, 'image': 'assets/image/rl10.png'},
  {'Level': '95', 'karisma': 4458000, 'image': 'assets/image/rl10.png'},
  {'Level': '96', 'karisma': 4554000, 'image': 'assets/image/rl10.png'},
  {'Level': '97', 'karisma': 4651000, 'image': 'assets/image/rl10.png'},
  {'Level': '98', 'karisma': 4749000, 'image': 'assets/image/rl10.png'},
  {'Level': '99', 'karisma': 4848000, 'image': 'assets/image/rl10.png'},
  {'Level': '100', 'karisma': 4948000, 'image': 'assets/image/rl10.png'},
  {'Level': '101', 'karisma': 5049000, 'image': 'assets/image/rl11.png'},
  {'Level': '102', 'karisma': 5151000, 'image': 'assets/image/rl11.png'},
  {'Level': '103', 'karisma': 5254000, 'image': 'assets/image/rl11.png'},
  {'Level': '104', 'karisma': 5358000, 'image': 'assets/image/rl11.png'},
  {'Level': '105', 'karisma': 5463000, 'image': 'assets/image/rl11.png'},
  {'Level': '106', 'karisma': 5569000, 'image': 'assets/image/rl11.png'},
  {'Level': '107', 'karisma': 5676000, 'image': 'assets/image/rl11.png'},
  {'Level': '108', 'karisma': 5784000, 'image': 'assets/image/rl11.png'},
  {'Level': '109', 'karisma': 5893000, 'image': 'assets/image/rl11.png'},
  {'Level': '110', 'karisma': 6003000, 'image': 'assets/image/rl11.png'},
  {'Level': '111', 'karisma': 11003000, 'image': 'assets/image/rl11.png'},
];

Future<String?> getIPAddress() async {
  final interfaces = await NetworkInterface.list();

  for (final interface in interfaces) {
    final addresses = interface.addresses;

    for (final address in addresses) {
      if (address.type == InternetAddressType.IPv4) {
        if (!address.isLinkLocal) {
          UserIP = address.address;
          return address.address;
        }
      }
    }
  }

  return null;
}

Future getPublicIP() async {
  final response = await http.get(
    Uri.parse('https://api.ipify.org'),
  );

  await http.get(
    Uri.parse(
      AppConstants.BASE_URL +
          'api/SetPublicIp/$UserId/${response.body.toString()}',
    ),
  );
}