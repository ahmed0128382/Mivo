import 'dart:async';
import 'dart:io';

import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
import 'package:ahlachat/models/Weeklystarmodel.dart';
import 'package:ahlachat/models/guessGameModel.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/notification.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/SearchScrean/widgets/SearchRoom.dart';
import 'package:ahlachat/viewmodels/Music_Viewmodel/MusicViewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/Kickedusers.dart';
import 'package:ahlachat/models/RoomKarismaModel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/ShopModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_join_mixin.dart';
import 'room_ui_mixin.dart';

mixin RoomAdminMixin on RoomStateMixin, RoomLoadingMixin, RoomJoinMixin, RoomUiMixin {
  GetRoomSupervisor() async {
    ShowGlopalLoading();

    await Roomapi()
        .GetRoomSupercisors(
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        Currentroom?.supervisor = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  AddsupervisorsRoom({
    context,
    userid,
  }) async {
    await Roomapi()
        .Addsupervisors(
      context: context,
      Roomid: Currentroom?.id,
      userid: userid,
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

        hideSpinner31();
      },
    );

    notifyListeners();
  }

  FollowRoom({
    context,
  }) async {
    await Roomapi()
        .FollowRoom(
      context: context,
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          Currentroom?.FollowRoom = 1;
          notifyListeners();
        } else {
          Currentroom?.FollowRoom = 0;
          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  RemoveFollowRoom({
    context,
  }) async {
    await Roomapi()
        .RemoveFollowRoom(
      context: context,
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          Currentroom?.FollowRoom = 0;
          notifyListeners();
        } else {
          Currentroom?.FollowRoom = 1;
          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  InviteToRoom({
    user,
    Roominfo,
    context,
  }) {
    RoomPlayViewModel playroom =
        Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    );

    RoomViewmodel Room =
        Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    SvgViewmodel svga =
        Provider.of<SvgViewmodel>(
      context,
      listen: false,
    );

    if (Roominfo['id'].toString() ==
            Currentroom?.id.toString() &&
        playroom.HasRoom) {
      Dialogs().showdialog5(
        context: context,
        content:
            '${user['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "INVITE_SET")}',
      );
    } else {
      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "inviteyou")} ${Roominfo['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "Room_now")}  ',
        onTap: () {
          Navigator.pop(context);

          if (playroom.HasRoom) {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            Room.JoinRoom2(
              Roomid: Roominfo['id'],
              context: context,
            );
          } else {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            Room.JoinRoom5(
              Roomid: Roominfo['id'],
              context: context,
            );
          }
        },
        tittle: '',
        buttontext: getLang(
          context: context,
          key: "Yes",
        ),
      );
    }

    notifyListeners();
  }

  InviteToChair({
    user,
    Roominfo,
    Chair_id,
    context,
  }) {
    RoomPlayViewModel playroom =
        Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    );

    RoomViewmodel Room =
        Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    SvgViewmodel svga =
        Provider.of<SvgViewmodel>(
      context,
      listen: false,
    );

    if (Roominfo['id'].toString() ==
            Currentroom?.id.toString() &&
        playroom.HasRoom) {
      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "INVITE_SET")}',
        onTap: () {
          Navigator.pop(context);

          if (JoinChairs) {
            Dialogs().showtoast(
              getLang(
                context:
                    NavigationService
                        .navigatorKey
                        .currentContext,
                key: "AlreadySet",
              ),
            );
          } else {
            if (Currentroom
                    ?.chairs?[
                        int.parse(Chair_id) - 1]
                    .user ==
                null) {
              if (playroom.IsRoom) {
                Room.JoinChair(
                  index: int.parse(Chair_id) - 1,
                  context: context,
                  chairid: Chair_id,
                );
              } else {
                svga.animationController?.clear();

                Provider.of<RoomViewmodel>(
                  context,
                  listen: false,
                ).initscrollcontroller();

                Provider.of<GiftsViewModel>(
                  context,
                  listen: false,
                ).DeleteGlopal();

                Navigator.pushNamed(
                  context,
                  AppConstants.Room_Screan,
                );

                Future.delayed(
                  Duration(seconds: 1),
                  () => Room.JoinChair(
                    index:
                        int.parse(Chair_id) - 1,
                    context: context,
                    chairid: Chair_id,
                  ),
                );
              }
            } else {
              Dialogs().showtoast(
                getLang(
                  context:
                      NavigationService
                          .navigatorKey
                          .currentContext,
                  key: "Another_Set",
                ),
              );
            }
          }
        },
        tittle: '',
        buttontext: getLang(
          context: context,
          key: "Yes",
        ),
      );
    } else {
      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "inviteyou")} ${Roominfo['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "Room_now")} ',
        onTap: () {
          Navigator.pop(context);

          if (playroom.HasRoom) {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            Room.JoinRoom2(
              Roomid: Roominfo['id'],
              context: context,
            );
          } else {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            Room.JoinRoom5(
              Roomid: Roominfo['id'],
              context: context,
            );
          }
        },
        tittle: '',
        buttontext: getLang(
          context: context,
          key: "Yes",
        ),
      );
    }

    notifyListeners();
  }

  RemovesupervisorsRoom({
    context,
    userid,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .Removesupervisors(
      context: context,
      Roomid: Currentroom?.id,
      userid: userid,
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

          Currentroom?.supervisor?.removeWhere(
            (element) => element.user?.id == userid,
          );

          notifyListeners();
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

        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  Addsupervisors({id}) {
    Currentroom?.supervisorsId?.add(id);
    notifyListeners();
  }

  Removesupervisors({id}) {
    Currentroom?.supervisorsId
        ?.removeWhere(
          (element) => element == id,
        );

    notifyListeners();
  }

  updateThroneChair({
    State,
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .UpdateThroneChair(
      context: context,
      room_id: Currentroom?.id,
      State: State,
    )
        .then(
      (value) {
        if (value != null) {
          Dialogs().showtoast(
            'updated',
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

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  unkickuserRoom({
    context,
    kickid,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .UnkickeuserRoom(
      context: context,
      kickid: kickid,
    )
        .then(
      (value) {
        if (value != false) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          BlockeduserRooms.removeWhere(
            (element) => element.id == kickid,
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

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  SentInviteChairRoom({
    context,
    user_id,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .SendInviteChairRoom(
      context: context,
      roomid: Currentroom?.id,
      userid: user_id,
    )
        .then(
      (value) {
        if (value != false) {
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

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  SetRoomPassword({
    context,
    PasswordRoom,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .SetRoomPssword(
      context: context,
      roomid: Currentroom?.id,
      password: PasswordRoom.text,
    )
        .then(
      (value) {
        if (value != null) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          PasswordRoom.clear();
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

          PasswordRoom.clear();
        }

        Navigator.pop(context);
        notifyListeners();
      },
    );
  }

  RemoveRoomPassword({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .RemoveRoomPssword(
      context: context,
      roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value != null) {
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

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  updatemute({
    context,
    state,
    user_id,
  }) async {
    await Roomapi()
        .Updatemute(
      context: context,
      room_id: Currentroom?.id,
      state: state,
      user_id: user_id,
    )
        .then(
      (value) {
        if (value == true) {
          if (state == 1) {
            Provider.of<AgoraViewmodel>(
              roomcontext,
              listen: false,
            ).muteusermic(
              int.parse(
                user_id.toString(),
              ),
            );
          } else {
            Provider.of<AgoraViewmodel>(
              roomcontext,
              listen: false,
            ).unmuteusermic(
              int.parse(
                user_id.toString(),
              ),
            );
          }
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
  }

  GetUserJoin({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .Roomsjoinuser(
      context: context,
      room_id: Currentroom?.id,
    )
        .then(
      (value) {
        if (value.isNotEmpty) {
          joinuserRooms = value;
          notifyListeners();
        }

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  updateCurrentRoom({
    required RoomModel NewRoom,
  }) {
    Currentroom?.name = NewRoom.name;
    Currentroom?.animateimage =
        NewRoom.animateimage;
    Currentroom?.locked = NewRoom.locked;
    Currentroom?.password = NewRoom.password;
    Currentroom?.image = NewRoom.image;
    Currentroom?.Category = NewRoom.Category;
    Currentroom?.nothostedimage =
        NewRoom.nothostedimage;
    Currentroom?.RoomAds = NewRoom.RoomAds;

    Rooms.forEach(
      (element) {
        if (element.id == NewRoom.id) {
          element.name = NewRoom.name;
          element.image = NewRoom.image;
          element.password = NewRoom.password;
          element.RoomAds = NewRoom.RoomAds;
          element.Category = NewRoom.Category;
        }
      },
    );

    notifyListeners();
  }

  updateCurrentRoomPassword({
    required var Password,
    required String Id,
  }) {
    Currentroom?.password = Password;

    Rooms.forEach(
      (element) {
        if (element.id.toString() ==
            Id.toString()) {
          element.password = Password;
          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  KickJoinadminuser({
    context,
    user_id,
  }) async {
    await Roomapi()
        .KickJoinadminuser(
      context: context,
      user_id: user_id,
      room_id: Currentroom?.id,
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
      },
    );
  }

  InviteUserToSET({
    context,
    user_id,
  }) async {
    await Roomapi()
        .InviteUserToSET(
      context: context,
      user_id: user_id,
      room_id: Currentroom?.id,
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
      },
    );
  }

  GetKickeduser({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .KickedUserRooms(
      context: context,
      roomid: Currentroom?.id,
    )
        .then(
      (value) {
        BlockeduserRooms = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

}
