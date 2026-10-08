import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'room_join_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_state_mixin.dart';

/// Supervisors, follow, password, mute, invites, kick.
mixin RoomAdminMixin on RoomStateMixin, RoomLoadingMixin, RoomJoinMixin {
  GetRoomSupervisor() async {
    ShowGlopalLoading();
    await Roomapi().GetRoomSupercisors(Roomid: Currentroom?.id).then((value) {
      Currentroom?.supervisor = value;
      DismissGlopalLoading();
    });
    notifyListeners();
  }

  AddsupervisorsRoom({context, userid}) async {
    // TODO: Paste full body
    throw UnimplementedError('Paste AddsupervisorsRoom from original');
  }

  RemovesupervisorsRoom({context, userid}) async {
    throw UnimplementedError('Paste RemovesupervisorsRoom from original');
  }

  Addsupervisors({id}) {
    Currentroom?.supervisorsId?.add(id);
    notifyListeners();
  }

  Removesupervisors({id}) {
    Currentroom?.supervisorsId?.removeWhere((element) => element == id);
    notifyListeners();
  }

  FollowRoom({context}) async {
    throw UnimplementedError('Paste FollowRoom from original');
  }

  RemoveFollowRoom({context}) async {
    throw UnimplementedError('Paste RemoveFollowRoom from original');
  }

  SetRoomPassword({context, PasswordRoom}) async {
    throw UnimplementedError('Paste SetRoomPassword from original');
  }

  RemoveRoomPassword({context}) async {
    throw UnimplementedError('Paste RemoveRoomPassword from original');
  }

  updatemute({context, state, user_id}) async {
    throw UnimplementedError('Paste updatemute from original');
  }

  InviteToRoom({user, Roominfo, context}) {
    throw UnimplementedError('Paste InviteToRoom from original');
  }

  InviteToChair({user, Roominfo, Chair_id, context}) {
    throw UnimplementedError('Paste InviteToChair from original');
  }

  KickJoinadminuser({context, user_id}) async {
    throw UnimplementedError('Paste KickJoinadminuser from original');
  }

  InviteUserToSET({context, user_id}) async {
    throw UnimplementedError('Paste InviteUserToSET from original');
  }

  SentInviteChairRoom({context, user_id}) async {
    throw UnimplementedError('Paste SentInviteChairRoom from original');
  }

  unkickuserRoom({context, kickid}) async {
    throw UnimplementedError('Paste unkickuserRoom from original');
  }

  GetUserJoin({context}) async {
    throw UnimplementedError('Paste GetUserJoin from original');
  }

  GetKickeduser({context}) async {
    throw UnimplementedError('Paste GetKickeduser from original');
  }

  updateCurrentRoom({required RoomModel NewRoom}) {
    throw UnimplementedError('Paste updateCurrentRoom from original');
  }

  updateCurrentRoomPassword({required var Password, required String Id}) {
    Currentroom?.password = Password;
    Rooms.forEach((element) {
      if (element.id.toString() == Id.toString()) {
        element.password = Password;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  updateThroneChair({State, context}) async {
    throw UnimplementedError('Paste updateThroneChair from original');
  }
}
