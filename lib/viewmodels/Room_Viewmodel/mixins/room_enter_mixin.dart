import 'package:ahlachat/Repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_ViewModel/helpers/room_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'room_join_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_state_mixin.dart';
import 'room_ui_mixin.dart';

/// EnterRoom / EnterRoom2 / EnterRoom3 + password helpers.
mixin RoomEnterMixin
    on RoomStateMixin, RoomLoadingMixin, RoomUiMixin, RoomJoinMixin {
  Future<bool> TrackRoomPassword(id) async {
    ShowGlopalLoading();
    return await Roomapi().CheckPassworRooms(id: id.toString());
  }

  Future<bool> EnterTrackRoomPassword({id, pass}) async {
    ShowGlopalLoading();
    return await Roomapi().EnterCheckPassworRooms(
      id: id.toString(),
      pass: pass,
    );
  }

  EnterRoom({
    required id,
    required context,
    required adminId,
  }) async {
    if (LeaveLoading == true) {
      Dialogs().showtoast('رجاء انتظر ترك الغرفه');
      return 'asd';
    }

    if (Currentroom?.id.toString() == id.toString()) {
      Provider.of<SvgViewmodel>(context, listen: false)
          .animationController
          ?.clear();

      // RoomViewmodel is the combined class – initscrollcontroller lives in UI mixin
      initscrollcontroller();

      Provider.of<GiftsViewModel>(context, listen: false).DeleteGlopal();
      Provider.of<AgoraViewmodel>(context, listen: false)
          .stopAudioMexing(context);

      HideEnterWidget();

      Navigator.pushNamed(context, AppConstants.Room_Screan);
    } else {
      await TrackRoomPassword(id).then((password) {
        if (password == true &&
            adminId.toString() != UserId &&
            Provider.of<LoginViewmodel>(context, listen: false)
                    .userinfo
                    ?.Hidden ==
                0) {
          showRoomPasswordDialog(
            context: context,
            id: id,
            enterTrackRoomPassword: EnterTrackRoomPassword,
            onSuccess: () => JoinRoom4(Roomid: id, context: context),
          );
        } else {
          Provider.of<GiftsViewModel>(context, listen: false).hidpanner2();
          JoinRoom4(Roomid: id, context: context);
        }
      });
    }
  }

  EnterRoom2({id, context}) async {
    if (LeaveLoading == true) {
      Dialogs().showtoast('رجاء انتظر ترك الغرفه');
      return 'asd';
    }

    if (Currentroom?.id.toString() == id.toString()) return;

    await TrackRoomPassword(id).then((password) {
      if (password == true) {
        showRoomPasswordDialog(
          context: context,
          id: id,
          enterTrackRoomPassword: EnterTrackRoomPassword,
          onSuccess: () => JoinRoom4(context: context, Roomid: id),
        );
      } else {
        Provider.of<GiftsViewModel>(context, listen: false).hidpanner2();
        JoinRoom4(context: context, Roomid: id);
      }
    });
  }

  EnterRoom3({id, context}) async {
    if (LeaveLoading == true) {
      Dialogs().showtoast('رجاء انتظر ترك الغرفه');
      return 'asd';
    }

    if (Currentroom?.id.toString() == id.toString()) return;

    await TrackRoomPassword(id).then((password) {
      if (password == true) {
        showRoomPasswordDialog(
          context: context,
          id: id,
          enterTrackRoomPassword: EnterTrackRoomPassword,
          onSuccess: () => JoinRoom2(context: context, Roomid: id),
        );
      } else {
        Provider.of<GiftsViewModel>(context, listen: false).hidpanner2();
        JoinRoom2(context: context, Roomid: id);
      }
    });
  }
}
