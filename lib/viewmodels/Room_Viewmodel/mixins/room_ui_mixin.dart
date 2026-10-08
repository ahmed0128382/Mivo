import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:flutter/material.dart';
import 'room_state_mixin.dart';

/// Enter animation, ranks, and small UI helpers.
mixin RoomUiMixin on RoomStateMixin {
  void ShowEnterWidget({usermodel? Info}) {
    EnterUserinfo = Info;
    EnterOffser = -1;
    selected = true;
    notifyListeners();
  }

  void HideEnterWidget() {
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

  void SelectedLeader(val) {
    LeaderShipColor = LeaderShipColors[val];
    LeaderShipBack = LeaderShipBacks[val];
    SelectedRank = RankInmages[val];
    notifyListeners();
  }

  void GetSelectedCountry(FlagModel val) {
    SelectedCountry = val;
    // GetCountriRoom is in RoomListsMixin – called via the combined class
    notifyListeners();
  }

  void GetShowItem(item) {
    ShowItem = item;
    notifyListeners();
  }

  void FlagChose({flag}) {
    flagchoosen = flag;
    notifyListeners();
  }

  void FlagChose2({flag}) {
    flagchoosen2.clear();
    flagchoosen2.add(flag);
    notifyListeners();
  }

  void addnewchoosen2(value) {
    choosen2.add(value);
    notifyListeners();
  }

  void addflagchoosen2(value) {
    flagchoosen2.add(value);
    notifyListeners();
  }

  void addbackchhosen2({value}) {
    backchoosen2.add(value);
    notifyListeners();
  }

  void AddtoEdit() {
    backchoosen2.add(Currentroom?.nothostedimage);
    flagchoosen2.add(Currentroom?.city);
    choosen2.add(Currentroom?.Category);
    EditRoomName.text = Currentroom?.name ?? '';
    EditRoomDescription.text = Currentroom?.RoomAds ?? '';
    notifyListeners();
  }

  void clearadd2() {
    backchoosen2.clear();
    EditRoomName.clear();
    flagchoosen2.clear();
    // ClearImage2 / ClearImage3 live in create mixin if present
    choosen2.clear();
    notifyListeners();
  }

  void DisposeController() {
    controller?.dispose();
    notifyListeners();
  }

  void initscrollcontroller() {
    controller = ScrollController();
  }

  void cleanMessage() {
    // showloading7 is in loading mixin
    Message.clear();
    notifyListeners();
  }

  void ClearCurrentroom() {
    Currentroom = null;
    notifyListeners();
  }

  void removecurrentroom() {
    Currentroom?.id = 0654;
    notifyListeners();
  }

  void deleteroomchat() {
    Currentroom?.chatroom?.clear();
    notifyListeners();
  }

  void GetMentionid({String? id, String? name}) {
    Mentionid = id;
    MentionName = name;
  }

  void ClearMentionid() {
    Mentionid = null;
    MentionName = null;
  }

  void AddRolletchoice(String name) {
    Rolletchoice.add(name);
    notifyListeners();
  }

  void RemoveRolletchoice(String userinfo) {
    Rolletchoice.remove(userinfo);
    notifyListeners();
  }

  void AddMuted(id) {
    Mutedids.add(id);
    notifyListeners();
  }

  void AddUserIds({id}) {
    UserIds.add(id);
    notifyListeners();
  }

  void RemoveUserIds({id}) {
    UserIds.remove(id);
    notifyListeners();
  }

  void ClearUserIds() {
    UserIds.clear();
    notifyListeners();
  }
}
