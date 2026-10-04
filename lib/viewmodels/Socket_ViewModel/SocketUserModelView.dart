import 'dart:convert';
import 'dart:developer';

import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/notification.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/MessageModel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/main.dart';
import '../../util/Dialogs.dart';

class SocketuserViewmodel extends ChangeNotifier {
  PusherClient? pusher2;
  Channel? channel2;

  Future<void> ConnectuserScocket(roomcontext) async {
    print('========== USER PUSHER CONNECT ==========');
    print('PUSHER KEY: 4e68aedca5c74610deac');
    print('PUSHER CLUSTER: mt1');
    print('PUSHER CHANNEL: user$UserId');
    print('PUSHER EVENT: user');
    print('=========================================');

    // Disconnect previous connection if one exists.
    try {
      channel2?.unbind('user');
      pusher2?.unsubscribe('user$UserId');
      pusher2?.disconnect();
    } catch (e) {
      print('OLD USER PUSHER DISCONNECT ERROR: $e');
    }

    pusher2 = PusherClient(
      '4e68aedca5c74610deac',
      PusherOptions(
        cluster: 'mt1',
        encrypted: true,
      ),
      enableLogging: true,
    );

    // Connection state listener
    pusher2?.onConnectionStateChange((state) {
      print('========== USER PUSHER STATE ==========');
      print('PREVIOUS: ${state?.previousState}');
      print('CURRENT:  ${state?.currentState}');
      print('=======================================');

      log(
        'User Pusher state: '
        '${state?.previousState} -> ${state?.currentState}',
      );
    });

    // Connection error listener
    pusher2?.onConnectionError((error) {
      print('========== USER PUSHER ERROR ==========');
      print('MESSAGE: ${error?.message}');
      print('CODE: ${error?.code}');
      print('=======================================');

      log('User Pusher error: ${error?.message}');
    });

    // Connect
    print('USER PUSHER: connecting...');
    pusher2?.connect();

    // Subscribe to user channel
    final String userChannel = 'user$UserId';

    print('USER PUSHER: subscribing to "$userChannel"...');

    channel2 = pusher2?.subscribe(userChannel);

    // Bind user event
    channel2?.bind('user', (e) {
      print('========== USER PUSHER EVENT ==========');
      print('CHANNEL: $userChannel');
      print('EVENT: user');
      print('RAW DATA: ${e?.data}');
      print('=======================================');

      try {
        final String rawData = e?.data ?? '';

        if (rawData.isEmpty) {
          print('USER PUSHER: event data is empty');
          return;
        }

        final Map<String, dynamic> decoded =
            jsonDecode(rawData) as Map<String, dynamic>;

        final dynamic state = decoded['state'];

        print('USER PUSHER EVENT STATE: $state');

        degisenMenu(
          data: decoded,
          state: state,
          roomcontext: roomcontext,
        );
      } catch (e, stackTrace) {
        print('========== USER PUSHER EVENT ERROR ==========');
        print('ERROR: $e');
        print('STACK TRACE:');
        print(stackTrace);
        print('=============================================');
      }
    });

    notifyListeners();
  }

  Future<void> DisConnect({required id}) async {
    final String userChannel = 'user$id';

    print('========== USER PUSHER DISCONNECT ==========');
    print('CHANNEL: $userChannel');

    try {
      channel2?.unbind('user');
      pusher2?.unsubscribe(userChannel);
      pusher2?.disconnect();

      channel2 = null;
      pusher2 = null;

      print('USER PUSHER: disconnected successfully');
    } catch (e, stackTrace) {
      print('USER PUSHER DISCONNECT ERROR: $e');
      print(stackTrace);
    }

    notifyListeners();
  }

  Future<void> degisenMenu({
    required dynamic data,
    required dynamic state,
    required dynamic roomcontext,
    int? index,
  }) async {
    try {
      final LoginViewmodel user =
          Provider.of<LoginViewmodel>(
        roomcontext,
        listen: false,
      );

      final InboxroomViewModel Inboxroom =
          Provider.of<InboxroomViewModel>(
        roomcontext,
        listen: false,
      );

      final RoomViewmodel Rooms =
          Provider.of<RoomViewmodel>(
        roomcontext,
        listen: false,
      );

      switch (state) {
        case 0:
          user.UpdateFrame(
            frames: data['data']['frame'],
          );
          break;

        case 1:
          user.UpdateEntry(
            Entry: data['data']['entry'],
          );
          break;

        case 2:
          user.removeFrame();
          break;

        case 3:
          user.removeEntry();
          break;

        case 4:
          final InboxRoomModel Inbox =
              InboxRoomModel.fromJson(
            data['data']['InboxRoom'],
          );

          Inboxroom.AddnewInboxRoom(
            value: Inbox,
          );
          break;

        case 5:
          final Message messages =
              Message.fromJson(
            data['data']['Messages'],
          );

          final Inbox = Inboxroom.Inboxrooms.where(
            (element) => element.id == messages.inboxroomId,
          );

          if (Inboxroom.inroomid == messages.inboxroomId) {
            if (Inbox.isNotEmpty) {
              Inbox.first.numberUnread = 0;
            }

            Inboxroom.AlreadyinInboxRoom();
          } else {
            if (Inbox.isNotEmpty) {
              Inbox.first.numberUnread =
                  (Inbox.first.numberUnread ?? 0) + 1;
            }
          }

          if (Inbox.isNotEmpty) {
            Inbox.first.updatedAt = messages.createdAt;
          }

          if (messages.senderId.toString() !=
              user.userinfo?.id.toString()) {
            LocalNotificationService().showNotification(
              body: messages.message ?? "",
              id: 1,
              title: 'رساله جديده',
            );

            Inboxroom.AddMessageInbox(
              value: messages,
              id: messages.inboxroomId,
              context: roomcontext,
            );
          }

          if (messages.userId.toString() ==
              user.userinfo?.id.toString()) {
            LocalNotificationService().showNotification(
              body: messages.message ?? "",
              id: 1,
              title: 'رساله جديده',
            );

            user.changeNewmessage(true);

            Helper().PlayMusic(
              path: AppConstants.Chatnotifi,
            );
          }

          break;

        case 6:
          user.AddCoinspluse(
            value: int.parse(
              data['data']['coins'].toString(),
            ),
          );
          break;

        case 7:
          LocalNotificationService().showNotification(
            body:
                '${data['data']['Room']['name']}قام بدعوتك الي غرفه ',
            id: 3,
            title: data['data']['user']['name'],
          );

          Rooms.InviteToRoom(
            Roominfo: data['data']['Room'],
            user: data['data']['user'],
            context: roomcontext,
          );

          break;

        case 8:
          Rooms.InviteToChair(
            Roominfo: data['data']['Room'],
            user: data['data']['user'],
            Chair_id: data['data']['chair_id'],
            context: roomcontext,
          );

          break;

        case 9:
          user.Changecoins(
            value: int.parse(
              data['data']['coins'].toString(),
            ),
          );
          break;

        case 10:
          user.MinusCoinspluse(
            value: int.parse(
              data['data']['coins'].toString(),
            ),
          );
          break;

        case 11:
          Dialogs().showtoast(
            '    لقد ربحت  ${data['data']['coins'].toString()} ماسه   ',
          );

          user.AddCoinspluse(
            value: int.parse(
              data['data']['coins'].toString(),
            ),
          );

          break;

        case 12:
          user.removeEnterbubles();
          break;

        case 13:
          user.UpdateEnterbubles(
            frames: data['data']['frame'],
          );
          break;

        case 14:
          final usermodel followedUser =
              usermodel.fromJson(
            data['data']['sender'],
          );

          LocalNotificationService().showNotification(
            body:
                '  قام ${followedUser.name} بمتابعتك  ',
            id: 5,
            title: 'رساله جديده',
          );

          showDialog(
            context:
                NavigationService.navigatorKey.currentContext!,
            builder: (context) {
              return AlertDialog(
                backgroundColor:
                    const Color(0xFF2b2f3b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                content: Container(
                  child: Text(
                    '  قام ${followedUser.name} بمتابعتك  ',
                    style: style3.copyWith(
                      color: const Color(0xFFeae2be),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            Provider.of<FollowViewModel>(
                              context,
                              listen: false,
                            ).ReturnFollow(
                              context: NavigationService
                                  .navigatorKey
                                  .currentContext!,
                              Senderid: followedUser.id,
                            );

                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 80,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(20),
                              color:
                                  const Color(0xFFeae2be),
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
                              color:
                                  const Color(0xFFeae2be),
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                getLang(
                                  context: context,
                                  key: "Close",
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

        case 15:
          user.removeProfilebubles();
          break;

        case 16:
          user.UpdateProfilebubles(
            frames: data['data']['frame'],
          );
          break;

        case 17:
          LocalNotificationService().showNotification(
            body: 'تم حظر هذا الحساب',
            id: 2,
            title: 'رساله جديده',
          );

          Dialogs().showtoast(
            'تم حظر هذا الحساب',
          );

          SystemNavigator.pop();
          break;

        case 18:
          LocalNotificationService().showNotification(
            body: data['data']['message'],
            id: 8,
            title: 'رساله جديده',
          );
          break;

        default:
          print(
            'USER PUSHER: Unknown state received: $state',
          );
      }
    } catch (e, stackTrace) {
      print('========== USER PUSHER MENU ERROR ==========');
      print('STATE: $state');
      print('ERROR: $e');
      print('STACK TRACE:');
      print(stackTrace);
      print('============================================');
    }
  }
}