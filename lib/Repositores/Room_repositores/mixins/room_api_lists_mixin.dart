import 'package:ahlachat/Repositores/Moment_repositores/Moment_api.dart';
import 'package:ahlachat/Repositores/Room_repositores/Room_api.dart' hide Index;
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/Kickedusers.dart';
import 'package:ahlachat/models/Leaderboardroommodel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/Weeklystarmodel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';
/// Shared error helpers for Roomapi import 'room_api_error_mixin.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiListsMixin on RoomApiStateMixin {
  Future<List<RoomModel>> Rooms(context) async {
    Index = 2;
    ImportantRooms.clear();

    try {
      final Response response2 = await dio.get(
        '/api/GetRooms/$SelectedRoomCategory',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET ROOMS ERROR: $exception');
    }

    return ImportantRooms;
  }

  Future<List<RoomModel>> getFixedRooms(context) async {
    try {
      FixedRooms.clear();

      final Response response2 = await dio.get(
        '/api/GetFixedRoom',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms'] ?? [];

        for (final element in list) {
          FixedRooms.add(
            RoomModel.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET FIXED ROOMS ERROR: $exception');
    }

    return FixedRooms;
  }

  Future<List<RoomModel>> SearchRooms(
    context,
    tittle,
  ) async {
    try {
      final query =
          tittle?.toString().trim() ?? '';

      if (query.isEmpty) {
        return ImportantRooms;
      }

      final Response response2 = await dio.get(
        '/api/SearchRoom/$query',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms'] ?? [];

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(ImportantRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('SEARCH ROOMS ERROR: $exception');

      showError(e, context);
    }

    return ImportantRooms;
  }

  Future<List<RoomModel>> GetFollowedRooms(
    context,
  ) async {
    print(UserId);

    final List<RoomModel> FollowedRoom = [];

    try {
      final Response response2 = await dio.get(
        '/api/GetFollowRoom/$UserId',
      );

      print(response2.data);

      if (response2.statusCode == 200) {
        final List list =
            response2.data['FollowRoom'] ?? [];

        for (final element in list) {
          final room = element['room'];

          if (room != null) {
            FollowedRoom.add(
              RoomModel.fromJson(room),
            );
          }
        }

        print(FollowedRoom);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET FOLLOWED ROOMS ERROR: $exception');

      showError(e, context);
    }

    return FollowedRoom;
  }

  Future<List<RoomModel>> AddmoreRooms(
    context,
  ) async {
    try {
      final Response response2 = await dio.get(
        '/api/GetRooms/'
        '$SelectedRoomCategory?page=$Index',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        if (list.isNotEmpty) {
          Index++;
        }

        print('INDEX IS $Index');

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(ImportantRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET MORE ROOMS ERROR: $exception');

      showError(e, context);
    }

    return ImportantRooms;
  }

  Future<List<RoomModel>> AddmoreRecommended(
    context,
  ) async {
    try {
      final Response response2 = await dio.get(
        '/api/GetRecomended?page=$IndexRecommended',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        if (list.isNotEmpty) {
          IndexRecommended++;
        }

        print('INDEX IS $IndexRecommended');

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(ImportantRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET MORE RECOMMENDED ROOMS ERROR: $exception');

      showError(e, context);
    }

    return ImportantRooms;
  }

  Future<List<RoomModel>> AddExploreRecommended(
    context,
  ) async {
    try {
      final Response response2 = await dio.get(
        '/api/GetRecomended2?page=$IndexRecommended2',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        if (list.isNotEmpty) {
          IndexRecommended2++;
        }

        print('INDEX IS $IndexRecommended2');

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(ImportantRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'GET MORE EXPLORE RECOMMENDED ROOMS ERROR: '
        '$exception',
      );

      showError(e, context);
    }

    return ImportantRooms;
  }

  Future<List<RoomModel>> FoolowingUserRooms(
    context,
  ) async {
    try {
      final Response response2 = await dio.get(
        '/api/GetRoomUserFollowing/$UserId',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms'] ?? [];

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(ImportantRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET FOLLOWING USER ROOMS ERROR: $exception');
    }

    return ImportantRooms;
  }

  Future<List<RoomModel>> RecommendedRooms(
    context,
  ) async {
    IndexRecommended = 2;
    ImportantRooms.clear();

    try {
      final Response response2 = await dio.get(
        '/api/GetRecomended',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(ImportantRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET RECOMMENDED ROOMS ERROR: $exception');

      showError(e, context);
    }

    return ImportantRooms;
  }

  Future<List<RoomModel>> ExploreRooms(
    context,
  ) async {
    IndexRecommended2 = 2;
    ImportantRooms.clear();

    try {
      final Response response2 = await dio.get(
        '/api/GetRecomended2',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(ImportantRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET EXPLORE ROOMS ERROR: $exception');

      showError(e, context);
    }

    return ImportantRooms;
  }

  Future<List<RoomModel>> CountryRooms({
    Country,
  }) async {
    IndexRecommended2 = 2;

    try {
      final Response response2 = await dio.get(
        '/api/GetCountryRooms/$Country',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        for (final element in list) {
          ImportantRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(ImportantRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET COUNTRY ROOMS ERROR: $exception');
    }

    return ImportantRooms;
  }

  Future<List<FlagModel>> GetCountries(
    context,
  ) async {
    try {
      Countries.clear();

      final Response response2 = await dio.get(
        '/api/GetCountries',
      );

      if (response2.statusCode == 200) {
        final List list = response2.data ?? [];

        for (final element in list) {
          Countries.add(
            FlagModel.fromJson(element),
          );
        }

        print(Countries);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET COUNTRIES ERROR: $exception');

      showError(e, context);
    }

    return Countries;
  }

  Future<List<RoomModel>> NewRooms(
    context,
  ) async {
    try {
      TradeRooms.clear();

      final Response response2 = await dio.get(
        '/api/GetNewRooms',
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        for (final element in list) {
          TradeRooms.add(
            RoomModel.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET NEW ROOMS ERROR: $exception');
    }

    return TradeRooms;
  }

  Future<List<RoomModel>> GetMoreTrendRoom(
    context,
  ) async {
    try {
      final Response response2 = await dio.get(
        '/api/GetNewRooms?page=$IndexTrade',
      );

      print(response2.data);

      if (response2.statusCode == 200) {
        final List list =
            response2.data['Rooms']?['data'] ?? [];

        if (list.isNotEmpty) {
          IndexTrade++;
        }

        print('INDEX IS $IndexTrade');

        for (final element in list) {
          TradeRooms.add(
            RoomModel.fromJson(element),
          );
        }

        print(TradeRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET MORE TREND ROOMS ERROR: $exception');
    }

    return TradeRooms;
  }

  Future<List<KickedUser>> KickedUserRooms({
    context,
    roomid,
  }) async {
    try {
      KickeduserRooms.clear();

      final Response response2 = await dio.get(
        '/api/getkickeduser/$roomid',
      );

      if (response2.statusCode == 200) {
        final List list = response2.data ?? [];

        for (final element in list) {
          KickeduserRooms.add(
            KickedUser.fromJson(element),
          );
        }

        print(KickeduserRooms);
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET KICKED USERS ERROR: $exception');
    }

    return KickeduserRooms;
  }

  Future<bool> CheckPassworRooms({
    id,
  }) async {
    bool PasswordRoom = false;

    try {
      final Response response2 = await dio.get(
        '/api/CheckPasswordRoomnew/$id',
      );

      PasswordRoom = response2.statusCode == 200;
    } catch (e) {
      final exception = handleError(e);

      print('CHECK ROOM PASSWORD ERROR: $exception');
    }

    return PasswordRoom;
  }

  Future<bool> EnterCheckPassworRooms({
    id,
    pass,
  }) async {
    bool PasswordRoom = false;

    try {
      final Response response2 = await dio.get(
        '/api/CheckPasswordright/$id/$pass',
      );

      PasswordRoom = response2.statusCode == 200;
    } catch (e) {
      final exception = handleError(e);

      print(
        'CHECK ROOM PASSWORD RIGHT ERROR: '
        '$exception',
      );
    }

    return PasswordRoom;
  }

  Future<ListoflEaderboardcategoryRoom?>
      getRoomLeaderboard(
    context,
  ) async {
    ListoflEaderboardcategoryRoom?
        LeaderboardRoom;

    try {
      final Response response2 = await dio.get(
        '/api/GetRoomLeaderboard',
      );

      if (response2.statusCode == 200) {
        final data =
            response2.data['Leaderboard']?['Room'];

        if (data != null) {
          LeaderboardRoom =
              ListoflEaderboardcategoryRoom.fromJson(
            data,
          );
        }
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET ROOM LEADERBOARD ERROR: $exception');
    }

    return LeaderboardRoom;
  }

  Future<ListoflEaderboardcategory?>
      getGiverLeaderboard(
    context,
  ) async {
    ListoflEaderboardcategory?
        Leaderboardsupporter;

    try {
      final Response response2 = await dio.get(
        '/api/GetGiverLeaderboard',
      );

      if (response2.statusCode == 200) {
        final data =
            response2.data['Leaderboard']?['supporter'];

        if (data != null) {
          Leaderboardsupporter =
              ListoflEaderboardcategory.fromJson(
            data,
          );
        }
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET GIVER LEADERBOARD ERROR: $exception');
    }

    return Leaderboardsupporter;
  }

  Future<WeeklyStarModel?> GetWeeklystar(
    context,
  ) async {
    WeeklyStarModel? Leaderboardsupporter;

    try {
      final Response response2 = await dio.get(
        '/api/GetsupporterWeeklyStar',
      );

      print(response2.data['supporteds']);

      if (response2.statusCode == 200) {
        Leaderboardsupporter =
            WeeklyStarModel.fromJson(
          response2.data,
        );
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET WEEKLY STAR ERROR: $exception');
    }

    return Leaderboardsupporter;
  }

  Future<ListoflEaderboardFamilycategory?>
      getFamilyLeaderboard(
    context,
  ) async {
    ListoflEaderboardFamilycategory?
        Leaderboardsupporter;

    try {
      final Response response2 = await dio.get(
        '/api/GetFamilyLeaderboard',
      );

      if (response2.statusCode == 200) {
        final data =
            response2.data['Leaderboard']?['Family'];

        if (data != null) {
          Leaderboardsupporter =
              ListoflEaderboardFamilycategory.fromJson(
            data,
          );

          print(
            Leaderboardsupporter.weeklysupporter?.length,
          );
        }
      }
    } catch (e) {
      final exception = handleError(e);

      print('GET FAMILY LEADERBOARD ERROR: $exception');
    }

    return Leaderboardsupporter;
  }

  Future<ListoflEaderboardcategory?>
      getReciverLeaderboard(
    context,
  ) async {
    ListoflEaderboardcategory?
        Leaderboardsupported;

    try {
      final Response response2 = await dio.get(
        '/api/GetReciverLeaderboard',
      );

      if (response2.statusCode == 200) {
        final data =
            response2.data['Leaderboard']?['Recipient'];

        if (data != null) {
          Leaderboardsupported =
              ListoflEaderboardcategory.fromJson(
            data,
          );
        }
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'GET RECIVER LEADERBOARD ERROR: '
        '$exception',
      );
    }

    return Leaderboardsupported;
  }

}
