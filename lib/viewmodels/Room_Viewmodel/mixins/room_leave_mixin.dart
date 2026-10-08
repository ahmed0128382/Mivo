import 'package:ahlachat/main.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';
import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_ui_mixin.dart';

mixin RoomLeaveMixin on RoomStateMixin, RoomLoadingMixin, RoomUiMixin {
  Leaveroom({
    context,
  }) async {
    LeaveLoading = true;

    Provider.of<SocketViewmodel>(
      context,
      listen: false,
    ).DisConnect(
      id: Currentroom?.id.toString(),
    );

    Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).disableAudioroomvoice();

    Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).stopAudioMexing(context);

    await Roomapi()
        .LeaveRoom(
      context: context,
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          List rrr = Rooms
              .where(
                (element) =>
                    element.id ==
                    Currentroom?.id,
              )
              .toList();

          if (rrr.isNotEmpty) {
            rrr.first.userNumber =
                (rrr.first.userNumber ?? 0) -
                    1;
          }

          Dialogs().showtoast(
            getLang(
              context: roomcontext,
              key: "Leaved_Room",
            ),
          );

          Currentroom = null;
          removecurrentroom();
          LeaveLoading = false;
        }
      },
    );

    notifyListeners();
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
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        notifyListeners();
      },
    );

    notifyListeners();
  }

  RemoveRoomFromlist({
    RoomId,
  }) {
    Rooms.removeWhere(
      (element) => element.id == RoomId,
    );

    NewRooms.removeWhere(
      (element) => element.id == RoomId,
    );

    notifyListeners();
  }

  DisbandRoom({
    context,
  }) async {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    await Roomapi()
        .DisbandRoom(
      context: context,
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          Agora.EndAgora();

          Rooms.removeWhere(
            (element) =>
                element.id ==
                Currentroom?.id,
          );

          NewRooms.removeWhere(
            (element) =>
                element.id ==
                Currentroom?.id,
          );

          user.userinfo?.currentroom =
              null;
        }

        notifyListeners();
      },
    );

    notifyListeners();
  }

  AddusertoRoom({
    usermodel? join,
    joinRoom? JoinRoom,
    ctx,
    index,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      ctx,
      listen: false,
    );

    if (join?.id !=
        user.userinfo?.id) {
      Currentroom?.userNumber =
          (Currentroom?.userNumber ?? 0) +
              1;

      Currentroom?.joinRooms
          ?.insert(
            0,
            JoinRoom!,
          );

      print(index);
    } else {
      print(
        'You Join This Room',
      );
    }

    notifyListeners();
  }

  RemoveuserfromRoom({
    String? id,
  }) {
    ComboListuser.removeWhere(
      (element) =>
          element.toString() ==
          id.toString(),
    );

    Rooms.where(
      (element) =>
          element.id.toString() ==
          id.toString(),
    );

    if (Rooms.isNotEmpty) {
      Rooms.first.userNumber =
          Rooms.first.userNumber! - 1;
    }

    Currentroom?.chairs?.forEach(
      (element) {
        if (element.userId == id) {
          Currentroom
              ?.chairs?[
                  int.parse(
                        element.chairId
                                ?.toString() ??
                            '',
                      ) -
                      1]
              .userId = null;

          Currentroom
              ?.chairs?[
                  int.parse(
                        element.chairId
                                ?.toString() ??
                            '',
                      ) -
                      1]
              .user = null;
        }
      },
    );

    Currentroom?.userNumber =
        (Currentroom?.userNumber ?? 0) -
            1;

    Currentroom?.joinRooms
        ?.removeWhere(
      (element) =>
          element.userId.toString() ==
          id.toString(),
    );

    ChairsRoom.removeWhere(
      (element) =>
          element.userId.toString() ==
          id.toString(),
    );

    notifyListeners();
  }

}
