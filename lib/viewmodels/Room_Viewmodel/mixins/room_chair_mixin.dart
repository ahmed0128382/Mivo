import 'package:ahlachat/main.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';
import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';

mixin RoomChairMixin on RoomStateMixin, RoomLoadingMixin {
  ChangeChairLock({
    int? State,
    String? chairId,
  }) {
    Currentroom?.chairs?[
            int.parse(
                  chairId ?? '0',
                ) -
                1]
        .Lock = State;

    notifyListeners();
  }

  NulledKaresmaChair({
    String? chairId,
  }) {
    Currentroom?.chairs?[
            int.parse(
                  chairId ?? '0',
                ) -
                1]
        .Karisma = 0;

    notifyListeners();
  }

  addKaresmaChair({
    String? chairId,
  }) {
    Currentroom?.chairs?[
            int.parse(
                  chairId ?? '0',
                ) -
                1]
        .Karisma = 100;

    notifyListeners();
  }

  updatekaresma({
    required int Amount,
    context,
  }) {
    Currentroom?.Karisma =
        (Currentroom?.Karisma ?? 0) +
            Amount;

    Provider.of<SvgViewmodel>(
      context,
      listen: false,
    ).getcontroller4(
      Svga:
          'assets/image/16207300489766.svga',
    );

    print(Amount);
    notifyListeners();
  }

  AddKaresmaChair({
    required List userids,
    int? Amount,
  }) {
    userids.forEach(
      (elements) {
        Currentroom?.chairs?.forEach(
          (element) {
            if (element.userId.toString() ==
                elements.toString()) {
              element.Karisma =
                  (element.Karisma ?? 0) +
                      Amount!;
            }
          },
        );

        print(
          Currentroom?.chairs?.where(
            (element) =>
                element.userId.toString() ==
                element.toString(),
          ),
        );

        notifyListeners();
      },
    );
  }

  Changemicestateadmin({
    userId,
    state,
    context,
  }) async {
    Currentroom?.chairs?.forEach(
      (element) async {
        if (element.userId == userId) {
          element.mute = state;
        }
      },
    );

    notifyListeners();
  }

  bool checkmute() {
    var muted = false;

    Currentroom?.chairs?.forEach(
      (element) {
        if (element.userId == UserId &&
            element.mute == 0) {
          muted = false;
        } else if (element.userId == UserId &&
            element.mute == 1) {
          muted = true;
        }
      },
    );

    notifyListeners();

    return muted;
  }

  UpdateThronechair({
    int? value,
  }) {
    Currentroom?.SecondKing = value;
    notifyListeners();
  }

  showLoding() {
    JoinChairLoding = true;
  }

  hideLoding() {
    JoinChairLoding = false;
  }

  JoinChair({
    context,
    index,
    chairid,
  }) async {
    showLoding();

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

    Currentroom?.chairs?[index].userId =
        user.userinfo?.id.toString();

    JoinChairs = true;

    await Roomapi()
        .joinChair(
      context: context,
      index: index,
      room_id: Currentroom?.id,
      chair_id: chairid,
    )
        .then(
      (value) {
        hideLoding();

        print(
          'Join Chairsssssssssssssssssss',
        );

        if (value == true) {
          Agora.updateKickedFromChair(
            value: false,
          );

          Chairid = chairid;
          Chairidex = index;

          if (Currentroom
                  ?.chairs?[index]
                  .mute ==
              0) {
            Agora.UnMute();
          } else {
            Agora.Mute();
          }
        } else {
          Currentroom
              ?.chairs?[index]
              .userId = null;

          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Another_Set",
          );

          JoinChairs = false;
          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  ChangeChair({
    context,
    Index,
    Newchairid,
  }) async {
    showSpinner47();

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

    Currentroom
        ?.chairs?[Chairidex]
        .userId = null;

    Currentroom
        ?.chairs?[Chairidex]
        .user = null;

    Currentroom
        ?.chairs?[Index]
        .userId = user.userinfo?.id
            .toString();

    Currentroom
        ?.chairs?[Index]
        .user = user.userinfo;

    notifyListeners();

    await Roomapi()
        .ChangeChair(
      context: context,
      room_id: Currentroom?.id,
      CurrentChairid:
          Currentroom
              ?.chairs?[Chairidex]
              .id,
      NewCharid:
          Currentroom
              ?.chairs?[Index]
              .id,
    )
        .then(
      (value) {
        if (value == true) {
          if (Currentroom
                  ?.chairs?[Index]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Chairidex = Index;

          notifyListeners();
        } else {
          Currentroom
              ?.chairs?[Index]
              .userId = null;

          Currentroom
              ?.chairs?[Index]
              .user = null;

          Currentroom
              ?.chairs?[Chairidex]
              .userId =
              user.userinfo?.id.toString();

          Currentroom
              ?.chairs?[Chairidex]
              .user = user.userinfo;

          if (Currentroom
                  ?.chairs?[Chairidex]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Another_Set",
          );

          notifyListeners();
        }

        hideSpinner47();
      },
    );

    notifyListeners();
  }

  ChangeAdminsChair({
    context,
    Index,
    Newchairid,
  }) async {
    showSpinner47();

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

    Currentroom
        ?.chairs?[8]
        .adminleaved = 1;

    if (Chairidex != 0) {
      Currentroom
          ?.chairs?[Chairidex]
          .userId = null;

      Currentroom
          ?.chairs?[Chairidex]
          .user = null;
    }

    Currentroom
        ?.chairs?[Index]
        .userId = user.userinfo
        ?.id
        .toString();

    Currentroom
        ?.chairs?[Index]
        .user = user.userinfo;

    notifyListeners();

    await Roomapi()
        .AdminChangeChair(
      context: context,
      room_id: Currentroom?.id,
      CurrentChairid:
          Currentroom
              ?.chairs?[Chairidex]
              .id,
      NewCharid:
          Currentroom
              ?.chairs?[Index]
              .id,
    )
        .then(
      (value) {
        if (value == true) {
          if (Currentroom
                  ?.chairs?[Index]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Chairidex = Index;

          notifyListeners();
        } else {
          Currentroom
              ?.chairs?[8]
              .adminleaved = 0;

          if (Currentroom
                  ?.chairs?[8]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Currentroom
              ?.chairs?[Index]
              .userId = null;

          Currentroom
              ?.chairs?[Index]
              .user = null;

          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Another_Set",
          );

          notifyListeners();
        }

        hideSpinner47();
      },
    );

    notifyListeners();
  }

  ReturnAdminsChair({
    context,
    Index,
    Newchairid,
  }) async {
    showSpinner47();

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

    Currentroom
        ?.chairs?[8]
        .adminleaved = 0;

    if (Chairidex != 0) {
      Currentroom
          ?.chairs?[Chairidex]
          .userId = null;

      Currentroom
          ?.chairs?[Chairidex]
          .user = null;
    }

    Currentroom
        ?.chairs?[Index]
        .userId = user.userinfo
        ?.id
        .toString();

    Currentroom
        ?.chairs?[Index]
        .user = user.userinfo;

    notifyListeners();

    await Roomapi()
        .ReturnAdminChair(
      context: context,
      room_id: Currentroom?.id,
      CurrentChairid:
          Currentroom
              ?.chairs?[Chairidex]
              .id,
      NewCharid:
          Currentroom
              ?.chairs?[Index]
              .id,
    )
        .then(
      (value) {
        if (value == true) {
          if (Currentroom
                  ?.chairs?[Index]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Chairidex = Index;

          notifyListeners();
        } else {
          Currentroom
              ?.chairs?[8]
              .adminleaved = 1;

          if (Currentroom
                  ?.chairs?[8]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Currentroom
              ?.chairs?[Index]
              .userId = null;

          Currentroom
              ?.chairs?[Index]
              .user = null;

          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Another_Set",
          );

          notifyListeners();
        }

        hideSpinner47();
      },
    );

    notifyListeners();
  }

  LeaveChair({
    context,
    chairid,
    index,
  }) async {
    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    Currentroom
        ?.chairs?[index]
        .userId = null;

    Currentroom
        ?.chairs?[index]
        .user = null;

    await Roomapi()
        .LeaveChair(
      context: context,
      Roomid: Currentroom?.id,
      chairid: chairid,
    )
        .then(
      (value) {
        if (value == true) {
          Agora.SetasAudience();

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

        hideSpinner3();
      },
    );

    notifyListeners();
  }

  LeaveuserChair({
    context,
  }) async {
    showloading8 = false;

    Currentroom
        ?.chairs?[ChairIndes]
        .userId = null;

    Currentroom
        ?.chairs?[ChairIndes]
        .user = null;

    await Roomapi()
        .LeaveuserChair(
      context: context,
      user_id: useridchair,
      Roomid: Currentroom?.id,
      chairid: Chairids,
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

        hideSpinner3();
      },
    );

    notifyListeners();
  }

  AddusertoChair({
    Chairs? data,
    ctx,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      ctx,
      listen: false,
    );

    if (data?.userId !=
        user.userinfo?.id) {
      print(data?.user);
      print(data?.chairId);
      print(data?.roomId);

      Currentroom?.chairs?[
              int.parse(
                    data?.chairId
                            ?.toString() ??
                        '',
                  ) -
                  1] =
          data!;
    } else {
      print(
        'You take This Chair',
      );
    }

    notifyListeners();
  }

  LockChair({
    int? state,
    int? chairId,
  }) {
    if (state != null) {
      Currentroom
          ?.chairs?[chairId ?? 0 - 1]
          .Lock = state;
    } else {
      print(
        'You take This Chair',
      );
    }

    notifyListeners();
  }

  ChangeRoomChair({
    usermodel? user,
    String? CurrentChair,
    String? newChair,
  }) {
    LoginViewmodel userinfo =
        Provider.of<LoginViewmodel>(
      roomcontext,
      listen: false,
    );

    RoomViewmodel Room =
        Provider.of<RoomViewmodel>(
      roomcontext,
      listen: false,
    );

    if (user?.id ==
        Room.Currentroom?.adminId) {
      Room.Currentroom
          ?.chairs?[8]
          .adminleaved = 1;

      notifyListeners();
    }

    List<Chairs>? item =
        Currentroom?.chairs
            ?.where(
              (element) =>
                  element.user?.id ==
                  user?.id,
            )
            .toList();

    if (item!.isNotEmpty) {
      item.first.userId = null;
      item.first.Karisma = 0;
      item.first.user = null;
    }

    Currentroom
        ?.chairs?[
            int.parse(
                  newChair ?? '',
                ) -
                1]
        .userId = user?.id.toString();

    Currentroom
        ?.chairs?[
            int.parse(
                  newChair ?? '',
                ) -
                1]
        .user = user;

    notifyListeners();
  }

  returntoAdminRoomChair({
    usermodel? user,
    String? CurrentChair,
    String? newChair,
  }) {
    LoginViewmodel userinfo =
        Provider.of<LoginViewmodel>(
      roomcontext,
      listen: false,
    );

    RoomViewmodel Room =
        Provider.of<RoomViewmodel>(
      roomcontext,
      listen: false,
    );

    if (user?.id ==
        Room.Currentroom?.adminId) {
      Room.Currentroom
          ?.chairs?[8]
          .adminleaved = 0;
    }

    List<Chairs>? item =
        Currentroom?.chairs
            ?.where(
              (element) =>
                  element.user?.id ==
                  user?.id,
            )
            .toList();

    if (item!.isNotEmpty) {
      item.first.userId = null;
      item.first.Karisma = 0;
      item.first.user = null;
    }

    Currentroom
        ?.chairs?[
            int.parse(
                  newChair ?? '',
                ) -
                1]
        .userId = user?.id.toString();

    Currentroom
        ?.chairs?[
            int.parse(
                  newChair ?? '',
                ) -
                1]
        .user = user;

    notifyListeners();
  }

  RemoveuserfromChair({
    String? id,
  }) {
    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      roomcontext,
      listen: false,
    );

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      roomcontext,
      listen: false,
    );

    if (id.toString() ==
        user.userinfo?.id.toString()) {
      Agora.keickedfromasAudience();
    }

    ChairsRoom.removeWhere(
      (element) =>
          element.userId.toString() ==
          id.toString(),
    );

    Currentroom?.chairs?.forEach(
      (element) {
        if (element.userId == id) {
          print(element.chairId);

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

    notifyListeners();
  }

  LockChairUpdate({
    int? state,
    Chairs? info,
  }) async {
    print('reunasdasdasd');

    await Roomapi()
        .LockChair(
      Chair_id: info?.id,
      Lock: state,
      Roominfo: Currentroom,
    )
        .then(
      (value) {
        if (value == true) {
          ChangeChairLock(
            chairId: info?.chairId,
            State: state,
          );
        }
      },
    );
  }

}
