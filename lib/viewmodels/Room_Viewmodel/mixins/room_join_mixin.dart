
import 'dart:async';

import 'package:ahlachat/Repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_ui_mixin.dart';

mixin RoomJoinMixin on RoomStateMixin, RoomLoadingMixin, RoomUiMixin {
  String _currentUserId(LoginViewmodel user) {
    return (user.userinfo?.id?.toString() ?? UserId.toString()).trim();
  }

  String _roomAdminId(dynamic room) {
    return (
      room.adminId?.toString() ??
      room.admin?.id?.toString() ??
      ''
    ).trim();
  }

  bool _isRoomAdmin(dynamic room, LoginViewmodel user) {
    final String adminId = _roomAdminId(room);
    final String currentUserId = _currentUserId(user);

    return adminId.isNotEmpty &&
        currentUserId.isNotEmpty &&
        adminId == currentUserId;
  }

  Future<void> _joinRoom({
    required BuildContext context,
    required dynamic roomId,
    required bool openRoomScreen,
    required bool clearCurrentRoomFirst,
  }) async {
    if (LeaveLoading) {
      Dialogs().showtoast('رجاء انتظر ترك الغرفه');
      return;
    }

    if (roomId == null || roomId.toString().trim().isEmpty) {
      debugPrint('[ROOM_JOIN] Rejected join: empty room ID');
      return;
    }

    final socket = Provider.of<SocketViewmodel>(
      context,
      listen: false,
    );
    final agora = Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );
    final user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    showSpinner3();

    try {
      // Disconnect the previous room before joining another one.
      socket.DisConnect(id: Currentroom?.id);

      if (clearCurrentRoomFirst) {
        Currentroom = null;
        joinuserRooms = [];
      }

      await agora.EndAgora();

      final joinedRoom = await Roomapi().joinRooms(
        context: context,
        Roomid: roomId,
      );

      if (!context.mounted) return;

      if (joinedRoom.state == 1) {
        Rooms.removeWhere(
          (room) => room.id.toString() == roomId.toString(),
        );
        NewRooms.removeWhere(
          (room) => room.id.toString() == roomId.toString(),
        );

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: 'Room_Disbanded',
          ),
        );
        return;
      }

      if (joinedRoom.id == null) {
        debugPrint(
          '[ROOM_JOIN] Join failed: response has no room ID '
          '(requested=$roomId)',
        );
        return;
      }

      Currentroom = joinedRoom;

      // Do not show participants from the previous room while refreshing.
      joinuserRooms = [];
      Currentroom?.joinRooms = [];
      notifyListeners();

      final String channelName =
          joinedRoom.id?.toString().trim() ?? '';
      final String token = joinedRoom.Token?.toString().trim() ?? '';
      final bool isAdmin = _isRoomAdmin(joinedRoom, user);

      if (channelName.isEmpty || token.isEmpty) {
        debugPrint(
          '[ROOM_JOIN] Missing Agora configuration '
          '(room=${joinedRoom.id}, '
          'channelEmpty=${channelName.isEmpty}, '
          'tokenEmpty=${token.isEmpty})',
        );
      } else {
        // Audio connection failure must not block loading membership/UI.
        try {
          await agora.initialize(
            role: isAdmin
                ? ClientRole.Broadcaster
                : ClientRole.Audience,
            Token: token,
            channelName: channelName,
          );
        } catch (error, stackTrace) {
          debugPrint('[ROOM_JOIN][AGORA] Initialize failed: $error');
          if (kDebugMode) {
            debugPrintStack(stackTrace: stackTrace);
          }
        }
      }

      if (!context.mounted) return;

      // Membership is the source of truth for the participants panel.
      try {
        final participants = await Roomapi().Roomsjoinuser(
          context: context,
          room_id: joinedRoom.id,
        );

        if (Currentroom?.id.toString() == joinedRoom.id.toString()) {
          final refreshedParticipants = List.of(participants);

          // RoomParticipantsPanel reads room.joinuserRooms.
          joinuserRooms = refreshedParticipants;

          // Keep the existing room model in sync for other widgets.
          Currentroom?.joinRooms = refreshedParticipants;

          debugPrint(
            '[ROOM_JOIN][MEMBERS] '
            'room=${joinedRoom.id}, '
            'count=${refreshedParticipants.length}, '
            'currentUser=$_currentUserId(user), '
            'admin=${_roomAdminId(joinedRoom)}',
          );

          notifyListeners();
        }
      } catch (error, stackTrace) {
        debugPrint('[ROOM_JOIN] Participant refresh failed: $error');
        if (kDebugMode) {
          debugPrintStack(stackTrace: stackTrace);
        }
      }

      if (!context.mounted) return;

      final roomVM = Provider.of<RoomViewmodel>(
        roomcontext,
        listen: false,
      );

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).hidpanner();

      Provider.of<SvgViewmodel>(
        context,
        listen: false,
      ).animationController?.clear();

      roomVM.initscrollcontroller();

      socket.ConnectRoomScocket(context, joinedRoom.id);

      final roomPlay = Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      );
      roomPlay.changeHasRoomstate(true);
      roomPlay.changeIsRoomstate(true);

      if (joinedRoom.RoomAds != null &&
          joinedRoom.RoomAds!.trim().isNotEmpty) {
        joinedRoom.chatroom ??= [];

        final bool adAlreadyAdded = joinedRoom.chatroom!.any(
          (message) =>
              message.kind == 1 &&
              message.content == joinedRoom.RoomAds,
        );

        if (!adAlreadyAdded) {
          joinedRoom.chatroom!.add(
            Chatroom(
              kind: 1,
              user: joinedRoom.admin,
              id: 0,
              content: joinedRoom.RoomAds,
              userId: joinedRoom.admin?.id.toString(),
              updatedAt: joinedRoom.updatedAt,
              roomId: joinedRoom.id.toString(),
              createdAt: joinedRoom.createdAt,
            ),
          );
        }
      }

      // Legacy compatibility flag only.
      agora.KickedFromChair = false;

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).DeleteGlopal();

      HideEnterWidget();

      final int? userId = int.tryParse(_currentUserId(user));
      if (userId != null) {
        agora.unmuteusermic(userId);
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (!context.mounted) return;

        try {
          final gifts = Provider.of<GiftsViewModel>(
            context,
            listen: false,
          );

          gifts.sidepanner();

          final String entry = user.userinfo?.entry?.trim() ?? '';
          if (entry.isEmpty) return;

          Provider.of<SvgViewmodel>(
            context,
            listen: false,
          ).getcontroller(
            enterImage: user.userinfo?.image,
            entername: user.userinfo?.name,
            svga: entry,
          );
        } catch (error) {
          debugPrint('[ROOM_JOIN] Entry animation failed: $error');
        }
      });

      if (openRoomScreen) {
        Navigator.pushNamed(
          context,
          AppConstants.Room_Screan,
        );
      }
    } catch (error, stackTrace) {
      debugPrint('[ROOM_JOIN] Join failed: $error');

      if (kDebugMode) {
        debugPrintStack(stackTrace: stackTrace);
      }
    } finally {
      hideSpinner3();
      notifyListeners();
    }
  }

  Future<void> JoinRoom4({
    required dynamic context,
    required dynamic Roomid,
  }) async {
    if (context is! BuildContext) return;

    await _joinRoom(
      context: context,
      roomId: Roomid,
      openRoomScreen: true,
      clearCurrentRoomFirst: true,
    );
  }

  Future<void> JoinRoom2({
    required dynamic context,
    required dynamic Roomid,
  }) async {
    if (context is! BuildContext) return;

    await _joinRoom(
      context: context,
      roomId: Roomid,
      openRoomScreen: false,
      clearCurrentRoomFirst: false,
    );
  }

  Future<void> JoinRoom5({
    required dynamic context,
    required dynamic Roomid,
  }) async {
    if (context is! BuildContext) return;

    await _joinRoom(
      context: context,
      roomId: Roomid,
      openRoomScreen: true,
      clearCurrentRoomFirst: true,
    );
  }

  bool checkadmin({
    required BuildContext context,
  }) {
    final user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    return _isRoomAdmin(Currentroom, user);
  }
}
