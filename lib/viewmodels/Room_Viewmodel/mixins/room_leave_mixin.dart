import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'room_loading_mixin.dart';
import 'room_state_mixin.dart';
import 'room_ui_mixin.dart';

/// Leave room, disband, eviction, remove user from room.
mixin RoomLeaveMixin on RoomStateMixin, RoomLoadingMixin, RoomUiMixin {
  Leaveroom({context}) async {
    // TODO: Paste full Leaveroom from original
    throw UnimplementedError('Paste Leaveroom from original file');
  }

  DisbandRoom({context}) async {
    throw UnimplementedError('Paste DisbandRoom from original file');
  }

  Evictionuser({Userid, context}) async {
    throw UnimplementedError('Paste Evictionuser from original file');
  }

  RemoveuserfromRoom({String? id}) {
    // Partial logic present in original – paste full body
    throw UnimplementedError('Paste RemoveuserfromRoom from original file');
  }

  RemoveRoomFromlist({RoomId}) {
    Rooms.removeWhere((element) => element.id == RoomId);
    NewRooms.removeWhere((element) => element.id == RoomId);
    notifyListeners();
  }

  AddusertoRoom({usermodel? join, joinRoom, ctx, index}) {
    throw UnimplementedError('Paste AddusertoRoom from original file');
  }
}
