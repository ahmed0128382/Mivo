import 'dart:io';

import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'room_loading_mixin.dart';
import 'room_state_mixin.dart';
import 'room_ui_mixin.dart';

/// CreateRoom and related image helpers.
mixin RoomCreateMixin on RoomStateMixin, RoomLoadingMixin, RoomUiMixin {
  final ImagePicker _picker = ImagePicker();

  Future getChatRoomImage() async {
    bool selected = false;
    final pickedFile = await picker2.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      ChatRoomImage = File(pickedFile.path);
      selected = true;
      notifyListeners();
    } else {
      selected = false;
    }
    notifyListeners();
    return selected;
  }

  void clearadd() {
    // Clear create-room form fields (keep same as original)
    RoomName.clear();
    RoomAds.clear();
    choosen.clear();
    flagchoosen2.clear();
    Roomimage = null;
    RoomBackgroundImage = null;
    notifyListeners();
  }

  void ClearImage2() {
    Roomimage2 = null;
    notifyListeners();
  }

  void ClearImage3() {
    Roomimage3 = null;
    notifyListeners();
  }

  /// PASTE full CreateRoom body from original file.
  Future<bool> CreateRoom({
    required context,
    required name,
    required Category,
    required city,
    required File backgroundimage,
  }) async {
    // TODO: Paste full CreateRoom from original RoomViewmodel
    throw UnimplementedError('Paste CreateRoom from original file');
  }

  Future updateRoom() async {
    // TODO: Paste updateRoom from original if present
    throw UnimplementedError('Paste updateRoom from original file');
  }
}
