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


mixin ProfileImagesMixin on LoginState {
// Profile images pick / crop / add / delete
  Future ProfileImagepick(context) async {
    await userapi().getImageGalary().then((value) {
      if (value != null) {
        Cropimage2(value);
        print(value.runtimeType);
      }

      notifyListeners();
    });

    notifyListeners();
  }

  Cropimage2(value) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: value.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );

    if (croppedFile != null) {
      ProfileImage = File(croppedFile.path);

      AddProfileImage();

      notifyListeners();
    }
  }

  AddProfileImage() async {
    ShowGlopalLoading();

    await userapi()
        .AddProfileImage(
      image: ProfileImage,
    )
        .then((value) {
      if (value.id != null) {
        userProfileData?.ProfileImages?.add(
          value,
        );

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );

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
    });

    notifyListeners();
  }

  deleteProfileImage(imageid) async {
    ShowGlopalLoading();

    await userapi()
        .DeleteProfileImage(
      ImageId: imageid,
    )
        .then((value) {
      if (value == true) {
        userProfileData?.ProfileImages?.removeWhere(
          (element) => element.id == imageid,
        );

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

      notifyListeners();

      DismissGlopalLoading();
    });
}
}
