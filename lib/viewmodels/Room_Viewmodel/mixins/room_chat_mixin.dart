import 'dart:async';

import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/models/guessGameModel.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:flutter/material.dart';

import 'room_state_mixin.dart';

/// Chat, messages, mentions, guess game.
mixin RoomChatMixin on RoomStateMixin {
  AddChatRoom({required Chatroom message}) {
    int onec = 1;
    Currentroom?.chatroom?.add(message);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (onec < 2) {
        if (controller?.hasClients ?? false) {
          controller?.animateTo(
            controller?.position.maxScrollExtent ?? 0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
      onec++;
    });
    notifyListeners();
  }

  Addmessagetocurrentroom({message}) {
    int onec = 1;
    Currentroom?.chatroom?.add(message);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (onec < 2) {
        if (controller?.hasClients ?? false) {
          controller?.animateTo(
            controller?.position.maxScrollExtent ?? 0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
      onec++;
    });
    notifyListeners();
  }

  Getmaxchat() {
    int onec = 1;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (onec < 2) {
        if (controller?.hasClients ?? false) {
          controller?.animateTo(
            controller?.position.maxScrollExtent ?? 0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
      onec++;
    });
    notifyListeners();
  }

  SendMessageChat({content}) async {
    await Roomapi().sendmessage(Roomid: Currentroom?.id, content: content);
  }

  SendMentionChat({content}) async {
    await Roomapi().sendMention(
      Reciver_id: Mentionid,
      Roomid: Currentroom?.id,
      content: content,
    );
  }

  AddGuessGame({winnerid, guessgamemodel? guess}) {
    guesses.add({
      'winnerid': winnerid,
      'time': DateTime.now(),
      'guess': guess,
    });
    if (guesses.length > 0) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        for (var i in guesses) {
          if (DateTime.now().difference(i['time']).inSeconds > 3) {
            if (guesses.length > 0) {
              guesses.remove(i);
              notifyListeners();
              break;
            }
          }
        }
      });
    }
    notifyListeners();
  }

  ChangeGuessGame({guessgamemodel? Guess, winnerid}) {
    Currentroom?.chatroom
        ?.where((element) => element.id == Guess?.id)
        .first
        .Guess = Guess;
    notifyListeners();
  }

  deletechat({context}) async {
    // TODO: Paste full deletechat if needed
    throw UnimplementedError('Paste deletechat from original file');
  }

  Addinsults({context, type, message}) async {
    await Roomapi().Addinsults(
      context: context,
      message: message,
      type: type,
    );
  }
}
