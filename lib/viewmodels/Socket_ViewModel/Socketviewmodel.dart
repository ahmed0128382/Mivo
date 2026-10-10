
import 'dart:convert';

import 'package:ahlachat/models/guessGameModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/models/GiveGifts.dart';

import '../../util/helperclass.dart';

// ezgif.com_gif_maker_4_.json
var roomcontext;

class SocketViewmodel extends ChangeNotifier {
  PusherClient? pusher;
  Channel? channel;

  bool _isConnecting = false;
  String? _subscribedChannelName;

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  dynamic _decodeSocketPayload(dynamic rawData) {
    if (rawData is Map) {
      return Map<String, dynamic>.from(rawData);
    }

    if (rawData is String && rawData.isNotEmpty) {
      final decoded = jsonDecode(rawData);

      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    }

    throw FormatException(
      'Unexpected Pusher payload type: ${rawData.runtimeType}',
    );
  }

  // ============================================================
  // CONNECT SOCKET
  // ============================================================

  Future ConnectRoomScocket(context, id) async {
    final channelName = 'Room$id';

    if (_isConnecting && _subscribedChannelName == channelName) {
      return;
    }

    // Unsubscribe from the previous room channel before subscribing.
    // This prevents duplicate callbacks when changing rooms.
    if (_subscribedChannelName != null &&
        _subscribedChannelName != channelName) {
      try {
        pusher?.unsubscribe(_subscribedChannelName!);
      } catch (_) {
        // Keep socket cleanup errors from interrupting room navigation.
      }
    }

    roomcontext = context;
    _isConnecting = true;
    _subscribedChannelName = channelName;

    try {
      pusher = PusherClient(
        'c131d267a74a0cbd3da9',
        PusherOptions(cluster: 'mt1'),
        enableLogging: false,
      );

      pusher?.onConnectionStateChange((state) {
        _isConnecting = false;
      });

      pusher?.onConnectionError((error) {
        _isConnecting = false;
      });

      channel = pusher?.subscribe(channelName);

      channel?.bind('Room', (event) {
        try {
          final decoded = _decodeSocketPayload(event?.data);

          final dynamic rawState = decoded['state'];

          degisenMenu(
            data: decoded,
            state: rawState,
          );
        } catch (_) {
          // Ignore malformed events instead of flooding the console.
        }
      });

      pusher?.connect();

      notifyListeners();
    } catch (_) {
      _isConnecting = false;
      rethrow;
    }
  }

  // ============================================================
  // DISCONNECT SOCKET
  // ============================================================

  Future DisConnect({required id}) async {
    final channelName = 'Room$id';

    try {
      pusher?.unsubscribe(channelName);

      if (_subscribedChannelName == channelName) {
        _subscribedChannelName = null;
        channel = null;
        _isConnecting = false;
      }
    } catch (_) {
      // Do not print repetitive disconnect diagnostics.
    }

    notifyListeners();
  }

  // ============================================================
  // SOCKET EVENT HANDLER
  // ============================================================

  degisenMenu({data, state, index}) async {
    final parsedState = _toInt(state);

    if (roomcontext == null || parsedState == null || data is! Map) {
      return;
    }

    final AgoraViewmodel Agora = Provider.of<AgoraViewmodel>(
      roomcontext,
      listen: false,
    );

    final LoginViewmodel user = Provider.of<LoginViewmodel>(
      roomcontext,
      listen: false,
    );

    switch (parsedState) {
      // --------------------------------------------------------
      // STATE 0: USER ENTERS ROOM
      // --------------------------------------------------------
      case 0:
        final userinfo = usermodel.fromJson(
          Map<String, dynamic>.from(data['data'] as Map),
        );

        if (userinfo.Hidden == 0) {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).ShowEnterWidget(Info: userinfo);

          if (userinfo.entry != null && userinfo.entry != '') {
            Provider.of<SvgViewmodel>(
              roomcontext,
              listen: false,
            ).getcontroller(
              enterImage: userinfo.image,
              entername: userinfo.name,
              svga: userinfo.entry ?? '',
            );

            if (userinfo.id.toString() !=
                    user.userinfo?.id.toString() &&
                userinfo.Hidden != 1) {
              if (userinfo.entry == null || userinfo.entry == '') {
                EnterImage = userinfo.image;
                Entername = userinfo.name;
              }

              Provider.of<GiftsViewModel>(
                roomcontext,
                listen: false,
              ).sidepanner();
            }
          }

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).AddChatRoom(
            message: Chatroom(
              kind: 3,
              user: userinfo,
              content: '${userinfo.name} Enter Room',
            ),
          );

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).AddusertoRoom(
            JoinRoom: joinRoom(
              user: userinfo,
              id: 45,
              index: 1,
              roomId: Provider.of<RoomViewmodel>(
                roomcontext,
                listen: false,
              ).Currentroom?.id,
              userId: userinfo.id,
              updatedAt: '',
              createdAt: '',
            ),
            join: userinfo,
            ctx: roomcontext,
            index: index,
          );
        }

        // Do not assign the admin to a fixed chair index here.
        // Chair assignment must come from the server's chair event
        // or the complete room update.
        break;

      // --------------------------------------------------------
      // STATE 1: USER JOINS A CHAIR
      // --------------------------------------------------------
      case 1:
        try {
          final chair = Chairs.fromJson(
            Map<String, dynamic>.from(data['data'] as Map),
          );

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).AddusertoChair(
            ctx: roomcontext,
            data: chair,
          );
        } catch (_) {
          // Ignore invalid chair payloads.
        }

        break;

      // --------------------------------------------------------
      // STATE 2: USER LEAVES ROOM
      // --------------------------------------------------------
      case 2:
        final userinfo = usermodel.fromJson(
          Map<String, dynamic>.from(data['data'] as Map),
        );

        Provider.of<AgoraViewmodel>(
          roomcontext,
          listen: false,
        ).unmuteusermic(int.parse(userinfo.id.toString()));

        if (userinfo.Hidden == 0) {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).AddChatRoom(
            message: Chatroom(
              kind: 3,
              user: userinfo,
              content: '${userinfo.name} Leaved Room',
            ),
          );
        }

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).RemoveuserfromRoom(id: userinfo.id.toString());

        break;

      // --------------------------------------------------------
      // STATE 3: REMOVE USER FROM CHAIR
      // --------------------------------------------------------
      case 3:
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).RemoveuserfromChair(id: data['data'].toString());

        break;

      // --------------------------------------------------------
      // STATE 4: CHAT MESSAGE
      // --------------------------------------------------------
      case 4:
        final chatroom = Chatroom.fromJson(
          Map<String, dynamic>.from(data['data'] as Map),
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).AddChatRoom(message: chatroom);

        break;

      // --------------------------------------------------------
      // STATE 5: GIFT
      // --------------------------------------------------------
      case 5:
        final give = givegifts.fromJson(data['data']['gift']);
        final giftUser = usermodel.fromJson(data['data']['user']);

        give.ListUser.forEach((elements) {
          final List? recipients = Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).Currentroom?.joinRooms
              ?.where(
                (element) =>
                    element.userId.toString() == elements.toString(),
              )
              .toList();

          if (recipients != null && recipients.isNotEmpty) {
            final userinfo = recipients.first.user;

            Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).Addmessagetocurrentroom(
              message: Chatroom(
                kind: 2,
                user: giftUser,
                id: 0,
                content: 'xxxxxxxxxx',
                userId: giftUser.id.toString(),
                updatedAt: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.updatedAt,
                roomId: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.id.toString(),
                createdAt: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.createdAt,
                Gift: give,
                RecevedUser: userinfo,
              ),
            );
          } else {
            Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).Addmessagetocurrentroom(
              message: Chatroom(
                kind: 2,
                user: giftUser,
                id: 0,
                content: 'xxxxxxxxxx',
                userId: giftUser.id.toString(),
                updatedAt: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.updatedAt,
                roomId: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.id.toString(),
                createdAt: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.createdAt,
                Gift: give,
                RecevedUser: Provider.of<LoginViewmodel>(
                  roomcontext,
                  listen: false,
                ).userinfo,
              ),
            );
          }
        });

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).updatekaresma(
          context: roomcontext,
          Amount: give.ListUser.length *
              give.price! *
              int.parse(give.quantity ?? '0'),
        );

        if (data['data']['kind'] == 1 ||
            data['data']['kind'] == '1') {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).AddKaresmaChair(
            userids: give.ListUser,
            Amount: (
              (int.parse(give.quantity ?? '0') * (give.price ?? 0)) /
              10
            ).round(),
          );
        } else {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).AddKaresmaChair(
            userids: give.ListUser,
            Amount: int.parse(give.quantity ?? '0') * (give.price ?? 0),
          );
        }

        Provider.of<SvgViewmodel>(
          roomcontext,
          listen: false,
        ).getcontroller2(
          svga: give.svga,
          Give: give,
          context: roomcontext,
          userinfo: giftUser,
        );

        break;

      // --------------------------------------------------------
      // STATE 6: USER IS MUTED / REMOVED
      // --------------------------------------------------------
      case 6:
        final users = usermodel.fromJson(
          Map<String, dynamic>.from(data['data'] as Map),
        );

        Provider.of<AgoraViewmodel>(
          roomcontext,
          listen: false,
        ).muteusermic(int.parse(users.id.toString()));

        if (users.id.toString() == user.userinfo?.id.toString()) {
          Provider.of<SocketViewmodel>(
            roomcontext,
            listen: false,
          ).DisConnect(
            id: Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).Currentroom?.id.toString(),
          );

          Provider.of<SvgViewmodel>(
            roomcontext,
            listen: false,
          ).dispose();

          Provider.of<RoomPlayViewModel>(
            roomcontext,
            listen: false,
          ).changeHasRoomstate(false);

          Provider.of<RoomPlayViewModel>(
            roomcontext,
            listen: false,
          ).changeIsRoomstate(false);

          JoinChairs = false;
          Agora.EndAgora();

          if (Provider.of<RoomPlayViewModel>(
                roomcontext,
                listen: false,
              ).IsRoom ==
              true) {
            Navigator.pop(roomcontext);
          }

          Future.delayed(const Duration(seconds: 1), () {
            Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).ClearCurrentroom();
          });
        }

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).RemoveuserfromRoom(id: users.id.toString());

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).AddChatRoom(
          message: Chatroom(
            kind: 3,
            user: users,
            content: '${users.name} Leaved Room',
          ),
        );

        break;

      // --------------------------------------------------------
      // STATE 7: ROOM DISBANDED
      // --------------------------------------------------------
      case 7:
        final rooms = RoomModel.fromJson(
          Map<String, dynamic>.from(data['data']['room'] as Map),
        );

        if (rooms.adminId.toString() != user.userinfo?.id.toString()) {
          Provider.of<SocketViewmodel>(
            roomcontext,
            listen: false,
          ).DisConnect(
            id: Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).Currentroom?.id.toString(),
          );

          Provider.of<SvgViewmodel>(
            roomcontext,
            listen: false,
          ).dispose();

          Provider.of<RoomPlayViewModel>(
            roomcontext,
            listen: false,
          ).changeHasRoomstate(false);

          JoinChairs = false;
          Agora.EndAgora();

          if (Provider.of<RoomPlayViewModel>(
                roomcontext,
                listen: false,
              ).IsRoom ==
              true) {
            Navigator.pop(roomcontext);
          }

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).RemoveRoomFromlist(RoomId: rooms.id);

          Dialogs().showtoast('Room Disbanded');
        }

        if (rooms.adminId.toString() == user.userinfo?.id.toString() &&
            data['data']['admin'] != null) {
          Dialogs().showtoast('Room Disbanded By Admin !');

          Provider.of<SocketViewmodel>(
            roomcontext,
            listen: false,
          ).DisConnect(
            id: Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).Currentroom?.id.toString(),
          );

          Provider.of<SvgViewmodel>(
            roomcontext,
            listen: false,
          ).dispose();

          Provider.of<RoomPlayViewModel>(
            roomcontext,
            listen: false,
          ).changeIsRoomstate(false);

          JoinChairs = false;
          Agora.EndAgora();

          if (Provider.of<RoomPlayViewModel>(
                roomcontext,
                listen: false,
              ).IsRoom ==
              true) {
            Navigator.pop(roomcontext);
          }

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).RemoveRoomFromlist(RoomId: rooms.id);

          Provider.of<LoginViewmodel>(
            roomcontext,
            listen: false,
          ).userinfo?.currentroom = null;
        }

        break;

      // --------------------------------------------------------
      // STATE 8: ADMIN MUTES / UNMUTES MIC
      // --------------------------------------------------------
      case 8:
        if (data['data']['userid'].toString() == UserId.toString() &&
            data['data']['state'].toString() == '0') {
          Agora.UnMute();
        } else if (data['data']['userid'].toString() ==
                UserId.toString() &&
            data['data']['state'].toString() == '1') {
          Agora.Mute();
        }

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Changemicestateadmin(
          userId: data['data']['userid'],
          state: int.parse(data['data']['state'].toString()),
        );

        break;

      // --------------------------------------------------------
      // STATE 9: LOCK / UNLOCK CHAIR
      // --------------------------------------------------------
      case 9:
        final roomViewModel = Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        );

        final dynamic chairData = data['data'];
        final dynamic rawState = chairData?['state'];
        final dynamic rawChairId = chairData?['chair']?['chair_id'];

        final int? lockState = _toInt(rawState);
        final int? chairNumber = _toInt(rawChairId);

        if (roomViewModel.Currentroom?.adminId?.toString() ==
            UserId.toString()) {
          break;
        }

        if (lockState == null || chairNumber == null) {
          break;
        }

        // chair_id is the chair number, not the database record ID.
        // Avoid changing chair matching semantics without server support.
        roomViewModel.LockChair(
          state: lockState,
          chairId: chairNumber,
        );

        break;

      // --------------------------------------------------------
      // STATE 10: ADMIN CLOSES / REMOVES USER
      // --------------------------------------------------------
      case 10:
        if (data['data'].toString() == user.userinfo?.id.toString()) {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).DisposeController();

          Provider.of<SocketViewmodel>(
            roomcontext,
            listen: false,
          ).DisConnect(
            id: Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).Currentroom?.id.toString(),
          );

          Provider.of<SvgViewmodel>(
            roomcontext,
            listen: false,
          ).dispose();

          Provider.of<RoomPlayViewModel>(
            roomcontext,
            listen: false,
          ).changeHasRoomstate(false);

          Provider.of<RoomPlayViewModel>(
            roomcontext,
            listen: false,
          ).changeIsRoomstate(false);

          JoinChairs = false;
          Agora.EndAgora();

          if (Provider.of<RoomPlayViewModel>(
                roomcontext,
                listen: false,
              ).IsRoom ==
              true) {
            Navigator.pop(roomcontext);
          }

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).removecurrentroom();
        }

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).RemoveuserfromRoom(id: data['data'].toString());

        break;

      // --------------------------------------------------------
      // STATE 11: REPLACE CURRENT ROOM
      // --------------------------------------------------------
      case 11:
        try {
          final rooms = RoomModel.fromJson(
            Map<String, dynamic>.from(data['data'] as Map),
          );

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).updateCurrentRoom(NewRoom: rooms);
        } catch (_) {
          // Ignore invalid room update payloads.
        }

        break;

      // --------------------------------------------------------
      // STATE 12: ROOM PASSWORD UPDATE
      // --------------------------------------------------------
      case 12:
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).updateCurrentRoomPassword(
          Id: data['data']['room_id'],
          Password: data['data']['password'],
        );

        break;

      // --------------------------------------------------------
      // STATE 13: DELETE ROOM CHAT
      // --------------------------------------------------------
      case 13:
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).deleteroomchat();

        break;

      case 14:
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Addsupervisors(id: data['data']);
        break;

      case 15:
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Removesupervisors(id: data['data']);
        break;

      case 16:
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).RemoveuserfromRoom(id: data['data'].toString());
        break;

      case 17:
        Provider.of<LoginViewmodel>(
          roomcontext,
          listen: false,
        ).adduserimoge(
          id: int.parse(data['data']['user'].toString()),
          imoges: data['data']['emoji'],
        );
        break;

      case 18:
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).UpdateThronechair(
          value: int.parse(data['data'].toString()),
        );
        break;

      // --------------------------------------------------------
      // STATE 19: CHANGE ROOM CHAIR
      // --------------------------------------------------------
      case 19:
        try {
          final changedUser = usermodel.fromJson(
            Map<String, dynamic>.from(data['data']['user'] as Map),
          );

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).changeRoomChair(
            user: changedUser,
            newChair: data['data']['chair_id'],
          );
        } catch (_) {
          // Ignore invalid chair-change payloads.
        }

        break;

      // --------------------------------------------------------
      // STATE 20: RETURN TO ADMIN CHAIR
      // --------------------------------------------------------
      case 20:
        try {
          final changedUser = usermodel.fromJson(
            Map<String, dynamic>.from(data['data']['user'] as Map),
          );

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).returntoAdminRoomChair(
            user: changedUser,
            newChair: data['data']['chair_id'],
          );
        } catch (_) {
          // Ignore invalid admin-chair payloads.
        }

        break;

      // --------------------------------------------------------
      // STATE 21: DICE
      // --------------------------------------------------------
      case 21:
        final diceUser = usermodel.fromJson(
          Map<String, dynamic>.from(data['data']['user'] as Map),
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).AddChatRoom(
          message: Chatroom(
            kind: 5,
            user: diceUser,
            content: AppConstants.Image_URL + data['data']['dice'],
          ),
        );

        break;

      // --------------------------------------------------------
      // STATE 22: NAMED EVENT
      // --------------------------------------------------------
      case 22:
        final namedUser = usermodel.fromJson(
          Map<String, dynamic>.from(data['data']['user'] as Map),
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).AddChatRoom(
          message: Chatroom(
            kind: 6,
            user: namedUser,
            content: data['data']['name'],
          ),
        );

        break;

      // --------------------------------------------------------
      // STATE 23: USER MESSAGE
      // --------------------------------------------------------
      case 23:
        final sender = usermodel.fromJson(
          Map<String, dynamic>.from(data['data']['user'] as Map),
        );

        final receivedUser = usermodel.fromJson(
          Map<String, dynamic>.from(data['data']['reciveruser'] as Map),
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).AddChatRoom(
          message: Chatroom(
            kind: 7,
            user: sender,
            content: data['data']['content'],
            RecevedUser: receivedUser,
          ),
        );

        break;

      // --------------------------------------------------------
      // STATE 24: IMAGE MESSAGE
      // --------------------------------------------------------
      case 24:
        final imageUser = usermodel.fromJson(
          Map<String, dynamic>.from(data['data']['user'] as Map),
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).AddChatRoom(
          message: Chatroom(
            kind: 8,
            user: imageUser,
            content: AppConstants.Image_URL + data['data']['content'],
          ),
        );

        break;

      // --------------------------------------------------------
      // STATE 25: COMBO GIFT
      // --------------------------------------------------------
      case 25:
        final give = givegifts.fromJson(data['data']['gift']);
        final giftUser = usermodel.fromJson(data['data']['user']);

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).addCombo(
          count: give.quantity,
          id: giftUser.id,
          image: giftUser.image ?? '',
          image2: give.image,
        );

        give.ListUser.forEach((elements) {
          final List? recipients = Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).Currentroom?.joinRooms
              ?.where(
                (element) =>
                    element.userId.toString() == elements.toString(),
              )
              .toList();

          if (recipients != null && recipients.isNotEmpty) {
            final userinfo = recipients.first.user;

            Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).Addmessagetocurrentroom(
              message: Chatroom(
                kind: 2,
                user: giftUser,
                id: 0,
                content: 'xxxxxxxxxx',
                userId: giftUser.id.toString(),
                updatedAt: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.updatedAt,
                roomId: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.id.toString(),
                createdAt: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.createdAt,
                Gift: give,
                RecevedUser: userinfo,
              ),
            );
          } else {
            Provider.of<RoomViewmodel>(
              roomcontext,
              listen: false,
            ).Addmessagetocurrentroom(
              message: Chatroom(
                kind: 2,
                user: giftUser,
                id: 0,
                content: 'xxxxxxxxxx',
                userId: giftUser.id.toString(),
                updatedAt: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.updatedAt,
                roomId: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.id.toString(),
                createdAt: Provider.of<RoomViewmodel>(
                  roomcontext,
                  listen: false,
                ).Currentroom?.createdAt,
                Gift: give,
                RecevedUser: Provider.of<LoginViewmodel>(
                  roomcontext,
                  listen: false,
                ).userinfo,
              ),
            );
          }
        });

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).updatekaresma(
          context: roomcontext,
          Amount: give.ListUser.length *
              give.price! *
              int.parse(give.quantity ?? '0'),
        );

        if (data['data']['kind'] == 1 ||
            data['data']['kind'] == '1') {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).AddKaresmaChair(
            userids: give.ListUser,
            Amount: (
              (int.parse(give.quantity ?? '0') * (give.price ?? 0)) /
              10
            ).round(),
          );
        } else {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).AddKaresmaChair(
            userids: give.ListUser,
            Amount: int.parse(give.quantity ?? '0') * (give.price ?? 0),
          );
        }

        break;

      // --------------------------------------------------------
      // STATE 26: GUESS GAME
      // --------------------------------------------------------
      case 26:
        final gameUser = usermodel.fromJson(
          Map<String, dynamic>.from(data['data']['user'] as Map),
        );

        final guessGame = guessgamemodel.fromJson(
          data['data']['Guessgame'],
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).AddChatRoom(
          message: Chatroom(
            kind: 9,
            Guess: guessGame,
            id: data['data']['Guessgameid'],
            user: gameUser,
            content: data['data']['Guess'],
            Coins: data['data']['Coins'],
          ),
        );

        break;

      // --------------------------------------------------------
      // STATE 27: GUESS GAME RESULT
      // --------------------------------------------------------
      case 27:
        final guessGame = guessgamemodel.fromJson(
          data['data']['Guessgame'],
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).AddGuessGame(
          winnerid: data['data']['winner'],
          guess: guessGame,
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).ChangeGuessGame(
          Guess: guessGame,
          winnerid: data['data']['winner'],
        );

        break;

      // --------------------------------------------------------
      // STATE 28: LUCKY PACKAGE
      // --------------------------------------------------------
      case 28:
        SmartDialog.dismiss();

        Provider.of<LoginViewmodel>(
          roomcontext,
          listen: false,
        ).LuckYPackage(
          id: int.parse(data['data']['id'].toString()),
          Lucky: data['data']['user'],
        );

        break;

      default:
        // Unknown event states are ignored to avoid noisy logs.
        break;
    }
  }
}
