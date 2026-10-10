
import 'dart:async';

import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:provider/provider.dart';

import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';
import 'room_join_mixin.dart';
import 'room_ui_mixin.dart';

/// Compact diagnostic logging for room administration and chair invitations.
///
/// Logs are debug-only, kept to one short line, and truncated to avoid
/// flooding Android Logcat. Do not pass tokens or complete API responses.
void _roomAdminChairLog(String stage, [Object? details]) {
  if (!kDebugMode) return;

  final message = details == null
      ? stage
      : '$stage | $details';

  final compactMessage = message
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  const maxLength = 240;
  final output = compactMessage.length > maxLength
      ? '${compactMessage.substring(0, maxLength - 3)}...'
      : compactMessage;

  debugPrint('[ROOM_ADMIN] $output');
}

mixin RoomAdminMixin
    on RoomStateMixin, RoomLoadingMixin, RoomJoinMixin, RoomUiMixin {
  getRoomSupervisor() async {
    ShowGlopalLoading();

    await Roomapi()
        .GetRoomSupercisors(
          Roomid: Currentroom?.id,
        )
        .then((value) {
          Currentroom?.supervisor = value;
          DismissGlopalLoading();
        });

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
        .then((value) {
          if (value == true) {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Done_Succ",
              ),
            );
          } else {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }

          hideSpinner31();
        });

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
        .then((value) {
          if (value == true) {
            Currentroom?.FollowRoom = 1;
          } else {
            Currentroom?.FollowRoom = 0;
          }

          notifyListeners();
        });

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
        .then((value) {
          if (value == true) {
            Currentroom?.FollowRoom = 0;
          } else {
            Currentroom?.FollowRoom = 1;
          }

          notifyListeners();
        });

    notifyListeners();
  }

  InviteToRoom({
    user,
    Roominfo,
    context,
  }) {
    final RoomPlayViewModel playroom =
        Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    );

    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    final SvgViewmodel svga =
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
            '${user['name']} ${getLang(
          context: NavigationService
              .navigatorKey
              .currentContext,
          key: "INVITE_SET",
        )}',
      );
    } else {
      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(
          context: NavigationService
              .navigatorKey
              .currentContext,
          key: "inviteyou",
        )} ${Roominfo['name']} ${getLang(
          context: NavigationService
              .navigatorKey
              .currentContext,
          key: "Room_now",
        )}  ',
        onTap: () {
          Navigator.pop(context);

          if (playroom.HasRoom) {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            room.JoinRoom2(
              Roomid: Roominfo['id'],
              context: context,
            );
          } else {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            room.JoinRoom5(
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

  inviteToChair({
    user,
    roominfo,
    chairId,
    context,
  }) {
    final RoomPlayViewModel playroom =
        Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    );

    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    final SvgViewmodel svga =
        Provider.of<SvgViewmodel>(
      context,
      listen: false,
    );

    final bool isSameRoom =
        roominfo['id'].toString() ==
            Currentroom?.id.toString();

    _roomAdminChairLog(
      'Invite received',
      'targetRoom=${roominfo['id']} '
          'currentRoom=${Currentroom?.id} '
          'chair=$chairId sameRoom=$isSameRoom '
          'hasRoom=${playroom.HasRoom} '
          'isRoom=${playroom.IsRoom}',
    );

    if (isSameRoom && playroom.HasRoom) {
      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(
          context: NavigationService
              .navigatorKey
              .currentContext,
          key: "INVITE_SET",
        )}',
        onTap: () {
          Navigator.pop(context);

          if (JoinChairs) {
            _roomAdminChairLog(
              'Invite rejected',
              'reason=already_joining_chair',
            );

            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "AlreadySet",
              ),
            );
            return;
          }

          final String invitedChairId =
              chairId?.toString() ?? '';

          final chairs = Currentroom?.chairs;

          if (invitedChairId.isEmpty || chairs == null) {
            _roomAdminChairLog(
              'Invite rejected',
              'reason=missing_chair_id_or_chair_list '
                  'chairIdEmpty=${invitedChairId.isEmpty} '
                  'chairsNull=${chairs == null}',
            );

            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
            return;
          }

          // An invitation provides a chair number, not necessarily a
          // unique database ID. Proceed only when the number is unique.
          final matchingIndexes = <int>[];

          for (var i = 0; i < chairs.length; i++) {
            if (chairs[i].chairId?.toString() ==
                invitedChairId) {
              matchingIndexes.add(i);
            }
          }

          if (matchingIndexes.isEmpty) {
            _roomAdminChairLog(
              'Invite rejected',
              'reason=chair_not_found chair=$invitedChairId '
                  'chairCount=${chairs.length}',
            );

            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
            return;
          }

          if (matchingIndexes.length > 1) {
            _roomAdminChairLog(
              'Invite rejected',
              'reason=ambiguous_chair chair=$invitedChairId '
                  'matches=${matchingIndexes.length}',
            );

            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
            return;
          }

          final int chairIndex = matchingIndexes.single;
          final invitedChair = chairs[chairIndex];

          _roomAdminChairLog(
            'Chair resolved',
            'index=$chairIndex chair=$invitedChairId '
                'databaseId=${invitedChair.id}',
          );

          if (invitedChair.userId != null ||
              invitedChair.user != null) {
            _roomAdminChairLog(
              'Invite rejected',
              'reason=chair_occupied chair=$invitedChairId',
            );

            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Another_Set",
              ),
            );
            return;
          }

          if (invitedChair.Lock == 1) {
            _roomAdminChairLog(
              'Invite rejected',
              'reason=chair_locked chair=$invitedChairId',
            );

            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Chair_lock",
              ),
            );
            return;
          }

          void joinInvitedChair() {
            // Revalidate the list position and chair state before joining.
            final currentChairs = Currentroom?.chairs;

            if (currentChairs == null ||
                chairIndex >= currentChairs.length) {
              _roomAdminChairLog(
                'Chair join aborted',
                'reason=chair_list_changed index=$chairIndex',
              );
              return;
            }

            final currentChair = currentChairs[chairIndex];

            if (currentChair.id != invitedChair.id ||
                currentChair.chairId != invitedChair.chairId) {
              _roomAdminChairLog(
                'Chair join aborted',
                'reason=chair_identity_changed index=$chairIndex',
              );
              return;
            }

            if (currentChair.userId != null ||
                currentChair.user != null ||
                currentChair.Lock == 1) {
              _roomAdminChairLog(
                'Chair join aborted',
                'reason=chair_no_longer_available '
                    'chair=${currentChair.chairId} '
                    'locked=${currentChair.Lock == 1}',
              );
              return;
            }

            _roomAdminChairLog(
              'Joining invited chair',
              'index=$chairIndex chair=${currentChair.chairId}',
            );

            room.JoinChair(
              index: chairIndex,
              context: context,
              chairid: currentChair.chairId,
            );
          }

          if (playroom.IsRoom) {
            joinInvitedChair();
          } else {
            _roomAdminChairLog(
              'Opening room for chair invitation',
              'room=${Currentroom?.id} chair=$invitedChairId',
            );

            svga.animationController?.clear();
            room.initscrollcontroller();

            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).DeleteGlopal();

            Navigator.pushNamed(
              context,
              AppConstants.Room_Screan,
            );

            Future.delayed(
              const Duration(seconds: 1),
              joinInvitedChair,
            );
          }
        },
        tittle: '',
        buttontext: getLang(
          context: context,
          key: "Yes",
        ),
      );
    } else {
      _roomAdminChairLog(
        'Invite targets another room',
        'targetRoom=${roominfo['id']} '
            'currentRoom=${Currentroom?.id}',
      );

      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(
          context: NavigationService
              .navigatorKey
              .currentContext,
          key: "inviteyou",
        )} ${roominfo['name']} ${getLang(
          context: NavigationService
              .navigatorKey
              .currentContext,
          key: "Room_now",
        )} ',
        onTap: () {
          Navigator.pop(context);

          Provider.of<GiftsViewModel>(
            context,
            listen: false,
          ).hidpanner2();

          svga.dispose();

          if (playroom.HasRoom) {
            room.JoinRoom2(
              Roomid: roominfo['id'],
              context: context,
            );
          } else {
            room.JoinRoom5(
              Roomid: roominfo['id'],
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
        .then((value) {
          if (value == true) {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
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
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }

          DismissGlopalLoading();
        });

    notifyListeners();
  }

  Addsupervisors({id}) {
    Currentroom?.supervisorsId?.add(id);
    notifyListeners();
  }

  Removesupervisors({id}) {
    Currentroom?.supervisorsId?.removeWhere(
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
        .then((value) {
          if (value != null) {
            Dialogs().showtoast('updated');
          } else {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }

          DismissGlopalLoading();
          notifyListeners();
        });
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
        .then((value) {
          if (value != false) {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
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
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }

          DismissGlopalLoading();
          notifyListeners();
        });
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
        .then((value) {
          if (value != false) {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Done_Succ",
              ),
            );
          } else {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }

          DismissGlopalLoading();
          notifyListeners();
        });
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
        .then((value) {
          if (value != null) {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Done_Succ",
              ),
            );

            PasswordRoom.clear();
          } else {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );

            PasswordRoom.clear();
          }

          Navigator.pop(context);
          notifyListeners();
        });
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
        .then((value) {
          if (value != null) {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Done_Succ",
              ),
            );
          } else {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }

          DismissGlopalLoading();
          notifyListeners();
        });
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
        .then((value) {
          if (value == true) {
            if (state == 1) {
              Provider.of<AgoraViewmodel>(
                roomcontext,
                listen: false,
              ).muteusermic(
                int.parse(user_id.toString()),
              );
            } else {
              Provider.of<AgoraViewmodel>(
                roomcontext,
                listen: false,
              ).unmuteusermic(
                int.parse(user_id.toString()),
              );
            }
          } else {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }

          notifyListeners();
        });
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
        .then((value) {
          if (value.isNotEmpty) {
            joinuserRooms = value;
            notifyListeners();
          }

          DismissGlopalLoading();
          notifyListeners();
        });
  }

  updateCurrentRoom({
    required RoomModel NewRoom,
  }) {
    _roomAdminChairLog(
      'Updating current room',
      'currentRoom=${Currentroom?.id} '
          'incomingRoom=${NewRoom.id} '
          'currentChairs=${Currentroom?.chairs?.length ?? 0} '
          'incomingChairs=${NewRoom.chairs?.length ?? 0}',
    );

    // Update room metadata only. Chair assignment state is left untouched.
    Currentroom?.name = NewRoom.name;
    Currentroom?.animateimage = NewRoom.animateimage;
    Currentroom?.locked = NewRoom.locked;
    Currentroom?.password = NewRoom.password;
    Currentroom?.image = NewRoom.image;
    Currentroom?.Category = NewRoom.Category;
    Currentroom?.nothostedimage = NewRoom.nothostedimage;
    Currentroom?.RoomAds = NewRoom.RoomAds;

    Rooms.forEach((element) {
      if (element.id == NewRoom.id) {
        element.name = NewRoom.name;
        element.image = NewRoom.image;
        element.password = NewRoom.password;
        element.RoomAds = NewRoom.RoomAds;
        element.Category = NewRoom.Category;
      }
    });

    notifyListeners();

    _roomAdminChairLog(
      'Current room updated',
      'room=${Currentroom?.id}',
    );
  }

  updateCurrentRoomPassword({
    required var Password,
    required String Id,
  }) {
    Currentroom?.password = Password;

    Rooms.forEach((element) {
      if (element.id.toString() == Id.toString()) {
        element.password = Password;
        notifyListeners();
      }
    });

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
        .then((value) {
          if (value == true) {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Done_Succ",
              ),
            );
          } else {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }
        });
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
        .then((value) {
          if (value == true) {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Done_Succ",
              ),
            );
          } else {
            Dialogs().showtoast(
              getLang(
                context: NavigationService
                    .navigatorKey
                    .currentContext,
                key: "Sorry",
              ),
            );
          }
        });
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
        .then((value) {
          BlockeduserRooms = value;
          DismissGlopalLoading();
        });

    notifyListeners();
  }
}