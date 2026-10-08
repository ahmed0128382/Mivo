import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'room_loading_mixin.dart';
import 'room_state_mixin.dart';

/// Chair join / leave / change / lock / karisma.
mixin RoomChairMixin on RoomStateMixin, RoomLoadingMixin {
  void ChangeChairLock({int? State, String? chairId}) {
    Currentroom?.chairs?[int.parse(chairId ?? '0') - 1].Lock = State;
    notifyListeners();
  }

  void NulledKaresmaChair({String? chairId}) {
    Currentroom?.chairs?[int.parse(chairId ?? '0') - 1].Karisma = 0;
    notifyListeners();
  }

  void addKaresmaChair({String? chairId}) {
    Currentroom?.chairs?[int.parse(chairId ?? '0') - 1].Karisma = 100;
    notifyListeners();
  }

  void UpdateThronechair({int? value}) {
    Currentroom?.SecondKing = value;
    notifyListeners();
  }

  void Changemicestateadmin({userId, state, context}) async {
    Currentroom?.chairs?.forEach((element) async {
      if (element.userId == userId) {
        element.mute = state;
      }
    });
    notifyListeners();
  }

  bool checkmute() {
    var muted = false;
    Currentroom?.chairs?.forEach((element) {
      if (element.userId == UserId && element.mute == 0) {
        muted = false;
      } else if (element.userId == UserId && element.mute == 1) {
        muted = true;
      }
    });
    notifyListeners();
    return muted;
  }

  // PASTE full bodies from original:
  // JoinChair, ChangeChair, ChangeAdminsChair, ReturnAdminsChair,
  // LeaveChair, LeaveuserChair, AddusertoChair, LockChair,
  // ChangeRoomChair, returntoAdminRoomChair, RemoveuserfromChair,
  // LockChairUpdate, AddKaresmaChair, updatekaresma, ...

  JoinChair({context, index, chairid}) async {
    throw UnimplementedError('Paste JoinChair from original file');
  }

  ChangeChair({context, Index, Newchairid}) async {
    throw UnimplementedError('Paste ChangeChair from original file');
  }

  ChangeAdminsChair({context, Index, Newchairid}) async {
    throw UnimplementedError('Paste ChangeAdminsChair from original file');
  }

  ReturnAdminsChair({context, Index, Newchairid}) async {
    throw UnimplementedError('Paste ReturnAdminsChair from original file');
  }

  LeaveChair({context, chairid, index}) async {
    throw UnimplementedError('Paste LeaveChair from original file');
  }

  LeaveuserChair({context}) async {
    throw UnimplementedError('Paste LeaveuserChair from original file');
  }
}
