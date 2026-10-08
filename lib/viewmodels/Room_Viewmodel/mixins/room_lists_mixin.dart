import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:flutter/material.dart';

import 'room_loading_mixin.dart';
import 'room_state_mixin.dart';

/// All list-fetching methods (rooms, countries, leaderboards, etc.).
mixin RoomListsMixin on RoomStateMixin, RoomLoadingMixin {
  updateSelectedCategory({Category, context}) {
    SelectedRoomCategory = Category;
    GetRoom(context: context);
    notifyListeners();
  }

  GetRoom({context}) async {
    // TODO: Paste GetRoom from original
    throw UnimplementedError('Paste GetRoom from original file');
  }

  GetRoomKarisma({context}) async {
    ShowGlopalLoading();
    await Roomapi()
        .RoomsKarisma(context: context, room_id: Currentroom?.id)
        .then((value) {
      RoomLeader = value;
      notifyListeners();
      DismissGlopalLoading();
    });
  }

  GetCollectKarisma({context, userid, required chairid}) async {
    ShowGlopalLoading();
    await Roomapi()
        .GetCollectKarisma(
      context: context,
      room_id: Currentroom?.id,
      user_id: userid,
      chairid: chairid,
    )
        .then((value) {
      Collectkarismas = value;
      notifyListeners();
      DismissGlopalLoading();
    });
  }

  GetCountriRoom() async {
    // Called from GetSelectedCountry – paste body from original
    throw UnimplementedError('Paste GetCountriRoom from original file');
  }

  GetCountries(context) async {
    // TODO: Paste from original
    throw UnimplementedError('Paste GetCountries from original file');
  }

  GetMoreExploreRoom(context) async {
    showloading2 = true;
    await Roomapi().AddExploreRecommended(context).then((value) {
      value.forEach((element) {
        ExploreRooms.add(element);
      });
      hideSpinner2();
    });
    notifyListeners();
  }

  GetMoreRecommended(context) async {
    await Roomapi().AddmoreRecommended(context).then((value) {
      value.forEach((element) {
        RecomendedRoom.add(element);
      });
      hideSpinner2();
    });
    notifyListeners();
  }

  // Add any other Get* methods from original here:
  // GetNewRooms, GetRecomended, GetRecomended2, GetFixedRoom,
  // GetRoomUserFollowing, leaderboard methods, etc.
}
