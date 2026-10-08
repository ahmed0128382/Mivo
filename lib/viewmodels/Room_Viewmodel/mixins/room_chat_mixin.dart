import 'dart:async';
import 'package:ahlachat/main.dart';

import 'package:ahlachat/models/guessGameModel.dart';

import 'package:ahlachat/util/helperclass.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'room_state_mixin.dart';

mixin RoomChatMixin on RoomStateMixin {
  AddChatRoom({
  required Chatroom message,
}) {
  print('');
  print('========== ADD CHAT ROOM ==========');
  print('MESSAGE ID: ${message.id}');
  print('MESSAGE USER ID: ${message.userId}');
  print('MESSAGE ROOM ID: ${message.roomId}');
  print('MESSAGE CONTENT: ${message.content}');
  print('MESSAGE USER: ${message.user?.name}');
  print(
    'CHAT COUNT BEFORE: ${Currentroom?.chatroom?.length}',
  );

  Currentroom?.chatroom?.add(message);

  print(
    'CHAT COUNT AFTER: ${Currentroom?.chatroom?.length}',
  );

  int onec = 1;

  Timer.periodic(
    const Duration(seconds: 1),
    (timer) {
      if (onec < 2) {
        print(onec);

        if (controller?.hasClients ?? false) {
          controller?.animateTo(
            controller?.position.maxScrollExtent ?? 0,
            curve: Curves.easeOut,
            duration: const Duration(
              milliseconds: 500,
            ),
          );
        }
      }

      onec++;
    },
  );

  notifyListeners();

  print('========== ADD CHAT DONE ==========');
}

  AddGuessGame({
    winnerid,
    guessgamemodel? guess,
  }) {
    guesses.add({
      'winnerid': winnerid,
      'time': DateTime.now(),
      'guess': guess,
    });

    if (guesses.length > 0) {
      Timer.periodic(
        Duration(seconds: 1),
        (timer) {
          for (var i in guesses) {
            if (DateTime.now()
                    .difference(i['time'])
                    .inSeconds >
                3) {
              if (guesses.length > 0) {
                guesses.remove(i);
                notifyListeners();
                break;
              }
            }
          }
        },
      );
    }

    notifyListeners();
  }

  ChangeGuessGame({
    guessgamemodel? Guess,
    winnerid,
  }) {
    Currentroom?.chatroom
        ?.where(
          (element) =>
              element.id == Guess?.id,
        )
        .first
        .Guess = Guess;

    notifyListeners();
  }

  Getmaxchat() {
    int onec = 1;

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (onec < 2) {
          print(onec);
          print('dasdsa');

          if (controller?.hasClients ??
              false) {
            controller?.animateTo(
              controller
                      ?.position
                      .maxScrollExtent ??
                  0,
              curve: Curves.easeOut,
              duration:
                  const Duration(
                milliseconds: 500,
              ),
            );
          }
        }

        onec++;
      },
    );

    notifyListeners();
  }

  Addmessagetocurrentroom({
    message,
  }) {
    int onec = 1;

    Currentroom?.chatroom?.add(
      message,
    );

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (onec < 2) {
          if (controller?.hasClients ??
              false) {
            controller?.animateTo(
              controller
                      ?.position
                      .maxScrollExtent ??
                  0,
              curve: Curves.easeOut,
              duration:
                  const Duration(
                milliseconds: 500,
              ),
            );
          }
        }

        onec++;
      },
    );

    notifyListeners();
  }

  sendMessageChat({
    content,
  }) async {
    await Roomapi()
        .sendmessage(
      Roomid: Currentroom?.id,
      content: content,
    )
        .then(
      (value) {},
    );
  }

  sendMentionChat({
    content,
  }) async {
    await Roomapi()
        .sendMention(
      Reciver_id: Mentionid,
      Roomid: Currentroom?.id,
      content: content,
    )
        .then(
      (value) {},
    );
  }

  Addinsults({
    context,
    type,
    message,
  }) async {
    print('reunasdasdasd');

    await Roomapi()
        .Addinsults(
      context: context,
      message: message,
      type: type,
    )
        .then(
      (value) {
        if (value == true) {
          print('trueeeeeeeeeeee');
        } else {
          print('faaalssssssssss');
        }
      },
    );
  }

  deletechat({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .deleteChatRoom(
      context: context,
      RoomID: Currentroom?.id,
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

}
