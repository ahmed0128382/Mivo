
import 'package:ahlachat/main.dart';
import 'package:ahlachat/Repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_ui_mixin.dart';

mixin RoomLeaveMixin
    on RoomStateMixin, RoomLoadingMixin, RoomUiMixin {
  Future<void> Leaveroom({context}) async {
    if (LeaveLoading) return;

    final roomId = Currentroom?.id;
    if (roomId == null) return;

    // Resolve a live context before starting asynchronous work.
    final BuildContext? navigatorContext =
        NavigationService.navigatorKey.currentContext;

    final BuildContext? activeContext =
        context is BuildContext && context.mounted
            ? context
            : navigatorContext;

    if (activeContext == null) {
      debugPrint('[ROOM_LEAVE] No active context available.');
      return;
    }

    // Capture providers before the first await. Do not look them up again
    // through the room screen's context after it may have been disposed.
    final socket = Provider.of<SocketViewmodel>(
      activeContext,
      listen: false,
    );

    final agora = Provider.of<AgoraViewmodel>(
      activeContext,
      listen: false,
    );

    LeaveLoading = true;
    notifyListeners();

    try {
      final bool success = await Roomapi().LeaveRoom(
        context: NavigationService.navigatorKey.currentContext,
        Roomid: roomId,
      );

      if (!success) {
        final BuildContext? uiContext =
            NavigationService.navigatorKey.currentContext;

        if (uiContext != null && uiContext.mounted) {
          Dialogs().showtoast(
            getLang(context: uiContext, key: 'Sorry'),
          );
        }

        return;
      }

      debugPrint('[ROOM_LEAVE] Server confirmed leave for room $roomId.');

      // The server has confirmed leaving. Local cleanup must not turn
      // that success into a misleading "leave failed" result.
      try {
        socket.DisConnect(id: roomId);

        await agora.EndAgora();

        agora.disableAudioroomvoice();

        final BuildContext? cleanupContext =
            NavigationService.navigatorKey.currentContext;

        if (cleanupContext != null && cleanupContext.mounted) {
          agora.stopAudioMexing(cleanupContext);
        }
      } catch (error, stackTrace) {
        debugPrint('[ROOM_LEAVE] Local cleanup error: $error');
        debugPrintStack(stackTrace: stackTrace);
      }

      // Update room counts after the server confirms the leave.
      for (final room in Rooms) {
        if (room.id.toString() == roomId.toString()) {
          final currentCount = room.userNumber ?? 0;
          room.userNumber = currentCount > 0 ? currentCount - 1 : 0;
          break;
        }
      }

      for (final room in NewRooms) {
        if (room.id.toString() == roomId.toString()) {
          final currentCount = room.userNumber ?? 0;
          room.userNumber = currentCount > 0 ? currentCount - 1 : 0;
          break;
        }
      }

      // Clear the active room only after the API confirms success.
      Currentroom = null;
      removecurrentroom();

      final BuildContext? uiContext =
          NavigationService.navigatorKey.currentContext;

      if (uiContext != null && uiContext.mounted) {
        Dialogs().showtoast(
          getLang(context: uiContext, key: 'Leaved_Room'),
        );
      }

      debugPrint('[ROOM_LEAVE] Local room state cleared.');
    } catch (error, stackTrace) {
      debugPrint('[ROOM_LEAVE] Leave operation error: $error');
      debugPrintStack(stackTrace: stackTrace);

      final BuildContext? uiContext =
          NavigationService.navigatorKey.currentContext;

      if (uiContext != null && uiContext.mounted) {
        Dialogs().showtoast(
          getLang(context: uiContext, key: 'Sorry'),
        );
      }
    } finally {
      LeaveLoading = false;
      notifyListeners();
    }
  }

  Evictionuser({
    Userid,
    context,
  }) async {
    await Roomapi()
        .Evictionuser(
          context: context,
          Roomid: Currentroom?.id,
          Userid: Userid,
        )
        .then((value) {
      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: value == true ? 'Done_Succ' : 'Sorry',
        ),
      );

      notifyListeners();
    });
  }

  RemoveRoomFromlist({RoomId}) {
    Rooms.removeWhere(
      (element) => element.id.toString() == RoomId.toString(),
    );

    NewRooms.removeWhere(
      (element) => element.id.toString() == RoomId.toString(),
    );

    notifyListeners();
  }

  DisbandRoom({context}) async {
    final user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    final agora = Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    final roomId = Currentroom?.id;

    final value = await Roomapi().DisbandRoom(
      context: context,
      Roomid: roomId,
    );

    if (value == true) {
      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: 'Done_Succ',
        ),
      );

      await agora.EndAgora();

      Rooms.removeWhere(
        (element) => element.id.toString() == roomId.toString(),
      );

      NewRooms.removeWhere(
        (element) => element.id.toString() == roomId.toString(),
      );

      user.userinfo?.currentroom = null;
      Currentroom = null;
      removecurrentroom();
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

  AddusertoRoom({
    usermodel? join,
    joinRoom? JoinRoom,
    ctx,
    index,
  }) {
    final user = Provider.of<LoginViewmodel>(
      ctx,
      listen: false,
    );

    if (join?.id.toString() != user.userinfo?.id.toString()) {
      Currentroom?.userNumber = (Currentroom?.userNumber ?? 0) + 1;

      final members = Currentroom?.joinRooms;

      if (members != null && JoinRoom != null) {
        final alreadyMember = members.any(
          (member) =>
              member.userId.toString() == JoinRoom.userId.toString(),
        );

        if (!alreadyMember) {
          members.insert(0, JoinRoom);
        }
      }

      debugPrint('[ROOM_MEMBERS] Participant added: ${join?.id}');
    }

    notifyListeners();
  }

  RemoveuserfromRoom({String? id}) {
    if (id == null) return;

    ComboListuser.removeWhere(
      (element) => element.toString() == id.toString(),
    );

    final String roomId = Currentroom?.id.toString() ?? '';

    for (final room in Rooms) {
      if (room.id.toString() == roomId) {
        final count = room.userNumber ?? 0;
        room.userNumber = count > 0 ? count - 1 : 0;
      }
    }

    for (final room in NewRooms) {
      if (room.id.toString() == roomId) {
        final count = room.userNumber ?? 0;
        room.userNumber = count > 0 ? count - 1 : 0;
      }
    }

    Currentroom?.joinRooms?.removeWhere(
      (member) => member.userId.toString() == id.toString(),
    );

    final currentCount = Currentroom?.userNumber ?? 0;

    if (currentCount > 0) {
      Currentroom?.userNumber = currentCount - 1;
    }

    // Membership-based removal only. No chair state is accessed.
    notifyListeners();
  }
}
