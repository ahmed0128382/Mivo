import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ahlachat/Repositores/Follow_repositores/Follow_api.dart';
import 'package:ahlachat/Repositores/Moment_repositores/Moment_api.dart';
import 'package:ahlachat/Repositores/Shop_repositores/Shop_api.dart';
import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/MessageModel.dart';
import 'package:ahlachat/models/emoji.dart';
import 'package:ahlachat/models/emojicategory.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/LoginScrean.dart';
import 'package:ahlachat/view/Screans/ChatScrean/chat_screan.dart';
import 'package:ahlachat/view/Screans/HostreportScrean/HostreportScrean.dart';
import 'package:ahlachat/view/Screans/SearchScrean/widgets/SearchPeople.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Repositores/user_repositores/user_api.dart';
import '../../../models/Banner.dart';
import '../../../models/LevelsFrame.dart';
import '../../../models/MyVip.dart';
import '../../../models/NotificationModel.dart';
import '../../../models/UserGiftsmodel.dart';
import '../../../models/Usermodel.dart';
import '../../../models/VipModel.dart';
import '../../../models/shipping.dart';
import '../../../util/Dialogs.dart';
import '../../../util/app_constants.dart';
import '../../../util/helperclass.dart';
import '../../Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'login_state.dart';


mixin ConstantsMixin on LoginState {
// App constants, banners, emojis, shipping, device id
  waitingConstDate(context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('ConstData');

      // Constants API is currently returning 500 – never block navigation
      if (raw == null || raw.trim().isEmpty || raw.trim() == '{}') {
        print('waitingConstDate: no ConstData cached, skipping');
        notifyListeners();
        return;
      }
 Map value = jsonDecode(raw);

      if (value['Banner'] is List) {
        List list = value['Banner'];
        list.forEach((element) {
          Banners.add(Bannerss.fromJson(element));
        });
      }

      Giftcatigoris = value['catigoris'];
      LuckyGiftcatigoris = value['luckycatigoris'];
      Roomcatigoris = value['Roomcategory'];
      background = value['background'];

      if (value['version'] is Map) {
        AppLink = value['version']['AppLink'];
        Appversion = value['version']['version'];
      }

      if (value['Shipping'] is List) {
        List datalist = value['Shipping'];
        datalist.forEach((element) {
          Shipping.add(shipping.fromJson(element));
        });
      }

      notifyListeners();
    } catch (e) {
      print('waitingConstDate error (ignored): $e');
      notifyListeners();
    }
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();

    print(deviceInfo);

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;

      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      print('Platform.isAndroid');

      var androidDeviceInfo = await deviceInfo.androidInfo;

      return androidDeviceInfo.id;
    }
  }

  getAllconstant(context) async {
  await userapi().getAllconstant(context).then((value) async {
    if (value == null) {
      print(
        'GET CONST DATA: returned null, '
        'skipping constants parsing',
      );
      return;
    }

    print('========== GET CONST DATA DEBUG ==========');
    print('CONST KEYS: ${value.keys.toList()}');

    Banners.clear();
    emojis.clear();
    emojisCategory.clear();
    Shipping.clear();

    // ------------------------------------------------------------
    // Emojis: top-level "emoji" list
    // ------------------------------------------------------------
    final dynamic rawEmojis = value['emoji'];

    if (rawEmojis is List) {
      for (final dynamic element in rawEmojis) {
        if (element is Map) {
          try {
            final Map<String, dynamic> emojiJson =
                Map<String, dynamic>.from(element);

            emojis.add(
              emojimodel.fromJson(emojiJson),
            );
          } catch (e, stackTrace) {
            print('EMOJI PARSE ERROR: $e');
            print('EMOJI DATA: $element');
            print('EMOJI STACK: $stackTrace');
          }
        } else {
          print(
            'EMOJI SKIPPED: unexpected item type '
            '${element.runtimeType}: $element',
          );
        }
      }
    } else {
      print(
        'EMOJI WARNING: expected a List, received '
        '${rawEmojis.runtimeType}',
      );
    }

    print('TOP-LEVEL EMOJI COUNT: ${emojis.length}');

    // ------------------------------------------------------------
    // Emoji categories: "emojiCategory"
    // Each category contains its own nested "emoji" list.
    // ------------------------------------------------------------
    final dynamic rawEmojiCategories = value['emojiCategory'];

    print(
      'EMOJI CATEGORY RAW TYPE: '
      '${rawEmojiCategories.runtimeType}',
    );

    if (rawEmojiCategories is List) {
      print(
        'EMOJI CATEGORY API COUNT: '
        '${rawEmojiCategories.length}',
      );

      for (final dynamic element in rawEmojiCategories) {
        if (element is Map) {
          try {
            final Map<String, dynamic> categoryJson =
                Map<String, dynamic>.from(element);

            print(
              'EMOJI CATEGORY RAW DATA: $categoryJson',
            );

            final dynamic rawCategoryEmojis =
                categoryJson['emoji'];

            print(
              'CATEGORY "${categoryJson['name']}": '
              'nested emoji type=${rawCategoryEmojis.runtimeType}, '
              'count=${rawCategoryEmojis is List ? rawCategoryEmojis.length : 'not a list'}',
            );

            final EmojiCategory category =
                EmojiCategory.fromJson(categoryJson);

            print(
              'CATEGORY PARSED: '
              'id=${category.id}, '
              'name="${category.name}", '
              'emoji count=${category.emoji?.length ?? 0}',
            );

            emojisCategory.add(category);
          } catch (e, stackTrace) {
            print('EMOJI CATEGORY PARSE ERROR: $e');
            print('EMOJI CATEGORY DATA: $element');
            print('EMOJI CATEGORY STACK: $stackTrace');
          }
        } else {
          print(
            'EMOJI CATEGORY SKIPPED: unexpected item type '
            '${element.runtimeType}: $element',
          );
        }
      }
    } else {
      print(
        'EMOJI CATEGORY WARNING: expected a List, received '
        '${rawEmojiCategories.runtimeType}',
      );
    }

    print(
      'EMOJI CATEGORY PARSED COUNT: '
      '${emojisCategory.length}',
    );

    for (final category in emojisCategory) {
      print(
        'FINAL EMOJI CATEGORY: "${category.name}", '
        'emojis=${category.emoji?.length ?? 0}',
      );

      for (final emoji in category.emoji ?? []) {
        print(
          '  FINAL EMOJI: id=${emoji.id}, '
          'name=${emoji.emojiName}, '
          'image=${emoji.image}, '
          'svga=${emoji.emojiSvga}',
        );
      }
    }

    // ------------------------------------------------------------
    // Main constants
    // ------------------------------------------------------------
    Giftcatigoris =
        value['catigoris'] is List
            ? value['catigoris']
            : [];

    LuckyGiftcatigoris =
        value['luckycatigoris'] is List
            ? value['luckycatigoris']
            : [];

    Roomcatigoris =
        value['Roomcategory'] is List
            ? value['Roomcategory']
            : [];

    print('RAW ROOMCATEGORY: ${value['Roomcategory']}');
    print('RAW BACKGROUND: ${value['background']}');

    background =
        value['background'] is List
            ? value['background']
            : [];

    print(
      'ROOM CATEGORIES COUNT: ${Roomcatigoris.length}',
    );

    print(
      'ROOM CATEGORIES: $Roomcatigoris',
    );

    print(
      'ROOM BACKGROUNDS COUNT: ${background.length}',
    );

    print(
      'ROOM BACKGROUNDS: $background',
    );

    // ------------------------------------------------------------
    // Version
    // ------------------------------------------------------------
    if (value['version'] is Map) {
      final Map versionMap = value['version'] as Map;

      AppLink = (versionMap['AppLink'] ?? '').toString();
      Appversion = (versionMap['version'] ?? '').toString();

      print('APP VERSION: $Appversion');

      final dynamic forceUpdate = versionMap['ForceUpdate'];

      if (forceUpdate == 1 || forceUpdate == '1') {
        if (Appversion.isNotEmpty && Appversion != version) {
          Fluttertoast.showToast(
            msg:
                'يجب عليك تحديث التطبيق إلى الإصدار الأخير حتي تستطيع استخدامه',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 15.0,
          );

          if (AppLink.isNotEmpty) {
            Helper().launchInBrowser(AppLink);
          }

          SystemNavigator.pop();
        }
      }
    }

    // ------------------------------------------------------------
    // Shipping
    // ------------------------------------------------------------
    final dynamic rawShipping = value['Shipping'];

    if (rawShipping is List) {
      for (final dynamic element in rawShipping) {
        if (element is Map) {
          try {
            Shipping.add(
              shipping.fromJson(
                Map<String, dynamic>.from(element),
              ),
            );
          } catch (e, stackTrace) {
            print('SHIPPING PARSE ERROR: $e');
            print('SHIPPING DATA: $element');
            print('SHIPPING STACK: $stackTrace');
          }
        }
      }
    }

    print('SHIPPING COUNT: ${Shipping.length}');
// ------------------------------------------------------------
    // Cache constants
    // ------------------------------------------------------------
    final SharedPreferences prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      'ConstData',
      jsonEncode(value),
    );

    print('GET CONST DATA: parsing and cache complete');

    notifyListeners();
  });

  notifyListeners();
}
}
