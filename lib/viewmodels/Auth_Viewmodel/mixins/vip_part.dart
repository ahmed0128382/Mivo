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


mixin VipMixin on LoginState {
// Buy / use / remove VIP
  ByeVip({
    context,
    VipModel? vip,
  }) async {
    ShowGlopalLoading();

    await userapi()
        .ByeVip(
      context: context,
      Vip: vip,
    )
        .then((value) {
      if (value?.id != null) {
        userinfo?.coins = (userinfo?.coins ?? 0) - (vip?.cost ?? 0);

        userinfo?.Karisma = ((userinfo?.Karisma ?? 0) +
            ((value?.Vip?.level ?? 0) * LEVELAMOUNT)) as int?;

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );
      }

      DismissGlopalLoading();
    });

    notifyListeners();
  }

  UseVip({
    context,
    MyVipmodel? Myvip,
  }) async {
    ShowGlopalLoading();

    await userapi()
        .UseVip(
      Vip: Myvip,
    )
        .then((value) {
      if (value?.id != null) {
        userinfo?.MyVip = value;

        if (value?.newId != null) {
          userinfo?.Newid = value?.newId;
        }

        if (value?.Vip?.coloredMessage != null) {
          userinfo?.ColoredMessage = value?.Vip?.coloredMessage;
        }

        if (value?.Vip?.hidden != 0) {
          userinfo?.Hidden = 1;
        }

        if (value?.Vip?.entry != null) {
          userinfo?.entry = value?.Vip?.urlentry;
        }

        if (value?.Vip?.frame != null) {
          userinfo?.frameimage = value?.Vip?.urlframe;
        }

        if (value?.Vip?.bubbles != null) {
          userinfo?.frameimage = value?.Vip?.profileEntry;
        }

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );

        notifyListeners();
      }

      DismissGlopalLoading();
    });

    notifyListeners();
  }

  RemoveVip({
    MyVipmodel? MyVip,
  }) async {
    ShowGlopalLoading();

    await userapi()
        .RemoveVip(
      MyVip: MyVip,
    )
        .then((value) {
      if (value == true) {
        userinfo?.MyVip = null;

        if (MyVip?.Vip?.urlentry == userinfo?.entry) {
          userinfo?.entry = null;
        }

        if (MyVip?.Vip?.urlframe == userinfo?.frameimage) {
          userinfo?.frameimage = null;
        }

        if (MyVip?.Vip?.profileEntry == userinfo?.bubbles) {
          userinfo?.bubbles = null;
        }

        if (MyVip?.newId == userinfo?.Newid) {
          userinfo?.Newid = null;
        }

        if (MyVip?.colorMessage == userinfo?.ColoredMessage) {
          userinfo?.ColoredMessage = null;
        }

        if (MyVip?.Vip?.hidden == 1) {
          userinfo?.Hidden = 0;
        }

        notifyListeners();
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }

      DismissGlopalLoading();
      notifyListeners();
    });

    notifyListeners();
}
}
