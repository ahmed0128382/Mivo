
import 'dart:async';

import 'package:ahlachat/Repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';

import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_ui_mixin.dart';

mixin RoomJoinMixin on RoomStateMixin, RoomLoadingMixin, RoomUiMixin {
  // ------------------------------------------------------------
  // CHAIR HELPERS
  // ------------------------------------------------------------

  /// Finds the chair occupied by the current user.
  ///
  /// Uses the user ID instead of a hardcoded list index.
  int _findCurrentUserChairIndex(dynamic room) {
    if (room == null || room.chairs is! List) {
      return -1;
    }

    final List<dynamic> chairs = room.chairs as List<dynamic>;
    final String currentUserId = UserId.toString();

    for (int i = 0; i < chairs.length; i++) {
      final dynamic chair = chairs[i];

      final String? userId = chair.userId?.toString();
      final String? nestedUserId = chair.user?.id?.toString();

      if (userId == currentUserId ||
          nestedUserId == currentUserId) {
        return i;
      }
    }

    return -1;
  }

  /// Resets only the current user's chair.
  ///
  /// If the chair cannot be identified, no chair is modified.
  void _resetAdminChair(dynamic room) {
    if (room == null || room.chairs is! List) {
      return;
    }

    final List<dynamic> chairs = room.chairs as List<dynamic>;
    final int index = _findCurrentUserChairIndex(room);

    if (index < 0 || index >= chairs.length) {
      return;
    }

    final dynamic chair = chairs[index];

    chair.mute = 0;
    chair.adminleaved = 0;
  }

  // ------------------------------------------------------------
  // JOIN ROOM 4
  // ------------------------------------------------------------

  Future<void> JoinRoom4({
    required dynamic context,
    required dynamic Roomid,
  }) async {
    Provider.of<SocketViewmodel>(
      context,
      listen: false,
    ).DisConnect(
      id: Currentroom?.id,
    );

    Currentroom?.id = 0;
    Currentroom = null;

    final AgoraViewmodel agora = Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    final LoginViewmodel user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    await agora.EndAgora();

    await Roomapi()
        .joinRooms(
          context: context,
          Roomid: Roomid,
        )
        .then((value) async {
      DismissGlopalLoading();

      if (value.state == 1) {
        Rooms.removeWhere(
          (element) => element.id == Roomid,
        );

        NewRooms.removeWhere(
          (element) => element.id == Roomid,
        );

        Dialogs().showtoast(
          getLang(
            context: NavigationService
                .navigatorKey
                .currentContext,
            key: 'Room_Disbanded',
          ),
        );

        return;
      }

      if (value.id == null) {
        debugPrint('JOIN ROOM 4: Room ID is null');
        return;
      }

      JoinChairs = false;

      final String agoraChannel =
          value.id?.toString().trim() ?? '';
      final String agoraToken =
          value.Token?.toString().trim() ?? '';

      final bool isAdmin =
          value.admin?.id.toString() == UserId.toString();

      if (agoraChannel.isEmpty) {
        debugPrint('JOIN ROOM 4: Agora channel is empty');
        return;
      }

      if (agoraToken.isEmpty) {
        debugPrint('JOIN ROOM 4: Agora token is empty');
        return;
      }

      if (isAdmin) {
        JoinChairs = true;

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Broadcaster,
          Token: agoraToken,
          channelName: agoraChannel,
        );

        final roomVM = Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        );

        _resetAdminChair(roomVM.Currentroom);
      } else {
        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Audience,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      }

      // Preserve the existing global room assignment.
      Currentroom = value;

      final roomVM = Provider.of<RoomViewmodel>(
        roomcontext,
        listen: false,
      );

      if (checkadmin(context: context)) {
        _resetAdminChair(roomVM.Currentroom);
      }

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).hidpanner();

      Provider.of<SvgViewmodel>(
        context,
        listen: false,
      ).animationController?.clear();

      Provider.of<RoomViewmodel>(
        context,
        listen: false,
      ).initscrollcontroller();

      Provider.of<SocketViewmodel>(
        context,
        listen: false,
      ).ConnectRoomScocket(
        context,
        Roomid,
      );

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeHasRoomstate(true);

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeIsRoomstate(true);

      if (Currentroom?.RoomAds != null) {
        Currentroom?.chatroom?.add(
          Chatroom(
            kind: 1,
            user: Currentroom?.admin,
            id: 0,
            content: Currentroom?.RoomAds,
            userId: Currentroom?.admin?.id.toString(),
            updatedAt: Currentroom?.updatedAt,
            roomId: Currentroom?.id.toString(),
            createdAt: Currentroom?.createdAt,
          ),
        );
      }

      Provider.of<AgoraViewmodel>(
        context,
        listen: false,
      ).KickedFromChair = false;

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).DeleteGlopal();

      HideEnterWidget();

      final int? userId = int.tryParse(
        user.userinfo?.id.toString() ?? '',
      );

      if (userId != null) {
        Provider.of<AgoraViewmodel>(
          roomcontext,
          listen: false,
        ).unmuteusermic(userId);
      }

      // SvgViewmodel is owned by Provider; do not dispose it here.
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) return;

          try {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              return;
            }

            Provider.of<SvgViewmodel>(
              context,
              listen: false,
            ).getcontroller(
              enterImage: user.userinfo?.image,
              entername: user.userinfo?.name,
              svga: entry,
            );
          } catch (error) {
            debugPrint('JOIN ROOM 4: Entry animation failed: $error');
          }
        },
      );

      Navigator.pushNamed(
        context,
        AppConstants.Room_Screan,
      );
    });

    notifyListeners();
  }

  // ------------------------------------------------------------
  // JOIN ROOM 2
  // ------------------------------------------------------------

  Future<void> JoinRoom2({
    required dynamic context,
    required dynamic Roomid,
  }) async {
    Provider.of<SocketViewmodel>(
      context,
      listen: false,
    ).DisConnect(
      id: Currentroom?.id,
    );

    final LoginViewmodel user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    final AgoraViewmodel agora = Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    await agora.EndAgora();

    showSpinner3();

    await Roomapi()
        .joinRooms(
          context: context,
          Roomid: Roomid,
        )
        .then((value) async {
      if (value.state == 1) {
        Rooms.removeWhere(
          (element) => element.id == Roomid,
        );

        NewRooms.removeWhere(
          (element) => element.id == Roomid,
        );

        hideSpinner3();

        Dialogs().showtoast(
          getLang(
            context: NavigationService
                .navigatorKey
                .currentContext,
            key: 'Room_Disbanded',
          ),
        );

        return;
      }

      if (value.id == null) {
        debugPrint('JOIN ROOM 2: Room ID is null');
        hideSpinner3();
        return;
      }

      Provider.of<SocketViewmodel>(
        context,
        listen: false,
      ).DisConnect(
        id: Currentroom?.id,
      );

      JoinChairs = false;

      final String agoraChannel =
          value.id?.toString().trim() ?? '';
      final String agoraToken =
          value.Token?.toString().trim() ?? '';

      final bool isAdmin =
          value.admin?.id.toString() == UserId.toString();

      if (agoraChannel.isEmpty) {
        debugPrint('JOIN ROOM 2: Agora channel is empty');
        hideSpinner3();
        return;
      }

      if (agoraToken.isEmpty) {
        debugPrint('JOIN ROOM 2: Agora token is empty');
        hideSpinner3();
        return;
      }

      if (isAdmin) {
        JoinChairs = true;

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Broadcaster,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      } else {
        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Audience,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      }

      Currentroom = value;

      final roomVM = Provider.of<RoomViewmodel>(
        roomcontext,
        listen: false,
      );

      if (checkadmin(context: context)) {
        _resetAdminChair(roomVM.Currentroom);
      }

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).hidpanner();

      Provider.of<SvgViewmodel>(
        context,
        listen: false,
      ).animationController?.clear();

      Provider.of<RoomViewmodel>(
        context,
        listen: false,
      ).initscrollcontroller();

      Currentroom?.userNumber =
          (Currentroom?.userNumber ?? 0) + 1;

      Provider.of<SocketViewmodel>(
        context,
        listen: false,
      ).ConnectRoomScocket(
        context,
        Currentroom?.id,
      );

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeHasRoomstate(true);

      if (Currentroom?.RoomAds != null) {
        Currentroom?.chatroom?.add(
          Chatroom(
            user: Currentroom?.admin,
            id: 0,
            content: Currentroom?.RoomAds,
            userId: Currentroom?.admin?.id.toString(),
            updatedAt: Currentroom?.updatedAt,
            roomId: Currentroom?.id?.toString(),
            createdAt: Currentroom?.createdAt,
          ),
        );
      }

      Provider.of<AgoraViewmodel>(
        context,
        listen: false,
      ).KickedFromChair = false;

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeIsRoomstate(true);

      HideEnterWidget();

      // SvgViewmodel is owned by Provider; do not dispose it here.
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) return;

          try {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              return;
            }

            Provider.of<SvgViewmodel>(
              context,
              listen: false,
            ).getcontroller(
              enterImage: user.userinfo?.image,
              entername: user.userinfo?.name,
              svga: entry,
            );
          } catch (error) {
            debugPrint('JOIN ROOM 2: Entry animation failed: $error');
          }
        },
      );

      hideSpinner3();
    });

    notifyListeners();
  }

  // ------------------------------------------------------------
  // JOIN ROOM 5
  // ------------------------------------------------------------

  Future<void> JoinRoom5({
    required dynamic context,
    required dynamic Roomid,
  }) async {
    Provider.of<SocketViewmodel>(
      context,
      listen: false,
    ).DisConnect(
      id: Currentroom?.id,
    );

    Currentroom?.id = 0;
    Currentroom = null;

    final AgoraViewmodel agora = Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    await agora.EndAgora();

    final LoginViewmodel user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    showSpinner3();

    await Roomapi()
        .joinRooms(
          context: context,
          Roomid: Roomid,
        )
        .then((value) async {
      if (value.state == 1) {
        Rooms.removeWhere(
          (element) => element.id == Roomid,
        );

        NewRooms.removeWhere(
          (element) => element.id == Roomid,
        );

        hideSpinner3();

        Dialogs().showtoast(
          getLang(
            context: NavigationService
                .navigatorKey
                .currentContext,
            key: 'Room_Disbanded',
          ),
        );

        return;
      }

      if (value.id == null) {
        debugPrint('JOIN ROOM 5: Room ID is null');
        hideSpinner3();
        return;
      }

      JoinChairs = false;

      final String agoraChannel =
          value.id?.toString().trim() ?? '';
      final String agoraToken =
          value.Token?.toString().trim() ?? '';

      final bool isAdmin =
          value.admin?.id.toString() == UserId.toString();

      if (agoraChannel.isEmpty) {
        debugPrint('JOIN ROOM 5: Agora channel is empty');
        hideSpinner3();
        return;
      }

      if (agoraToken.isEmpty) {
        debugPrint('JOIN ROOM 5: Agora token is empty');
        hideSpinner3();
        return;
      }

      if (isAdmin) {
        JoinChairs = true;

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Broadcaster,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      } else {
        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Audience,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      }

      Currentroom = value;

      final roomVM = Provider.of<RoomViewmodel>(
        roomcontext,
        listen: false,
      );

      if (checkadmin(context: context)) {
        _resetAdminChair(roomVM.Currentroom);
      }

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).hidpanner();

      Provider.of<SvgViewmodel>(
        context,
        listen: false,
      ).animationController?.clear();

      Provider.of<RoomViewmodel>(
        context,
        listen: false,
      ).initscrollcontroller();

      Provider.of<SocketViewmodel>(
        context,
        listen: false,
      ).ConnectRoomScocket(
        context,
        Roomid,
      );

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeHasRoomstate(true);

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeIsRoomstate(true);

      if (Currentroom?.RoomAds != null) {
        Currentroom?.chatroom?.add(
          Chatroom(
            kind: 1,
            user: Currentroom?.admin,
            id: 0,
            content: Currentroom?.RoomAds,
            userId: Currentroom?.admin?.id.toString(),
            updatedAt: Currentroom?.updatedAt,
            roomId: Currentroom?.id?.toString(),
            createdAt: Currentroom?.createdAt,
          ),
        );
      }

      Provider.of<AgoraViewmodel>(
        context,
        listen: false,
      ).KickedFromChair = false;

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).DeleteGlopal();

      HideEnterWidget();

      final int? userId = int.tryParse(
        user.userinfo?.id.toString() ?? '',
      );

      if (userId != null) {
        Provider.of<AgoraViewmodel>(
          roomcontext,
          listen: false,
        ).unmuteusermic(userId);
      }

      // SvgViewmodel is owned by Provider; do not dispose it here.
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) return;

          try {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              return;
            }

            Provider.of<SvgViewmodel>(
              context,
              listen: false,
            ).getcontroller(
              enterImage: user.userinfo?.image,
              entername: user.userinfo?.name,
              svga: entry,
            );
          } catch (error) {
            debugPrint('JOIN ROOM 5: Entry animation failed: $error');
          }
        },
      );

      Navigator.pushNamed(
        context,
        AppConstants.Room_Screan,
      );

      hideSpinner3();
    });

    notifyListeners();
  }

  // ------------------------------------------------------------
  // CHECK ADMIN
  // ------------------------------------------------------------

  bool checkadmin({
    required BuildContext context,
  }) {
    final LoginViewmodel user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    return Currentroom?.adminId.toString() ==
        user.userinfo?.id.toString();
  }
}
