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


mixin UserRoomMixin on LoginState {
// Spinners, room user info, signup check, login verify

  getuserroominfo({usermodel? user}) {
    userroominfo = user;
    notifyListeners();
  }

  userinfoRoom({
    id,
    context,
  }) async {
    RoomViewmodel Room = Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    showSpinner3();

    await userapi()
        .userinfoRoom(
      id: id,
      roomid: Room.Currentroom?.id.toString(),
      context: context,
    )
        .then((value) {
      hideSpinner3();

      if (value.id != null) {
        userroominfo = value;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  checksignup({
    name,
    phone,
    context,
  }) async {
    showSpinner();

    await userapi()
        .CheckRegester(
      name: name,
      phone: phone,
      context: context,
    )
        .then((value) {
      hideSpinner();
    });

    notifyListeners();
  }

  UserLoginVerify({
    context,
    Parimater,
  }) async {
    ShowGlopalLoading(); await userapi()
        .UserLoginVerify(
      context: context,
      Parimater: Parimater,
    )
        .then((value) {
      hideSpinner();

      if (value.id != null) {
        userinfo = value;
      }
    }).then(
      (value) => hideSpinner(),
    );

    notifyListeners();
  }

  userinformation({context}) async {
    userinfo = await userapi().Userinfo(
      context: context,
    );

    notifyListeners();
  }

  userinformationID({
    ID,
    context,
  }) async {
    showSpinner();

    await userapi()
        .UserinfoID(
      ID: ID.toString(),
      context: context,
    )
        .then((value) {
      if (value.id != null) {
        playerinfo = value;
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );

        Navigator.pop(context);
      }

      hideSpinner();
    });

    notifyListeners();
}
}
