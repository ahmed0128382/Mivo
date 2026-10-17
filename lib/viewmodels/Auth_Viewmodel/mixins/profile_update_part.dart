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


mixin ProfileUpdateMixin on LoginState {
// Update normal profile & photo
  updateNormalProfile({
    FlagCITY,
    ginder,
    City,
    token,
    context,
    Password,
    Description,
    name,
    PhoneNumber,
    year,
    month,
    day,
  }) async {
    ShowGlopalLoading();

    await userapi()
        .UpdatenormalProfile(
      token: token,
      Description: Description,
      context: context,
      Flag: FlagCITY,
      name: name,
      ginder: ginder,
      Image: Edimage,
      Password: Password,
      PhoneNumber: PhoneNumber,
      City: City,
      day: day,
      month: month,
      year: year,
    )
        .then((value) {
      if (value.id != null) {
        userinfo?.password = value.password;
        userinfo?.name = value.name;
        userinfo?.description = value.description;
        userinfo?.ginder = value.ginder;
        userinfo?.image = value.image;
      }

      DismissGlopalLoading();
    });

    notifyListeners();
  }

  updatephoto({
    token,
    photo,
    context,
    avatar,
  }) async {
    showSpinner2();

    await userapi()
        .FutureUpdatephoto(
      token: token,
      photo: photo,
      avatar: avatar,
      context: context,
    )
        .then((value) {
      hideSpinner();

      userinfo?.image = value;

      hideSpinner2();
    });

    notifyListeners();
  }

  SendCodeResetPassword({
    context,
    phonenumber,
  }) async {
    await userapi().SendPhoneCodeResetPassword(
      context: context,
      phonenumber: phonenumber,
    );

    notifyListeners();
}
}
