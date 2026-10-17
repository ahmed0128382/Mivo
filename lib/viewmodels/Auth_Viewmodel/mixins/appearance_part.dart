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


mixin AppearanceMixin on LoginState {
// Frames, bubbles, entry, colored message, hidden mode
  RemoveCoins({
    required int cost,
  }) {
    userinfo?.coins = (userinfo?.coins ?? 0) - cost;

    notifyListeners();
  }

  UpdateFrame({frames}) {
    userinfo?.frameimage = AppConstants.Image_URL + frames;

    notifyListeners();
  }

  UpdateEnterbubles({frames}) {
    userinfo?.Enterbubles = AppConstants.Image_URL + frames;

    notifyListeners();
  }

  UpdateProfilebubles({frames}) {
    userinfo?.bubbles = AppConstants.Image_URL + frames;

    notifyListeners();
  }

  removeFrame() {
    userinfo?.frameimage = '';
    notifyListeners();
  }

  removeEntry() {
    userinfo?.entry = '';
    notifyListeners();
  }

  removeEnterbubles() {
    userinfo?.Enterbubles = '';
    notifyListeners();
  }

  removeProfilebubles() {
    userinfo?.bubbles = '';
    notifyListeners();
  }

  UpdateEntry({Entry}) {
    userinfo?.entry = AppConstants.Image_URL + Entry;

    notifyListeners();
  }

  void ChangeHistory(Histor) {
    History = Histor;
    notifyListeners();
  }

  void ChangeCity({Cityname}) {
    City = Cityname;
    notifyListeners();
  }

  Removebubbles({context}) async {
    showSpinner13();

    await userapi()
        .Removebubbles(
      context: context,
    )
        .then((value) {
      if (value == true) {
        userinfo?.bubbles = null;

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }

      hideSpinner13();
    });

    notifyListeners();
  }

  updatebubbles({
    context,
    bubbles,
  }) async {
    ShowGlopalLoading();

    await userapi()
        .Updatebubbles(
      bubbles: bubbles,
      context: context,
    )
        .then((value) {
      if (value == true) {
        userinfo?.bubbles = AppConstants.Image_URL + bubbles;

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }

      DismissGlopalLoading();
    });

    notifyListeners();
  }

  updateColoredMessage({context}) async {
    showSpinner13();

    await userapi()
        .updateColoredMessage(
      Color: selectedcolor.first,
      context: context,
    )
        .then((value) {
      if (value == true) {
        userinfo?.ColoredMessage = Color;

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }

      hideSpinner13();
    });

    notifyListeners();
  }

  LoginId({context}) async {
    ShowGlopalLoading();

    await userapi().UserLoginID(
      ID: LoginID.text,
      Password: LoginPassword.text,
      context: context,
    );

    notifyListeners();
  }

  SetHidden({
    context,
    hidden,
  }) async {
    showSpinner13();

    await userapi()
        .setHidden(
      Hidden: hidden,
      context: context,
    )
        .then((value) {
      if (value == true) {
        userinfo?.Hidden = hidden;

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }

      hideSpinner13();
    });

    notifyListeners();
  }

  UserpdateEntry({
    context,
    Entry,
  }) async {
    ShowGlopalLoading();

    await shopapi()
        .UpdateEntry(
      Entry: Entry,
      context: context,
    )
        .then((value) {
      if (value == true) {
        userinfo?.entry = AppConstants.Image_URL + Entry;

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }

      DismissGlopalLoading();
    });

    notifyListeners();
  }

  UserpdateFrame({
    context,
    Frame,
  }) async {
    ShowGlopalLoading();

    await shopapi()
        .UpdateFrame(
      Frame: Frame,
      context: context,
    )
        .then((value) {
      if (value == true) {
        userinfo?.frameimage = AppConstants.Image_URL + Frame;

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }

      DismissGlopalLoading();
    });

    notifyListeners();
}
}
