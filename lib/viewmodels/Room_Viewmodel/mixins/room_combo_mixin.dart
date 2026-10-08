import 'dart:async';

import 'package:flutter/material.dart';

import 'room_state_mixin.dart';

/// Lucky combo and win animations.
mixin RoomComboMixin on RoomStateMixin {
  void ShowLuckyCombo() {
    showcombo = true;
    Timercontroller.start();
    notifyListeners();
  }

  void HideLuckyCombo() {
    showcombo = false;
    Timercontroller.pause();
    notifyListeners();
  }

  void addCombo({
    int? id,
    image,
    image2,
    count,
  }) {
    var DDDD = Combouser.where((element) => element['uid'] == id);

    print('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');
    print(DDDD.toList());
    print('DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD');

    if (DDDD.toList().length != 0) {
      DDDD.first['count'] =
          int.parse(DDDD.first['count'].toString()) +
              int.parse(count.toString());
      DDDD.first['time'] = DateTime.now();
      notifyListeners();
    } else {
      Combouser.add({
        'uid': id,
        'time': DateTime.now(),
        'image': image,
        'count': count,
        'imagegift': image2,
      });

      if (Combouser.length > 0) {
        Timer.periodic(
          Duration(seconds: 2),
          (timer) {
            for (var i in Combouser) {
              if (DateTime.now().difference(i['time']).inSeconds > 6) {
                if (Combouser.length > 0) {
                  Combouser.remove(i);
                  notifyListeners();
                  break;
                }
              }
            }
          },
        );
      }
    }

    notifyListeners();
  }

  void addComboWin({
    persantage,
    amount,
  }) {
    Combowin.add({
      'time': DateTime.now(),
      'persantage': persantage,
      'amount': amount,
    });

    if (Combowin.length > 0) {
      Timer.periodic(
        Duration(seconds: 2),
        (timer) {
          for (var i in Combowin) {
            if (DateTime.now().difference(i['time']).inSeconds > 2) {
              if (Combowin.length > 0) {
                Combowin.remove(i);
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

  void clearcompo() {
    Combocost = null;
    ComboListuser = [];
    ComboQuantity = null;
    ComboGiftid = null;
  }
}
