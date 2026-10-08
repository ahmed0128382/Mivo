import 'dart:async';
import 'dart:io';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/SearchScrean/widgets/SearchRoom.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'room_state_mixin.dart';
import 'room_loading_mixin.dart';

mixin RoomListsMixin on RoomStateMixin, RoomLoadingMixin {
  updateSelectedCategory({
    Category,
    context,
  }) {
    SelectedRoomCategory = Category;
    GetRoom(context: context);
    notifyListeners();
  }

  GetRoomKarisma({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .RoomsKarisma(
      context: context,
      room_id: Currentroom?.id,
    )
        .then(
      (value) {
        RoomLeader = value;
        notifyListeners();
        DismissGlopalLoading();
      },
    );
  }

  GetCollectKarisma({
    context,
    userid,
    required chairid,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .GetCollectKarisma(
      context: context,
      room_id: Currentroom?.id,
      user_id: userid,
      chairid: chairid,
    )
        .then(
      (value) {
        Collectkarismas = value;
        notifyListeners();
        DismissGlopalLoading();
      },
    );
  }

  GetNewRoom({
    context,
  }) async {
    if (NewRooms.isEmpty) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .NewRooms(context)
        .then(
      (value) {
        NewRooms = value;
        print(NewRooms.length);
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetRoomLeaderboard({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .getRoomLeaderboard(context)
        .then(
      (value) {
        LeaderboardRoom = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetGiverLeaderboard({
    context,
  }) async {
    GetGiverLeadestatr = true;

    if (!isCallGiver) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .getGiverLeaderboard(context)
        .then(
      (value) {
        isCallGiver = true;
        LeaderboardSupporter = value;
        GetGiverLeadestatr = false;

        print(
          LeaderboardSupporter
              ?.monthlysupporter
              ?.length,
        );

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetWeeklyStar({
    context,
  }) async {
    if (WeeklyStar == null) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .GetWeeklystar(context)
        .then(
      (value) {
        WeeklyStar = value;

        print(
          'WeeklyStar?.supporteds?.length'
          'WeeklyStar?.supporteds?.length',
        );

        print(
          WeeklyStar?.supporteds?.length,
        );

        print(
          WeeklyStar?.supporters?.length,
        );

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetFamilyLeaderboard({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .getFamilyLeaderboard(context)
        .then(
      (value) {
        LeaderboardFamily = value;

        print(
          LeaderboardFamily
              ?.weeklysupporter
              ?.length,
        );

        print(
          LeaderboardFamily
              ?.dailysupporter
              ?.length,
        );

        print(
          LeaderboardFamily
              ?.monthlysupporter
              ?.length,
        );

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetReciverLeaderboard({
    context,
  }) async {
    print(
      'GetReciverLeaderboard',
    );

    if (!isCallReciver) {
      ShowGlopalLoading();
    }

    GetReciverLeadestatr = true;

    await Roomapi()
        .getReciverLeaderboard(context)
        .then(
      (value) {
        Leaderboardsupported = value;
        GetReciverLeadestatr = false;
        isCallReciver = true;

        print(
          Leaderboardsupported
              ?.monthlysupporter
              ?.length,
        );

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetMoreNewRoom(context) async {
    showSpinner2();

    await Roomapi()
        .GetMoreTrendRoom(context)
        .then(
      (value) {
        value.forEach(
          (element) {
            NewRooms.add(element);
          },
        );

        print(NewRooms.length);
        hideSpinner2();
      },
    );

    notifyListeners();
  }

  GetRoom({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .Rooms(context)
        .then(
      (value) {
        Rooms = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetFixedRoom({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .getFixedRooms(context)
        .then(
      (value) {
        FixedRooms = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  SearchGetRoom({
    context,
    text,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .SearchRooms(
      context,
      text,
    )
        .then(
      (value) {
        SearchRooms = value;

        navigateTo(
          context: context,
          screen: SearchRoom(),
        );

        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetFollowedRoom({
    context,
  }) async {
    hideSpinner46();

    await Roomapi()
        .GetFollowedRooms(context)
        .then(
      (value) {
        FollowedRooms = value;
        showSpinner46();
      },
    );

    notifyListeners();
  }

  GetMoreRoom(context) async {
    showSpinner2();

    await Roomapi()
        .AddmoreRooms(context)
        .then(
      (value) {
        value.forEach(
          (element) {
            Rooms.add(element);
          },
        );

        print(Rooms.length);
        hideSpinner2();
      },
    );

    notifyListeners();
  }

  GetFollowingUserRoom(context) async {
    if (FollowingUserRooms.isEmpty) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .FoolowingUserRooms(context)
        .then(
      (value) {
        ShowGlopalLoading();

        FollowingUserRooms = value;

        print(
          FollowingUserRooms.length,
        );

        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetRecommendedRoom(context) async {
    await Roomapi()
        .RecommendedRooms(context)
        .then(
      (value) {
        RecomendedRoom = value;

        print(
          FollowingUserRooms.length,
        );

        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetExploreRoom(context) async {
    if (ExploreRooms.isEmpty) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .ExploreRooms(context)
        .then(
      (value) {
        ExploreRooms = value;

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetCountriRoom() async {
    ShowGlopalLoading();

    await Roomapi()
        .CountryRooms(
      Country: SelectedCountry?.name,
    )
        .then(
      (value) {
        CountryRoom = value;

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetCountries(context) async {
    await Roomapi()
        .GetCountries(context)
        .then(
      (value) {
        Countries = value;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetMoreExploreRoom(context) async {
    showloading2 = true;

    await Roomapi()
        .AddExploreRecommended(context)
        .then(
      (value) {
        value.forEach(
          (element) {
            ExploreRooms.add(element);
          },
        );

        hideSpinner2();
      },
    );

    notifyListeners();
  }

  GetMoreRecommended(context) async {
    await Roomapi()
        .AddmoreRecommended(context)
        .then(
      (value) {
        value.forEach(
          (element) {
            RecomendedRoom.add(element);
          },
        );

        hideSpinner2();
      },
    );

    notifyListeners();
  }

  Future getChatRoomImage() async {
    bool selected = false;

    final pickedFile =
        await picker2.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      ChatRoomImage = File(
        pickedFile.path,
      );

      selected = true;

      notifyListeners();
    } else {
      selected = false;
    }

    notifyListeners();

    return selected;
  }

}
