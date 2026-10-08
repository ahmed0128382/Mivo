import 'dart:async';
import 'package:ahlachat/models/FlagModel.dart';

import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';
import 'room_state_mixin.dart';
import 'room_lists_mixin.dart';

mixin RoomUiMixin on RoomStateMixin, RoomListsMixin {
  ShowEnterWidget({
    usermodel? Info,
  }) {
    EnterUserinfo = Info;
    EnterOffser = -1;
    selected = true;
    notifyListeners();
  }

  HideEnterWidget() {
    if (EnterOffser == -10.5) {
      EnterOffser = 6.0;
    } else {
      EnterOffser = -10.5;

      Future.delayed(
        Duration(milliseconds: 500),
        () {
          selected = false;
        },
      );
    }

    notifyListeners();
  }

SelectedLeader(val) {
    LeaderShipColor = LeaderShipColors[val];
    LeaderShipBack = LeaderShipBacks[val];
    SelectedRank = RankInmages[val];
    notifyListeners();
  }

  GetSelectedCountry(FlagModel val) {
    SelectedCountry = val;
    GetCountriRoom();
    notifyListeners();
  }

  FlagChose({flag}) {
    flagchoosen = flag;
    notifyListeners();
  }

  FlagChose2({flag}) {
    flagchoosen2.clear();
    flagchoosen2.add(flag);
    notifyListeners();
  }

  GetShowItem(item) {
    ShowItem = item;
    notifyListeners();
  }

  deleteroomchat() {
    Currentroom?.chatroom?.clear();
    notifyListeners();
  }

  removecurrentroom() {
    Currentroom?.id = 0654;
    notifyListeners();
  }

  addnewchoosen2(value) {
    choosen2.add(value);
    notifyListeners();
  }

  addflagchoosen2(value) {
    flagchoosen2.add(value);
    notifyListeners();
  }

  addbackchhosen2({value}) {
    backchoosen2.add(value);
    notifyListeners();
  }

  AddtoEdit() {
    backchoosen2.add(
      Currentroom?.nothostedimage,
    );

    flagchoosen2.add(
      Currentroom?.city,
    );

    choosen2.add(
      Currentroom?.Category,
    );

    EditRoomName.text =
        Currentroom?.name ?? '';

    EditRoomDescription.text =
        Currentroom?.RoomAds ?? '';

    notifyListeners();
  }

  clearadd2() {
    backchoosen2.clear();
    EditRoomName.clear();
    flagchoosen2.clear();
    Roomimage2 = null;
    Roomimage3 = null;
    choosen2.clear();
    notifyListeners();
  }

  DisposeController() {
    controller?.dispose();
    notifyListeners();
  }

  closealltap() {
    showloading14 = false;
    showloading17 = false;
    showloading18 = false;
    showloading19 = false;
    showloading8 = false;
    showloading21 = false;
    showloading39 = false;
    showloading40 = false;
    notifyListeners();
  }

  AddUserIds({id}) {
    GiftsViewModel gits =
        Provider.of<GiftsViewModel>(
      roomcontext,
      listen: false,
    );

    UserIds.add(id);

    if (gits.GiftList.isNotEmpty) {
      gits.addtogiftlist(
        value: gits.GiftList.first,
        costs:
            (int.parse(
                  gits.SentValue.toString(),
                ) *
                gits.GiftList.first['price'])
            .toInt() *
            UserIds.length,
      );
    }

    notifyListeners();
  }

  RemoveUserIds({id}) {
    UserIds.remove(id);

    GiftsViewModel gits =
        Provider.of<GiftsViewModel>(
      roomcontext,
      listen: false,
    );

    if (gits.GiftList.isNotEmpty) {
      gits.addtogiftlist(
        value: gits.GiftList.first,
        costs:
            (int.parse(
                  gits.SentValue.toString(),
                ) *
                gits.GiftList.first['price'])
            .toInt() *
            UserIds.length,
      );
    }

    notifyListeners();
  }

  ClearUserIds() {
    UserIds.clear();
    notifyListeners();
  }

  ClearCurrentroom() {
    Currentroom = null;
    notifyListeners();
  }

  cleanMessage() {
    showloading7 = false;
    Message.clear();
    notifyListeners();
  }

  AddMuted(id) {
    Mutedids.add(id);
    notifyListeners();
  }

  initscrollcontroller() {}

  GetMentionid({
    String? id,
    String? name,
  }) {
    Mentionid = id;
    MentionName = name;
  }

  ClearMentionid() {
    Mentionid = null;
    MentionName = null;
  }

  AddRolletchoice(String name) {
    Rolletchoice.add(name);
    notifyListeners();
  }

  RemoveRolletchoice(String userinfo) {
    Rolletchoice.remove(userinfo);
    notifyListeners();
  }

  showwaitingtimer2() {
    waitingtimer2 = true;
    notifyListeners();
  }

  hidewaitingtimer2() {
    waitingtimer2 = false;
    notifyListeners();
  }

  showwaitingtimer() {
    waitingtimer = true;
  }

  hidewaitingtimer() {
    waitingtimer = false;
    notifyListeners();
  }

}
