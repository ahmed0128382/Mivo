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
JoinRoom4({
  context,
  Roomid,
}) async {
  Provider.of<SocketViewmodel>(
    context,
    listen: false,
  ).DisConnect(
    id: Currentroom?.id,
  );

  Currentroom?.id = 0;
  Currentroom = null;

  final AgoraViewmodel agora =
      Provider.of<AgoraViewmodel>(
    context,
    listen: false,
  );

  final LoginViewmodel user =
      Provider.of<LoginViewmodel>(
    context,
    listen: false,
  );

  await agora.EndAgora();

  await Roomapi()
      .joinRooms(
    context: context,
    Roomid: Roomid,
  )
      .then(
    (value) async {
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
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Room_Disbanded",
          ),
        );

        return;
      }

      if (value.id == null) {
        print(
          'JOIN ROOM 4 ERROR: value.id is null',
        );
        return;
      }

      JoinChairs = false;

      final String agoraChannel =
          value.id?.toString().trim() ?? '';

      final String agoraToken =
          value.Token?.toString().trim() ?? '';

      final bool isAdmin =
          value.admin?.id.toString() ==
              UserId.toString();

      print(
        '========== JOIN ROOM 4 AGORA ==========',
      );
      print(
        'DB ROOM ID: ${value.id}',
      );
      print(
        'PUBLIC ROOM ID / AGORA CHANNEL: "$agoraChannel"',
      );
      print(
        'TOKEN PRESENT: ${agoraToken.isNotEmpty}',
      );
      print(
        'TOKEN LENGTH: ${agoraToken.length}',
      );
      print(
        'USER ID: $UserId',
      );
      print(
        'IS ADMIN: $isAdmin',
      );
      print(
        '========================================',
      );

      if (agoraChannel.isEmpty) {
        print(
          'JOIN ROOM 4 AGORA ERROR: RoomID is empty',
        );
        return;
      }

      if (agoraToken.isEmpty) {
        print(
          'JOIN ROOM 4 AGORA ERROR: Token is empty',
        );
        return;
      }

      if (isAdmin) {
        JoinChairs = true;

        print(
          'JOIN ROOM 4: User is ADMIN',
        );

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Broadcaster,
          Token: agoraToken,
          channelName: agoraChannel,
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      } else {
        print(
          'JOIN ROOM 4: User is NOT ADMIN',
        );

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Audience,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      }

      // Set the room BEFORE scheduling the delayed entry animation.
      Currentroom = value;

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

      if (checkadmin(context: context)) {
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
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

      /*
       * IMPORTANT:
       * We do NOT call SvgViewmodel.dispose().
       *
       * SvgViewmodel is owned by Provider.
       * Its dispose() must only happen when Provider removes
       * the ViewModel from the widget tree.
       *
       * getcontroller() itself must safely handle its lifecycle.
       */
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) {
            return;
          }

          try {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              print(
                'JOIN ROOM 4 SVGA: No entry animation',
              );
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
          } catch (e, stackTrace) {
            print(
              'JOIN ROOM 4 DELAYED SVGA ERROR: $e',
            );
            print(stackTrace);
          }
        },
      );

      Navigator.pushNamed(
        context,
        AppConstants.Room_Screan,
      );
    },
  );

  notifyListeners();
}

JoinRoom2({
  context,
  Roomid,
}) async {
  Provider.of<SocketViewmodel>(
    context,
    listen: false,
  ).DisConnect(
    id: Currentroom?.id,
  );

  final LoginViewmodel user =
      Provider.of<LoginViewmodel>(
    context,
    listen: false,
  );

  print(
    'JoinRoom2JoinRoom2JoinRoom2JoinRoom2JoinRoom2JoinRoom2',
  );

  final AgoraViewmodel agora =
      Provider.of<AgoraViewmodel>(
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
      .then(
    (value) async {
      print(value.state);
      print(value.name);

      print(
        'Room Data is ====================================>',
      );

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
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Room_Disbanded",
          ),
        );

        return;
      }

      if (value.id == null) {
        print(
          'JOIN ROOM 2 ERROR: value.id is null',
        );
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
          value.admin?.id.toString() ==
              UserId.toString();

      print(
        '========== JOIN ROOM 2 AGORA ==========',
      );
      print(
        'DB ROOM ID: ${value.id}',
      );
      print(
        'PUBLIC ROOM ID / AGORA CHANNEL: "$agoraChannel"',
      );
      print(
        'TOKEN PRESENT: ${agoraToken.isNotEmpty}',
      );
      print(
        'TOKEN LENGTH: ${agoraToken.length}',
      );
      print(
        'USER ID: $UserId',
      );
      print(
        'IS ADMIN: $isAdmin',
      );
      print(
        '========================================',
      );

      if (agoraChannel.isEmpty) {
        print(
          'JOIN ROOM 2 AGORA ERROR: RoomID is empty',
        );
        hideSpinner3();
        return;
      }

      if (agoraToken.isEmpty) {
        print(
          'JOIN ROOM 2 AGORA ERROR: Token is empty',
        );
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

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
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

      if (checkadmin(context: context)) {
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      }

      HideEnterWidget();

      /*
       * IMPORTANT:
       * No SvgViewmodel.dispose().
       *
       * The ViewModel is still owned by Provider.
       */
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) {
            return;
          }

          try {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              print(
                'JOIN ROOM 2 SVGA: No entry animation',
              );
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
          } catch (e, stackTrace) {
            print(
              'JOIN ROOM 2 DELAYED SVGA ERROR: $e',
            );
            print(stackTrace);
          }
        },
      );

      hideSpinner3();
    },
  );

  notifyListeners();
}

JoinRoom5({
  context,
  Roomid,
}) async {
  Provider.of<SocketViewmodel>(
    context,
    listen: false,
  ).DisConnect(
    id: Currentroom?.id,
  );

  Currentroom?.id = 0;
  Currentroom = null;

  print(
    'Test ============================> 1',
  );

  final AgoraViewmodel agora =
      Provider.of<AgoraViewmodel>(
    context,
    listen: false,
  );

  await agora.EndAgora();

  final LoginViewmodel user =
      Provider.of<LoginViewmodel>(
    context,
    listen: false,
  );

  showSpinner3();

  print(
    'Test ============================> 3',
  );

  await Roomapi()
      .joinRooms(
    context: context,
    Roomid: Roomid,
  )
      .then(
    (value) async {
      if (value.state == 1) {
        print(
          'Test ============================> 4',
        );

        Rooms.removeWhere(
          (element) => element.id == Roomid,
        );

        NewRooms.removeWhere(
          (element) => element.id == Roomid,
        );

        hideSpinner3();

        Dialogs().showtoast(
          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Room_Disbanded",
          ),
        );

        return;
      }

      if (value.id == null) {
        print(
          'JOIN ROOM 5 ERROR: value.id is null',
        );
        hideSpinner3();
        return;
      }

      JoinChairs = false;

      print(
        'Test ============================> 6',
      );

      final String agoraChannel =
          value.id?.toString().trim() ?? '';

      final String agoraToken =
          value.Token?.toString().trim() ?? '';

      final bool isAdmin =
          value.admin?.id.toString() ==
              UserId.toString();

      print(
        '========== JOIN ROOM 5 AGORA ==========',
      );
      print(
        'DB ROOM ID: ${value.id}',
      );
      print(
        'PUBLIC ROOM ID / AGORA CHANNEL: "$agoraChannel"',
      );
      print(
        'TOKEN PRESENT: ${agoraToken.isNotEmpty}',
      );
      print(
        'TOKEN LENGTH: ${agoraToken.length}',
      );
      print(
        'USER ID: $UserId',
      );
      print(
        'IS ADMIN: $isAdmin',
      );
      print(
        '========================================',
      );

      if (agoraChannel.isEmpty) {
        print(
          'JOIN ROOM 5 AGORA ERROR: RoomID is empty',
        );
        hideSpinner3();
        return;
      }

      if (agoraToken.isEmpty) {
        print(
          'JOIN ROOM 5 AGORA ERROR: Token is empty',
        );
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

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
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

      print(
        'Test ============================> 8',
      );

      Currentroom = value;

      print(
        'CURRENT ROOM DB ID: ${Currentroom?.id}',
      );

      print(
        'CURRENT ROOM PUBLIC ROOM ID: ${Currentroom?.RoomID}',
      );

      print(
        'Test ============================> 9',
      );

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

      print(
        'Number of users is '
        '${Currentroom?.userNumber}',
      );

      print(
        'Test ============================> 10',
      );

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
        print(
          'Test ============================> 11',
        );

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

      if (checkadmin(context: context)) {
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      }

      print(
        'Test ============================> 12',
      );

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

      /*
       * IMPORTANT:
       * Do NOT call SvgViewmodel.dispose().
       * Provider owns the SvgViewmodel lifecycle.
       */

      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) {
            return;
          }

          try {
            print(
              'Test ============================> 13',
            );

            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              print(
                'JOIN ROOM 5 SVGA: No entry animation',
              );
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
          } catch (e, stackTrace) {
            print(
              'JOIN ROOM 5 DELAYED SVGA ERROR: $e',
            );
            print(stackTrace);
          }
        },
      );

      Navigator.pushNamed(
        context,
        AppConstants.Room_Screan,
      );

      hideSpinner3();
    },
  );

  notifyListeners();
}

  checkadmin({
    context,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    if (Currentroom?.adminId.toString() ==
        user.userinfo?.id.toString()) {
      return true;
    } else {
      return false;
    }
  }

}
