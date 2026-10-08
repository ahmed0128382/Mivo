import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'room_loading_mixin.dart';
import 'room_state_mixin.dart';
import 'room_ui_mixin.dart';

/// JoinRoom2 / JoinRoom4 / JoinRoom5
///
/// PASTE the full method bodies from your original file here.
/// Signatures and logic must stay identical.
mixin RoomJoinMixin on RoomStateMixin, RoomLoadingMixin, RoomUiMixin {
  // ─────────────────────────────────────────────────────────────
  // JoinRoom4  (main entry used by EnterRoom / EnterRoom2)
  // ─────────────────────────────────────────────────────────────
  JoinRoom4({context, Roomid}) async {
    // TODO: Paste full JoinRoom4 body from original RoomViewmodel
    // Keep every line identical (Agora init, socket, navigation, etc.)
    throw UnimplementedError('Paste JoinRoom4 from original file');
  }

  // ─────────────────────────────────────────────────────────────
  // JoinRoom2
  // ─────────────────────────────────────────────────────────────
  JoinRoom2({context, Roomid}) async {
    // TODO: Paste full JoinRoom2 body from original RoomViewmodel
    throw UnimplementedError('Paste JoinRoom2 from original file');
  }

  // ─────────────────────────────────────────────────────────────
  // JoinRoom5
  // ─────────────────────────────────────────────────────────────
  JoinRoom5({context, Roomid}) async {
    // TODO: Paste full JoinRoom5 body from original RoomViewmodel
    throw UnimplementedError('Paste JoinRoom5 from original file');
  }

  bool checkadmin({context}) {
    final user = Provider.of<LoginViewmodel>(context, listen: false);
    if (Currentroom?.adminId.toString() == user.userinfo?.id.toString()) {
      return true;
    }
    return false;
  }
}
