import 'dart:convert';
import 'dart:developer';

import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/MessageModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/notification.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class SocketuserViewmodel extends ChangeNotifier {
  PusherClient? pusher2;
  Channel? channel2;

  String? _connectedUserChannel;
  bool _isConnecting = false;
  bool _isDisposed = false;

  // ============================================================
  // LOGGING
  // ============================================================

  void _socketLog(String message) {
    log('[USER_PUSHER] $message');
  }

  void _socketError(
    String stage,
    Object error,
    StackTrace stackTrace,
  ) {
    log(
      '[USER_PUSHER] $stage: $error',
      stackTrace: stackTrace,
    );
  }

  // ============================================================
  // PAYLOAD DECODING
  // ============================================================

  Map<String, dynamic> _decodePayload(dynamic rawData) {
    dynamic decoded = rawData;

    if (rawData is String) {
      if (rawData.trim().isEmpty) {
        throw const FormatException('Pusher event data is empty.');
      }

      decoded = jsonDecode(rawData);
    }

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw FormatException(
      'Unexpected Pusher payload type: ${decoded.runtimeType}',
    );
  }

  int? _parseState(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }

  // ============================================================
  // CONNECT USER SOCKET
  // ============================================================

  Future<void> ConnectuserScocket(dynamic roomcontext) async {
    if (_isDisposed) {
      _socketLog('Connection skipped: ViewModel is disposed.');
      return;
    }

    final String? currentUserId = UserId?.toString();

    if (currentUserId == null || currentUserId.isEmpty) {
      _socketLog('Connection skipped: UserId is empty.');
      return;
    }

    final String userChannel = 'user$currentUserId';

    // Avoid creating duplicate connections to the same channel.
    if (_connectedUserChannel == userChannel &&
        pusher2 != null &&
        channel2 != null &&
        !_isConnecting) {
      _socketLog('Already configured for channel $userChannel.');
      return;
    }

    _isConnecting = true;

    _socketLog('========== CONNECT REQUEST ==========');
    _socketLog('Channel: $userChannel');
    _socketLog('Event: user');
    _socketLog('Cluster: mt1');

    try {
      await _disconnectExistingConnection();

      if (_isDisposed) return;

      pusher2 = PusherClient(
        'c131d267a74a0cbd3da9',
        PusherOptions(
          cluster: 'mt1',
          encrypted: true,
        ),
        enableLogging: true,
      );

      final PusherClient client = pusher2!;

      client.onConnectionStateChange((state) {
        _socketLog(
          'Connection state: '
          '${state?.previousState} -> ${state?.currentState}',
        );
      });

      client.onConnectionError((error) {
        _socketLog(
          'Connection error: '
          'message=${error?.message}, code=${error?.code}',
        );
      });

      channel2 = client.subscribe(userChannel);
      _connectedUserChannel = userChannel;

      channel2?.bind('user', (event) {
        if (_isDisposed) return;

        try {
          final Map<String, dynamic> decoded =
              _decodePayload(event?.data);

          final dynamic rawState = decoded['state'];
          final int? state = _parseState(rawState);

          _socketLog(
            'Event received: '
            'channel=$userChannel '
            'state=$state '
            'rawState=$rawState',
          );

          if (state == null) {
            _socketLog(
              'Event ignored: state is invalid. '
              'rawState=$rawState',
            );
            return;
          }

          final dynamic eventData = decoded['data'];

          // Keep detailed message payload logs limited to the
          // private-message event instead of printing every event.
          if (state == 5) {
            _socketLog('Private message event received.');
            _socketLog('Message data type: ${eventData.runtimeType}');
          }

          degisenMenu(
            data: decoded,
            state: state,
            roomcontext: roomcontext,
          );
        } catch (error, stackTrace) {
          _socketError(
            'Pusher event handling failed',
            error,
            stackTrace,
          );
        }
      });

      _socketLog('Subscribed to $userChannel.');
    } catch (error, stackTrace) {
      _socketError(
        'Connection setup failed',
        error,
        stackTrace,
      );
    } finally {
      _isConnecting = false;

      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  // ============================================================
  // DISCONNECT EXISTING CONNECTION
  // ============================================================

  Future<void> _disconnectExistingConnection() async {
    final Channel? oldChannel = channel2;
    final PusherClient? oldClient = pusher2;
    final String? oldChannelName = _connectedUserChannel;

    channel2 = null;
    pusher2 = null;
    _connectedUserChannel = null;

    try {
      if (oldChannel != null) {
        oldChannel.unbind('user');
      }

      if (oldClient != null && oldChannelName != null) {
        oldClient.unsubscribe(oldChannelName);
      }

      oldClient?.disconnect();
    } catch (error, stackTrace) {
      _socketError(
        'Previous connection cleanup failed',
        error,
        stackTrace,
      );
    }
  }

  // ============================================================
  // DISCONNECT USER SOCKET
  // ============================================================

  Future<void> DisConnect({required dynamic id}) async {
    _socketLog('========== DISCONNECT REQUEST ==========');
    _socketLog('Requested ID: $id');

    await _disconnectExistingConnection();

    _socketLog('Disconnect request completed.');

    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // ============================================================
  // USER SOCKET EVENT HANDLER
  // ============================================================

  Future<void> degisenMenu({
    required dynamic data,
    required dynamic state,
    required dynamic roomcontext,
    int? index,
  }) async {
    try {
      final Map<String, dynamic> payload = data is Map<String, dynamic>
          ? data
          : Map<String, dynamic>.from(data as Map);

      final int? normalizedState = _parseState(state);

      if (normalizedState == null) {
        _socketLog('Handler skipped: invalid state=$state');
        return;
      }

      final dynamic rawEventData = payload['data'];

      if (rawEventData is! Map) {
        _socketLog(
          'Handler received non-map data: '
          'state=$normalizedState, '
          'type=${rawEventData.runtimeType}',
        );
      }

      final LoginViewmodel user = Provider.of<LoginViewmodel>(
        roomcontext,
        listen: false,
      );

      final InboxroomViewModel inboxroom =
          Provider.of<InboxroomViewModel>(
        roomcontext,
        listen: false,
      );

      final RoomViewmodel rooms = Provider.of<RoomViewmodel>(
        roomcontext,
        listen: false,
      );

      switch (normalizedState) {
        // --------------------------------------------------------
        // STATE 0: UPDATE FRAME
        // --------------------------------------------------------
        case 0:
          user.UpdateFrame(
            frames: payload['data']['frame'],
          );
          break;

        // --------------------------------------------------------
        // STATE 1: UPDATE ENTRY
        // --------------------------------------------------------
        case 1:
          user.UpdateEntry(
            Entry: payload['data']['entry'],
          );
          break;

        // --------------------------------------------------------
        // STATE 2: REMOVE FRAME
        // --------------------------------------------------------
        case 2:
          user.removeFrame();
          break;

        // --------------------------------------------------------
        // STATE 3: REMOVE ENTRY
        // --------------------------------------------------------
        case 3:
          user.removeEntry();
          break;

        // --------------------------------------------------------
        // STATE 4: NEW INBOX ROOM
        // --------------------------------------------------------
        case 4:
          final InboxRoomModel inbox = InboxRoomModel.fromJson(
            Map<String, dynamic>.from(
              payload['data']['InboxRoom'] as Map,
            ),
          );

          inboxroom.AddnewInboxRoom(value: inbox);
          break;

        // --------------------------------------------------------
        // STATE 5: PRIVATE MESSAGE
        // --------------------------------------------------------
        case 5:
          final dynamic rawMessage = payload['data']['Messages'];

          if (rawMessage is! Map) {
            throw FormatException(
              'Messages must be a map; '
              'received ${rawMessage.runtimeType}.',
            );
          }

          final Message messages = Message.fromJson(
            Map<String, dynamic>.from(rawMessage),
          );

          _socketLog(
            'Private message parsed: '
            'messageId=${messages.id}, '
            'senderId=${messages.senderId}, '
            'recipientId=${messages.userId}, '
            'inboxId=${messages.inboxroomId}, '
            'currentUserId=${user.userinfo?.id}, '
            'currentInboxId=${inboxroom.inroomid}',
          );

          final matchingInboxes = inboxroom.Inboxrooms.where(
            (element) => element.id == messages.inboxroomId,
          );

          if (matchingInboxes.isNotEmpty) {
            final InboxRoomModel currentInbox = matchingInboxes.first;

            if (inboxroom.inroomid == messages.inboxroomId) {
              currentInbox.numberUnread = 0;
              inboxroom.AlreadyinInboxRoom();
            } else {
              currentInbox.numberUnread =
                  (currentInbox.numberUnread ?? 0) + 1;
            }

            currentInbox.updatedAt = messages.createdAt;
          }

          // A message from another user.
          if (messages.senderId.toString() !=
              user.userinfo?.id.toString()) {
            LocalNotificationService().showNotification(
              body: messages.message ?? '',
              id: 1,
              title: 'رساله جديده',
            );

            inboxroom.AddMessageInbox(
              value: messages,
              id: messages.inboxroomId,
              context: roomcontext,
            );
          }

          // A message received by the currently logged-in user.
          if (messages.userId.toString() ==
              user.userinfo?.id.toString()) {
            user.changeNewmessage(true);

            Helper().PlayMusic(
              path: AppConstants.Chatnotifi,
            );
          }

          break;

        // --------------------------------------------------------
        // STATE 6: ADD COINS
        // --------------------------------------------------------
        case 6:
          user.AddCoinspluse(
            value: int.parse(
              payload['data']['coins'].toString(),
            ),
          );
          break;

        // --------------------------------------------------------
        // STATE 7: ROOM INVITATION
        // --------------------------------------------------------
        case 7:
          LocalNotificationService().showNotification(
            body:
                '${payload['data']['Room']['name']}قام بدعوتك الي غرفه ',
            id: 3,
            title: payload['data']['user']['name'].toString(),
          );

          rooms.InviteToRoom(
            Roominfo: payload['data']['Room'],
            user: payload['data']['user'],
            context: roomcontext,
          );
          break;

        // --------------------------------------------------------
        // STATE 8: INVITATION TO CHAIR
        // --------------------------------------------------------
        case 8:
          rooms.inviteToChair(
            roominfo: payload['data']['Room'],
            user: payload['data']['user'],
            chairId: payload['data']['chair_id'],
            context: roomcontext,
          );
          break;

        // --------------------------------------------------------
        // STATE 9: CHANGE COINS
        // --------------------------------------------------------
        case 9:
          user.Changecoins(
            value: int.parse(
              payload['data']['coins'].toString(),
            ),
          );
          break;

        // --------------------------------------------------------
        // STATE 10: SUBTRACT COINS
        // --------------------------------------------------------
        case 10:
          user.MinusCoinspluse(
            value: int.parse(
              payload['data']['coins'].toString(),
            ),
          );
          break;

        // --------------------------------------------------------
        // STATE 11: REWARD
        // --------------------------------------------------------
        case 11:
          final String coins = payload['data']['coins'].toString();

          Dialogs().showtoast(
            '    لقد ربحت  $coins ماسه   ',
          );

          user.AddCoinspluse(
            value: int.parse(coins),
          );
          break;

        // --------------------------------------------------------
        // STATE 12: REMOVE ENTER BUBBLES
        // --------------------------------------------------------
        case 12:
          user.removeEnterbubles();
          break;

        // --------------------------------------------------------
        // STATE 13: UPDATE ENTER BUBBLES
        // --------------------------------------------------------
        case 13:
          user.UpdateEnterbubles(
            frames: payload['data']['frame'],
          );
          break;

        // --------------------------------------------------------
        // STATE 14: FOLLOW NOTIFICATION
        // --------------------------------------------------------
        case 14:
          final usermodel followedUser = usermodel.fromJson(
            Map<String, dynamic>.from(
              payload['data']['sender'] as Map,
            ),
          );

          LocalNotificationService().showNotification(
            body: '  قام ${followedUser.name} بمتابعتك  ',
            id: 5,
            title: 'رساله جديده',
          );

          final BuildContext? dialogContext =
              NavigationService.navigatorKey.currentContext;

          if (dialogContext == null) {
            _socketLog(
              'Follow dialog skipped: navigator context is null.',
            );
            break;
          }

          showDialog<void>(
            context: dialogContext,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFF2b2f3b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                content: Text(
                  '  قام ${followedUser.name} بمتابعتك  ',
                  style: style3.copyWith(
                    color: const Color(0xFFeae2be),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            final BuildContext? currentContext =
                                NavigationService
                                    .navigatorKey.currentContext;

                            if (currentContext != null) {
                              Provider.of<FollowViewModel>(
                                currentContext,
                                listen: false,
                              ).ReturnFollow(
                                context: currentContext,
                                Senderid: followedUser.id,
                              );
                            }

                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 80,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFFeae2be),
                            ),
                            child: Center(
                              child: Text(
                                'رد المتابعه',
                                style: style6.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 80,
                            height: 37,
                            decoration: BoxDecoration(
                              color: const Color(0xFFeae2be),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                getLang(
                                  context: context,
                                  key: 'Close',
                                ),
                                style: style6.copyWith(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
          break;

        // --------------------------------------------------------
        // STATE 15: REMOVE PROFILE BUBBLES
        // --------------------------------------------------------
        case 15:
          user.removeProfilebubles();
          break;

        // --------------------------------------------------------
        // STATE 16: UPDATE PROFILE BUBBLES
        // --------------------------------------------------------
        case 16:
          user.UpdateProfilebubles(
            frames: payload['data']['frame'],
          );
          break;

        // --------------------------------------------------------
        // STATE 17: ACCOUNT BLOCKED
        // --------------------------------------------------------
        case 17:
          LocalNotificationService().showNotification(
            body: 'تم حظر هذا الحساب',
            id: 2,
            title: 'رساله جديده',
          );

          Dialogs().showtoast('تم حظر هذا الحساب');

          SystemNavigator.pop();
          break;

        // --------------------------------------------------------
        // STATE 18: GENERAL NOTIFICATION
        // --------------------------------------------------------
        case 18:
          LocalNotificationService().showNotification(
            body: payload['data']['message'].toString(),
            id: 8,
            title: 'رساله جديده',
          );
          break;

        default:
          _socketLog('Unknown event state: $normalizedState');
      }
    } catch (error, stackTrace) {
      _socketError(
        'Event handler failed for state=$state',
        error,
        stackTrace,
      );
    }
  }

  // ============================================================
  // CLEANUP
  // ============================================================

  @override
  void dispose() {
    _isDisposed = true;

    final Channel? oldChannel = channel2;
    final PusherClient? oldClient = pusher2;
    final String? oldChannelName = _connectedUserChannel;

    channel2 = null;
    pusher2 = null;
    _connectedUserChannel = null;

    try {
      oldChannel?.unbind('user');

      if (oldClient != null && oldChannelName != null) {
        oldClient.unsubscribe(oldChannelName);
      }

      oldClient?.disconnect();
    } catch (error, stackTrace) {
      _socketError(
        'Dispose cleanup failed',
        error,
        stackTrace,
      );
    }

    super.dispose();
  }
}
