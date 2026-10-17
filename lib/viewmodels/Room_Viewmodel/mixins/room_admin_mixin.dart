import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/Repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:provider/provider.dart';

import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_join_mixin.dart';
import 'room_ui_mixin.dart';

/// Room administration without chair assignment.
///
/// Room membership is handled through the room join/leave APIs.
/// Chair assignment and chair invitation are intentionally not used.
mixin RoomAdminMixin
    on RoomStateMixin, RoomLoadingMixin, RoomJoinMixin, RoomUiMixin {
  Future<void> getRoomSupervisor() async {
    ShowGlopalLoading();

    try {
      final value = await Roomapi().GetRoomSupercisors(
        Roomid: Currentroom?.id,
      );

      Currentroom?.supervisor = value;
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  Future<void> AddsupervisorsRoom({
    dynamic context,
    dynamic userid,
  }) async {
    try {
      final value = await Roomapi().Addsupervisors(
        context: context,
        Roomid: Currentroom?.id,
        userid: userid,
      );

      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: value == true ? 'Done_Succ' : 'Sorry',
        ),
      );
    } finally {
      hideSpinner31();
      notifyListeners();
    }
  }

  Future<void> FollowRoom({dynamic context}) async {
    final value = await Roomapi().FollowRoom(
      context: context,
      Roomid: Currentroom?.id,
    );

    Currentroom?.FollowRoom = value == true ? 1 : 0;
    notifyListeners();
  }

  Future<void> RemoveFollowRoom({dynamic context}) async {
    final value = await Roomapi().RemoveFollowRoom(
      context: context,
      Roomid: Currentroom?.id,
    );

    Currentroom?.FollowRoom = value == true ? 0 : 1;
    notifyListeners();
  }

  /// Invites a user to join a room.
  ///
  /// This is a room-membership invitation, not a chair invitation.
  void InviteToRoom({
    dynamic user,
    dynamic Roominfo,
    dynamic context,
  }) {
    final playroom = Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    );

    final room = Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    final svga = Provider.of<SvgViewmodel>(
      context,
      listen: false,
    );

    final bool isSameRoom =
        Roominfo['id'].toString() == Currentroom?.id.toString();

    if (isSameRoom && playroom.HasRoom) {
      Dialogs().showdialog5(
        context: context,
        content:
            '${user['name']} ${getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: 'INVITE_SET',
        )}',
      );
      return;
    }

    Dialogs().showdialog(
      context: context,
      content:
          '${user['name']} ${getLang(
        context: NavigationService.navigatorKey.currentContext,
        key: 'inviteyou',
      )} ${Roominfo['name']} ${getLang(
        context: NavigationService.navigatorKey.currentContext,
        key: 'Room_now',
      )}',
      onTap: () {
        Navigator.pop(context);

        Provider.of<GiftsViewModel>(
          context,
          listen: false,
        ).hidpanner2();

        svga.dispose();

        if (playroom.HasRoom) {
          room.JoinRoom2(
            Roomid: Roominfo['id'],
            context: context,
          );
        } else {
          room.JoinRoom5(
            Roomid: Roominfo['id'],
            context: context,
          );
        }
      },
      tittle: '',
      buttontext: getLang(
        context: context,
        key: 'Yes',
      ),
    );

    notifyListeners();
  }

  Future<void> RemovesupervisorsRoom({
    dynamic context,
    dynamic userid,
  }) async {
    ShowGlopalLoading();

    try {
      final value = await Roomapi().Removesupervisors(
        context: context,
        Roomid: Currentroom?.id,
        userid: userid,
      );

      if (value == true) {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Done_Succ',
          ),
        );

        Currentroom?.supervisor?.removeWhere(
          (element) => element.user?.id.toString() == userid.toString(),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Sorry',
          ),
        );
      }
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  void Addsupervisors({dynamic id}) {
    Currentroom?.supervisorsId ??= <String>[];

    final supervisors = Currentroom!.supervisorsId!;

    if (!supervisors.any((element) => element.toString() == id.toString())) {
      supervisors.add(id.toString());
    }

    notifyListeners();
  }

  void Removesupervisors({dynamic id}) {
    Currentroom?.supervisorsId?.removeWhere(
      (element) => element.toString() == id.toString(),
    );

    notifyListeners();
  }

  Future<void> SetRoomPassword({
    dynamic context,
    dynamic PasswordRoom,
  }) async {
    ShowGlopalLoading();

    try {
      final value = await Roomapi().SetRoomPssword(
        context: context,
        roomid: Currentroom?.id,
        password: PasswordRoom.text,
      );

      if (value != null) {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Done_Succ',
          ),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Sorry',
          ),
        );
      }

      PasswordRoom.clear();
      Navigator.pop(context);
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  Future<void> RemoveRoomPassword({dynamic context}) async {
    ShowGlopalLoading();

    try {
      final value = await Roomapi().RemoveRoomPssword(
        context: context,
        roomid: Currentroom?.id,
      );

      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: value != null ? 'Done_Succ' : 'Sorry',
        ),
      );
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  Future<void> updatemute({
    dynamic context,
    dynamic state,
    dynamic user_id,
  }) async {
    final value = await Roomapi().Updatemute(
      context: context,
      room_id: Currentroom?.id,
      state: state,
      user_id: user_id,
    );

    if (value == true) {
      final int userId = int.parse(user_id.toString());
      final agora = Provider.of<AgoraViewmodel>(
        roomcontext,
        listen: false,
      );

      if (state == 1) {
        agora.muteusermic(userId);
      } else {
        agora.unmuteusermic(userId);
      }
    } else {
      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: 'Sorry',
        ),
      );
    }

    notifyListeners();
  }

  Future<void> GetUserJoin({dynamic context}) async {
    ShowGlopalLoading();

    try {
      final participants = await Roomapi().Roomsjoinuser(
        context: context,
        room_id: Currentroom?.id,
      );

      // An empty list is valid: nobody else may have joined yet.
      joinuserRooms = participants;
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  /// Updates room metadata only. Participant membership is loaded separately
  /// from the GetJoinUsers/Roomsjoinuser endpoint, never from chairs.
  void updateCurrentRoom({required RoomModel NewRoom}) {
    if (Currentroom?.id == NewRoom.id) {
      Currentroom?.name = NewRoom.name;
      Currentroom?.animateimage = NewRoom.animateimage;
      Currentroom?.locked = NewRoom.locked;
      Currentroom?.password = NewRoom.password;
      Currentroom?.image = NewRoom.image;
      Currentroom?.Category = NewRoom.Category;
      Currentroom?.nothostedimage = NewRoom.nothostedimage;
      Currentroom?.RoomAds = NewRoom.RoomAds;
      Currentroom?.adminId = NewRoom.adminId;
      Currentroom?.userNumber = NewRoom.userNumber;
    }

    for (final element in Rooms) {
      if (element.id == NewRoom.id) {
        element.name = NewRoom.name;
        element.image = NewRoom.image;
        element.password = NewRoom.password;
        element.RoomAds = NewRoom.RoomAds;
        element.Category = NewRoom.Category;
        element.adminId = NewRoom.adminId;
        element.userNumber = NewRoom.userNumber;
      }
    }

    notifyListeners();
  }

  void updateCurrentRoomPassword({
    required dynamic Password,
    required String Id,
  }) {
    Currentroom?.password = Password;

    for (final element in Rooms) {
      if (element.id.toString() == Id) {
        element.password = Password;
      }
    }

    notifyListeners();
  }

  Future<void> GetKickeduser({dynamic context}) async {
    ShowGlopalLoading();

    try {
      BlockeduserRooms = await Roomapi().KickedUserRooms(
        context: context,
        roomid: Currentroom?.id,
      );
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }

  Future<void> unkickuserRoom({
    dynamic context,
    dynamic kickid,
  }) async {
    ShowGlopalLoading();

    try {
      final value = await Roomapi().UnkickeuserRoom(
        context: context,
        kickid: kickid,
      );

      if (value != false) {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Done_Succ',
          ),
        );

        BlockeduserRooms.removeWhere(
          (element) => element.id.toString() == kickid.toString(),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Sorry',
          ),
        );
      }
    } finally {
      DismissGlopalLoading();
      notifyListeners();
    }
  }
}
