import 'dart:io';

import 'package:ahlachat/Repositores/Room_repositores/Room_repository.dart';
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
import 'package:ahlachat/models/Leaderboardroommodel.dart';
import 'package:ahlachat/models/Weeklystarmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/ChairModel.dart';
import '../../models/JoinRoomModel.dart';
import '../../models/Kickedusers.dart';
import '../../models/Leaderboardusermodel.dart';
import '../../models/RoomKarismaModel.dart';
import '../../models/RoomModel.dart';
import '../../models/SupervisorsModel.dart';
import '../../models/gifts.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

int Index = 2;
int IndexTrade = 2;
int IndexRecommended = 2;
int IndexRecommended2 = 2;

class Roomapi extends RoomRepository {
  final Dio dio = ApiClient.instance.dio;

  List<RoomModel> ImportantRooms = [];
  List<FlagModel> Countries = [];
  List<RoomModel> FixedRooms = [];
  List<RoomModel> TradeRooms = [];
  List<KickedUser> KickeduserRooms = [];
  List<joinRoom> joinuserRooms = [];

  RoomModel Roominfo = RoomModel();

  final List<KarismaCollectModel> karismas = [];
  final List<Gifts> RoomGifts = [];
  final List<Supervisors> SupervisorRoom = [];

  // ============================================================
  // ERROR HANDLING
  // ============================================================

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      final responseData = response?.data;

      String message = 'Something went wrong';

      if (responseData is Map) {
        message =
            responseData['message']?.toString() ??
            responseData['msg']?.toString() ??
            responseData['error']?.toString() ??
            responseData['errNum']?.toString() ??
            message;
      } else if (error.message != null &&
          error.message!.trim().isNotEmpty) {
        message = error.message!;
      }

      return ApiException(
        statusCode: response?.statusCode,
        message: message,
        data: responseData,
      );
    }

    if (error is ApiException) {
      return error;
    }

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }

  dynamic _errorData(dynamic error) {
    if (error is DioException) {
      return error.response?.data;
    }

    if (error is ApiException) {
      return error.data;
    }

    return null;
  }

  dynamic _errorNumber(dynamic error) {
    final data = _errorData(error);

    if (data is Map) {
      return data['errNum'];
    }

    return null;
  }

  void _showRegisterError(dynamic error, context) {
    final errNum = _errorNumber(error);

    if (errNum != null && context != null) {
      Dialogs().ShowErrorRegesterToast(
        errNum,
        context,
      );
    }
  }

  void _showError(dynamic error, context) {
    final data = _errorData(error);

    if (data is Map) {
      final errNum = data['errNum'];

      if (errNum != null && context != null) {
        Dialogs().ShowErrorToast(
          errNum,
          context,
        );
      }
    }
  }

  // ============================================================
  // ROOM CHAIR
  // ============================================================

  Future<bool> Updatemute({
    room_id,
    user_id,
    context,
    state,
  }) async {
    bool Mute = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': user_id.toString(),
        'state': int.parse(state.toString()),
        'room_id': room_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/updatemutechair',
        data: formData,
      );

      Mute = response2.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);

      print('UPDATEMUTE ERROR: $exception');
    }

    return Mute;
  }

  Future<RoomModel> UpdateRoom({
    name,
    roomid,
    image,
    backimage,
    Category,
    lock,
    password,
    RoomAds,
  }) async {
    try {
      print({
        'name': name.toString(),
        'password': password,
        'Category': Category,
        'animateimage': backimage,
        'room_id': roomid.toString(),
        'RoomAds': RoomAds.toString(),
      });

      dynamic map;

      if (image == null) {
        map = {
          'name': name.toString(),
          'password': password,
          'Category': Category,
          'animateimage': backimage,
          'room_id': roomid.toString(),
          'RoomAds': RoomAds.toString(),
        };
      } else {
        map = {
          'name': name.toString(),
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
          'password': password,
          'Category': Category,
          'animateimage': backimage,
          'room_id': roomid.toString(),
          'RoomAds': RoomAds.toString(),
        };
      }

      map.removeWhere(
        (key, value) => key == null || value == null,
      );

      final FormData formData = FormData.fromMap(map);

      final Response response2 = await dio.post(
        '/api/UpdateRoom',
        data: formData,
      );

      if (response2.statusCode == 200) {
        final room = response2.data['Room'];

        if (room != null) {
          Roominfo = RoomModel.fromJson(room);
        }
      }
    } catch (e) {
      final exception = _handleError(e);

      print('UPDATE ROOM ERROR: $exception');
    }

    return Roominfo;
  }

  Future<bool> UnkickeuserRoom({
    kickid,
    context,
  }) async {
    bool states = false;

    try {
      final FormData formData = FormData.fromMap({
        'kick_id': kickid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/unkickuser',
        data: formData,
      );

      states =
          response2.statusCode == 200 ||
          response2.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);

      print('UNKICK USER ERROR: $exception');

      _showRegisterError(e, context);
    }

    return states;
  }

  Future<bool> UpdateThroneChair({
    room_id,
    State,
    context,
  }) async {
    bool states = false;

    try {
      final FormData formData = FormData.fromMap({
        'room_id': room_id.toString(),
        'status': State.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SetThroneChair',
        data: formData,
      );

      states =
          response2.statusCode == 200 ||
          response2.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);

      print('UPDATE THRONE CHAIR ERROR: $exception');

      _showRegisterError(e, context);
    }

    return states;
  }

  Future<bool> SendInviteChairRoom({
    roomid,
    userid,
    context,
  }) async {
    bool states = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': userid.toString(),
        'room_id': roomid.toString(),
        'chair_id': InviteChairId.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SentInviteChair',
        data: formData,
      );

      states =
          response2.statusCode == 200 ||
          response2.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);

      print('SEND INVITE CHAIR ERROR: $exception');
    }

    return states;
  }

  Future<bool> deleteChatRoom({
    RoomID,
    context,
  }) async {
    bool states = false;

    try {
      final FormData formData = FormData.fromMap({
        'room_id': RoomID.toString(),
      });

      final Response response2 = await dio.post(
        '/api/DeleteRoomChat',
        data: formData,
      );

      states =
          response2.statusCode == 200 ||
          response2.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);

      print('DELETE ROOM CHAT ERROR: $exception');

      _showRegisterError(e, context);
    }

    return states;
  }

  Future<bool> SetRoomPssword({
    roomid,
    password,
    context,
  }) async {
    bool states = false;

    try {
      final FormData formData = FormData.fromMap({
        'password': password.toString(),
        'room_id': roomid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SetPasswordRoom',
        data: formData,
      );

      states =
          response2.statusCode == 200 ||
          response2.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);

      print('SET ROOM PASSWORD ERROR: $exception');

      _showRegisterError(e, context);
    }

    return states;
  }

  Future<bool> RemoveRoomPssword({
    roomid,
    context,
  }) async {
    bool states = false;

    try {
      final FormData formData = FormData.fromMap({
        'room_id': roomid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/RemovePasswordRoom',
        data: formData,
      );

      states =
          response2.statusCode == 200 ||
          response2.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);

      print('REMOVE ROOM PASSWORD ERROR: $exception');

      _showRegisterError(e, context);
    }

    return states;
  }

  Future<List<joinRoom>> Roomsjoinuser({
    context,
    room_id,
  }) async {
    try {
      joinuserRooms.clear();

      final FormData formData = FormData.fromMap({
        'room_id': room_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Getjoinusers',
        data: formData,
      );

      print(response2.data['join']);

      if (response2.statusCode == 200) {
        final List list = response2.data['join'] ?? [];

        for (final element in list) {
          joinuserRooms.add(
            joinRoom.fromJson(element),
          );
        }

        print(joinuserRooms);
      }
    } catch (e) {
      final exception = _handleError(e);

      print('GET JOIN USERS ERROR: $exception');

      _showError(e, context);
    }

    return joinuserRooms;
  }

  Future<Roomkarismamodel?> RoomsKarisma({
    context,
    room_id,
  }) async {
    Roomkarismamodel? RoomKarismas;

    try {
      final Response response2 = await dio.get(
        '/api/GetRoomKarismas/$room_id',
      );

      if (response2.statusCode == 200) {
        final roomKarisma = response2.data['RoomKarisma'];

        if (roomKarisma != null) {
          RoomKarismas =
              Roomkarismamodel.fromJson(roomKarisma);

          print(
            RoomKarismas.monthlysupporter?.length,
          );

          print(
            RoomKarismas.dailysupporter?.length,
          );

          print(
            RoomKarismas.weeklysupporter?.length,
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);

      print('GET ROOM KARISMA ERROR: $exception');

      _showError(e, context);
    }

    return RoomKarismas;
  }

  Future<List<KarismaCollectModel>> GetCollectKarisma({
    context,
    room_id,
    user_id,
    chairid,
  }) async {
    try {
      karismas.clear();

      final Response response2 = await dio.get(
        '/api/GetUserKarismaDetales2/'
        '$user_id/$room_id/$chairid',
      );

      if (response2.statusCode == 200) {
        final List list = response2.data ?? [];

        for (final element in list) {
          karismas.add(
            KarismaCollectModel.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);

      print('GET COLLECT KARISMA ERROR: $exception');
    }

    return karismas;
  }

  Future<bool> Evictionuser({
    context,
    Roomid,
    Userid,
  }) async {
    bool JoinRoom = false;

    try {
      final FormData formData = FormData.fromMap({
        'room_id': Roomid.toString(),
        'user_id': Userid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Evictionuser',
        data: formData,
      );

      JoinRoom = response2.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);

      print('EVICTION USER ERROR: $exception');
    }

    return JoinRoom;
  }

  Future<bool> DisbandRoom({
    context,
    Roomid,
  }) async {
    bool JoinRoom = false;

    try {
      final FormData formData = FormData.fromMap({
        'room_id': Roomid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/DisbandRoom',
        data: formData,
      );

      JoinRoom = response2.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);

      print('DISBAND ROOM ERROR: $exception');

      _showRegisterError(e, context);
    }

    return JoinRoom;
  }

  // ============================================================
  // ROOM LISTS
  // ============================================================

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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

      print('SEARCH ROOMS ERROR: $exception');

      _showError(e, context);
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
      final exception = _handleError(e);

      print('GET FOLLOWED ROOMS ERROR: $exception');

      _showError(e, context);
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
      final exception = _handleError(e);

      print('GET MORE ROOMS ERROR: $exception');

      _showError(e, context);
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
      final exception = _handleError(e);

      print('GET MORE RECOMMENDED ROOMS ERROR: $exception');

      _showError(e, context);
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
      final exception = _handleError(e);

      print(
        'GET MORE EXPLORE RECOMMENDED ROOMS ERROR: '
        '$exception',
      );

      _showError(e, context);
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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

      print('GET RECOMMENDED ROOMS ERROR: $exception');

      _showError(e, context);
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
      final exception = _handleError(e);

      print('GET EXPLORE ROOMS ERROR: $exception');

      _showError(e, context);
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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

      print('GET COUNTRIES ERROR: $exception');

      _showError(e, context);
    }

    return Countries;
  }

  // ============================================================
  // ROOM PASSWORD
  // ============================================================

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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

      print(
        'CHECK ROOM PASSWORD RIGHT ERROR: '
        '$exception',
      );
    }

    return PasswordRoom;
  }

  // ============================================================
  // TRENDING / LEADERBOARDS
  // ============================================================

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
      final exception = _handleError(e);

      print('GET NEW ROOMS ERROR: $exception');
    }

    return TradeRooms;
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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

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
      final exception = _handleError(e);

      print(
        'GET RECIVER LEADERBOARD ERROR: '
        '$exception',
      );
    }

    return Leaderboardsupported;
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
      final exception = _handleError(e);

      print('GET MORE TREND ROOMS ERROR: $exception');
    }

    return TradeRooms;
  }

  // ============================================================
  // KICKED USERS
  // ============================================================

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
      final exception = _handleError(e);

      print('GET KICKED USERS ERROR: $exception');
    }

    return KickeduserRooms;
  }

  // ============================================================
  // JOIN ROOM
  // IMPORTANT:
  // Roomid here is the DATABASE room.id.
  //
  // Example:
  // DB ID      = 13
  // Public ID  = 1365700
  // Agora      = "13"
  //
  // Do NOT replace Roomid with the public RoomID here.
  // ============================================================

  Future<RoomModel> joinRooms({
    context,
    Roomid,
  }) async {
    final RoomViewmodel Roomss =
        Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': Roomid.toString(),
      });

      print(
        '========== JOIN ROOM REQUEST ==========',
      );

      print('METHOD: POST');

      print(
        'URL: ${dio.options.baseUrl}/api/JoinRoom',
      );

      print('USER ID: $UserId');

      print(
        'ROOM DB ID REQUESTED: $Roomid',
      );

      print(
        '=======================================',
      );

      final Response response2 = await dio.post(
        '/api/JoinRoom',
        data: formData,
      );

      print(
        '========== JOIN ROOM RESPONSE ==========',
      );

      print(
        'STATUS: ${response2.statusCode}',
      );

      print(
        'URL: ${response2.requestOptions.uri}',
      );

      print(
        'RESPONSE DATA: ${response2.data}',
      );

      print(
        '========================================',
      );

      if (response2.statusCode == 200) {
        print('Join Response received');

        final dynamic roomData =
            response2.data['Room'];

        if (roomData == null) {
          print(
            'JOIN ROOM ERROR: response.data["Room"] is null',
          );

          return Roominfo;
        }

        Roominfo = RoomModel.fromJson(
          roomData,
        );

        Joinid = roomData['joinid'];

        print(
          '========== JOIN ROOM PARSED ==========',
        );

        print(
          'DB ID: ${Roominfo.id}',
        );

        print(
          'PUBLIC RoomID: ${Roominfo.RoomID}',
        );

        print(
          'JOIN ID: $Joinid',
        );

        print(
          'ADMIN ID: ${Roominfo.adminId}',
        );

        print(
          'TOKEN PRESENT: '
          '${Roominfo.Token != null && Roominfo.Token.toString().trim().isNotEmpty}',
        );

        print(
          'TOKEN LENGTH: '
          '${Roominfo.Token?.toString().length ?? 0}',
        );

        print(
          'NAME: ${Roominfo.name}',
        );

        print(
          '======================================',
        );

        Roomss.clearcompo();
        Roomss.hidewaitingtimer2();

        print(
          'JOIN ID IS $Joinid',
        );
      }
    } on DioException catch (e, stackTrace) {
      final exception = _handleError(e);

      print(
        '========== JOIN ROOM DIO ERROR ==========',
      );

      print(
        'TYPE: ${e.type}',
      );

      print(
        'METHOD: ${e.requestOptions.method}',
      );

      print(
        'URL: ${e.requestOptions.uri}',
      );

      print(
        'STATUS: ${e.response?.statusCode}',
      );

      print(
        'RESPONSE DATA: ${e.response?.data}',
      );

      print(
        'MESSAGE: ${e.message}',
      );

      print(
        'STACK: $stackTrace',
      );

      print(
        'API EXCEPTION: $exception',
      );

      print(
        '=========================================',
      );

      if (e.response?.data is Map) {
        print(
          'JOIN ROOM ERROR NUM: '
          '${e.response?.data['errNum']}',
        );

        print(
          'JOIN ROOM ERROR MESSAGE: '
          '${e.response?.data['msg']}',
        );

        if (context != null) {
          Dialogs().ShowErrorRegesterToast(
            e.response?.data['errNum'],
            context,
          );
        }
      }
    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print(
        '========== JOIN ROOM UNKNOWN ERROR '
        '==========',
      );

      print('ERROR: $e');

      print('STACK: $stackTrace');

      print(
        'API EXCEPTION: $exception',
      );

      print(
        '=============================================',
      );
    }

    return Roominfo;
  }

  // ============================================================
  // SUPERVISORS
  // ============================================================

  Future<bool> Addsupervisors({
    context,
    Roomid,
    userid,
  }) async {
    bool state = true;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': userid.toString(),
        'room_id': Roomid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/AddSupervisors',
        data: formData,
      );

      state = response2.statusCode == 200;
    } catch (e) {
      state = false;

      final exception = _handleError(e);

      print(
        'ADD SUPERVISOR ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return state;
  }

  Future<String?> AddackImage({
    image,
  }) async {
    try {
      if (image == null) {
        return null;
      }

      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final Response response2 = await dio.post(
        '/api/AddRoomimages',
        data: formData,
      );

      print(
        'ADD ROOM IMAGE RESPONSE: '
        'status=${response2.statusCode}, '
        'data=${response2.data}',
      );

      if (response2.statusCode == 200) {
        final dynamic uploadedImage =
            response2.data['Roomimages']?['image'];

        if (uploadedImage != null &&
            uploadedImage.toString().trim().isNotEmpty) {
          return uploadedImage.toString();
        }
      }
    } on DioException catch (e) {
      final exception = _handleError(e);

      print(
        'ADD ROOM IMAGE DIO ERROR: '
        'type=${e.type}, '
        'status=${e.response?.statusCode}, '
        'data=${e.response?.data}, '
        'message=${e.message}',
      );

      print(
        'API EXCEPTION: $exception',
      );
    } catch (e) {
      final exception = _handleError(e);

      print(
        'ADD ROOM IMAGE ERROR: $e',
      );

      print(
        'API EXCEPTION: $exception',
      );
    }

    return null;
  }

  Future<bool> FollowRoom({
    context,
    Roomid,
  }) async {
    bool state = true;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': Roomid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/FollowRoom',
        data: formData,
      );

      state = response2.statusCode == 200;
    } catch (e) {
      state = false;

      final exception = _handleError(e);

      print(
        'FOLLOW ROOM ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return state;
  }

  Future<bool> RemoveFollowRoom({
    context,
    Roomid,
  }) async {
    bool state = true;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': Roomid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/RemoveFollowRooms',
        data: formData,
      );

      state = response2.statusCode == 200;
    } catch (e) {
      state = false;

      final exception = _handleError(e);

      print(
        'REMOVE FOLLOW ROOM ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return state;
  }

  Future<List<Gifts>> GetRoomGifts({
    Roomid,
  }) async {
    try {
      RoomGifts.clear();

      final FormData formData = FormData.fromMap({
        'room_id': Roomid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/GetRoomGift',
        data: formData,
      );

      if (response2.statusCode == 200) {
        final List list =
            response2.data['gifts'] ?? [];

        for (final element in list) {
          RoomGifts.add(
            Gifts.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);

      print('GET ROOM GIFTS ERROR: $exception');
    }

    return RoomGifts;
  }

  Future<List<Supervisors>> GetRoomSupercisors({
    Roomid,
  }) async {
    try {
      SupervisorRoom.clear();

      final Response response2 = await dio.get(
        '/api/GetRoomSupervisors/$Roomid',
      );

      print(response2.data);

      if (response2.statusCode == 200) {
        final List list = response2.data ?? [];

        for (final element in list) {
          SupervisorRoom.add(
            Supervisors.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'GET ROOM SUPERVISORS ERROR: $exception',
      );
    }

    return SupervisorRoom;
  }

  Future<bool> Removesupervisors({
    context,
    Roomid,
    userid,
  }) async {
    bool state = true;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': userid.toString(),
        'room_id': Roomid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/RemoveSupervisors',
        data: formData,
      );

      state = response2.statusCode == 200;
    } catch (e) {
      state = false;

      final exception = _handleError(e);

      print(
        'REMOVE SUPERVISOR ERROR: $exception',
      );
    }

    return state;
  }

  // ============================================================
  // CREATE ROOM
  // ============================================================

  Future<RoomModel> CreateRoom({
    context,
    Category,
    city,
    image,
    name,
    backgroundimage,
    RoomAds,
  }) async {
    try {
      if (image == null) {
        print(
          'CREATE ROOM API: image is null',
        );

        return Roominfo;
      }

      if (backgroundimage == null) {
        print(
          'CREATE ROOM API: backgroundimage is null',
        );

        return Roominfo;
      }

      final File roomImageFile =
          image is File ? image : File(image.path);

      final File backgroundImageFile =
          backgroundimage is File
              ? backgroundimage
              : File(backgroundimage.path);

      print(
        'CREATE ROOM API IMAGE EXISTS: '
        '${roomImageFile.existsSync()}',
      );

      print(
        'CREATE ROOM API IMAGE SIZE: '
        '${await roomImageFile.length()} bytes',
      );

      print(
        'CREATE ROOM API BACKGROUND EXISTS: '
        '${backgroundImageFile.existsSync()}',
      );

      print(
        'CREATE ROOM API BACKGROUND SIZE: '
        '${await backgroundImageFile.length()} bytes',
      );

      final MultipartFile roomMultipart =
          await MultipartFile.fromFile(
        roomImageFile.path,
        filename: roomImageFile.path.split('/').last,
      );

      final MultipartFile backgroundMultipart =
          await MultipartFile.fromFile(
        backgroundImageFile.path,
        filename:
            backgroundImageFile.path.split('/').last,
      );

      final FormData formData = FormData.fromMap({
        'name': name.toString(),
        'image': roomMultipart,
        'admin_id': UserId.toString(),
        'Category': Category.toString(),
        'city': city.toString(),
        'animateimage': backgroundMultipart,
        'RoomAds': RoomAds.toString(),
      });

      print(
        'CREATE ROOM FORM DATA READY',
      );

      print(
        'CREATE ROOM FIELDS: '
        'name=$name, '
        'admin_id=$UserId, '
        'Category=$Category, '
        'city=$city, '
        'RoomAds=$RoomAds',
      );

      print(
        'CREATE ROOM IMAGE FILE: '
        '${roomImageFile.path}',
      );

      print(
        'CREATE ROOM BACKGROUND FILE: '
        '${backgroundImageFile.path}',
      );

      final Response response = await dio.post(
        '/api/CreateRoom',
        data: formData,
      );

      print(
        'CREATE ROOM RESPONSE STATUS: '
        '${response.statusCode}',
      );

      print(
        'CREATE ROOM RESPONSE DATA: '
        '${response.data}',
      );

      print(
        '========== CREATE ROOM RESPONSE ==========',
      );

      print(
        'METHOD: ${response.requestOptions.method}',
      );

      print(
        'URL: ${response.requestOptions.uri}',
      );

      print(
        'STATUS: ${response.statusCode}',
      );

      print(
        'RESPONSE HEADERS: ${response.headers}',
      );

      print(
        'RESPONSE DATA: ${response.data}',
      );

      print(
        '==========================================',
      );

      if (response.statusCode == 200) {
        final dynamic roomData =
            response.data['room'];

        if (roomData != null) {
          Roominfo = RoomModel.fromJson(
            roomData,
          );

          print(
            '========== CREATE ROOM PARSED ==========',
          );

          print(
            'DB ID: ${Roominfo.id}',
          );

          print(
            'PUBLIC RoomID: ${Roominfo.RoomID}',
          );

          print(
            'ADMIN ID: ${Roominfo.adminId}',
          );

          print(
            'TOKEN PRESENT: '
            '${Roominfo.Token != null && Roominfo.Token.toString().trim().isNotEmpty}',
          );

          print(
            'TOKEN LENGTH: '
            '${Roominfo.Token?.toString().length ?? 0}',
          );

          print(
            'NAME: ${Roominfo.name}',
          );

          print(
            '========================================',
          );
        } else {
          print(
            'CREATE ROOM ERROR: '
            'response.data["room"] is NULL',
          );
        }
      }
    } on DioException catch (e) {
      final exception = _handleError(e);

      print(
        'CREATE ROOM DIO ERROR TYPE: '
        '${e.type}',
      );

      print(
        'CREATE ROOM DIO STATUS: '
        '${e.response?.statusCode}',
      );

      print(
        'CREATE ROOM DIO DATA: '
        '${e.response?.data}',
      );

      print(
        'CREATE ROOM DIO MESSAGE: '
        '${e.message}',
      );

      print(
        'CREATE ROOM REQUEST URL: '
        '${e.requestOptions.uri}',
      );

      if (e.response?.data is Map) {
        print(
          'CREATE ROOM ERROR NUM: '
          '${e.response?.data['errNum']}',
        );

        print(
          'CREATE ROOM ERROR MESSAGE: '
          '${e.response?.data['msg']}',
        );
      }

      print(
        'API EXCEPTION: $exception',
      );

      _showRegisterError(e, context);
    } catch (e, stackTrace) {
      final exception = _handleError(e);

      print(
        'CREATE ROOM API ERROR: $e',
      );

      print(
        'CREATE ROOM API STACK: $stackTrace',
      );

      print(
        'API EXCEPTION: $exception',
      );
    }

    return Roominfo;
  }

  // ============================================================
  // LEAVE ROOM
  // ============================================================

  Future<bool> LeaveRoom({
    context,
    Roomid,
  }) async {
    bool leaved = false;

    try {
      final Map<String, dynamic> map = {
        'join_id': Joinid.toString(),
        'room_id': Roomid.toString(),
        'user_id': UserId.toString(),
      };

      map.removeWhere(
        (key, value) =>
            value == null ||
            value == 'null' ||
            key == 'null',
      );

      final FormData formData =
          FormData.fromMap(map);

      print(
        '========== LEAVE ROOM REQUEST ==========',
      );

      print('METHOD: POST');

      print(
        'URL: ${dio.options.baseUrl}/api/LeaveRoom',
      );

      print('JOIN ID: $Joinid');

      print('ROOM ID: $Roomid');

      print('USER ID: $UserId');

      print(
        '=========================================',
      );

      final Response response2 = await dio.post(
        '/api/LeaveRoom',
        data: formData,
      );

      print(
        '========== LEAVE ROOM RESPONSE ==========',
      );

      print(
        'STATUS: ${response2.statusCode}',
      );

      print(
        'URL: ${response2.requestOptions.uri}',
      );

      print(
        'RESPONSE DATA: ${response2.data}',
      );

      print(
        'RESPONSE HEADERS: ${response2.headers}',
      );

      print(
        '==========================================',
      );

      if (response2.statusCode == 200) {
        leaved = true;
      } else if (response2.statusCode == 400) {
        leaved = false;
      }

      print('Join id is 3');
    } catch (e) {
      final exception = _handleError(e);

      print(
        'LEAVE ROOM ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return leaved;
  }

  Future<bool> LeaveChair({
    context,
    Roomid,
    chairid,
  }) async {
    bool leaved = false;

    try {
      final FormData formData = FormData.fromMap({
        'chair_id': chairid.toString(),
        'room_id': Roomid.toString(),
        'user_id': UserId.toString(),
      });

      final Response response2 = await dio.post(
        '/api/LeaveChair',
        data: formData,
      );

      if (response2.statusCode == 200) {
        leaved = true;
      } else if (response2.statusCode == 400) {
        leaved = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'LEAVE CHAIR ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return leaved;
  }

  Future<bool> LeaveuserChair({
    context,
    user_id,
    Roomid,
    chairid,
  }) async {
    print(chairid);
    print(Roomid);
    print(user_id);

    try {
      final FormData formData = FormData.fromMap({
        'chair_id': chairid.toString(),
        'room_id': Roomid.toString(),
        'user_id': user_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/LeaveChair',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200) {
        print('done');
        return true;
      }

      if (response2.statusCode == 400) {
        print('not done');
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'LEAVE USER CHAIR ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return false;
  }

  // ============================================================
  // JOIN / CHANGE CHAIR
  // ============================================================

  Future<bool> joinChair({
    context,
    index,
    room_id,
    chair_id,
  }) async {
    bool joicchair = false;

    try {
      print('xxxxxxxxxxxxxxxxx');
      print(UserId.toString());
      print(room_id.toString());
      print(chair_id.toString());

      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': room_id.toString(),
        'chair_id': chair_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/JoinChair',
        data: formData,
      );

      print(
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
      );

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        joicchair = true;
      } else {
        print(
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        );

        joicchair = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'JOIN CHAIR ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return joicchair;
  }

  Future<bool> ChangeChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) async {
    bool joicchair = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': room_id.toString(),
        'Current_chair': CurrentChairid.toString(),
        'chair_id': NewCharid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/ChangeChair',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        joicchair = true;
      } else {
        joicchair = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'CHANGE CHAIR ERROR: $exception',
      );
    }

    return joicchair;
  }

  Future<bool> AdminChangeChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) async {
    bool joicchair = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': room_id.toString(),
        'Current_chair': CurrentChairid.toString(),
        'chair_id': NewCharid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/AdminChangeChair',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        joicchair = true;
      } else {
        joicchair = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'ADMIN CHANGE CHAIR ERROR: $exception',
      );
    }

    return joicchair;
  }

  Future<bool> ReturnAdminChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) async {
    bool joicchair = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': room_id.toString(),
        'Current_chair': CurrentChairid.toString(),
        'chair_id': NewCharid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/ReturntoAdminChair',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        joicchair = true;
      } else {
        joicchair = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'RETURN ADMIN CHAIR ERROR: $exception',
      );
    }

    return joicchair;
  }

  Future<bool> KickJoinadminuser({
    context,
    room_id,
    user_id,
  }) async {
    bool update = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Removeadminroom',
        data: formData,
      );

      if (response2.statusCode == 200) {
        update = true;
        print('true');
      } else {
        update = false;
        print('false');
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'KICK JOIN ADMIN USER ERROR: $exception',
      );

      _showError(e, context);
    }

    return update;
  }

  Future<bool> InviteUserToSET({
    context,
    room_id,
    user_id,
  }) async {
    bool update = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Inviteuser',
        data: formData,
      );

      if (response2.statusCode == 200) {
        update = true;
        print('true');
      } else {
        update = false;
        print('false');
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'INVITE USER ERROR: $exception',
      );

      _showError(e, context);
    }

    return update;
  }

  // ============================================================
  // ROOM CHAT
  // ============================================================

  Future<bool> sendmessage({
    content,
    Roomid,
  }) async {
    bool sent = true;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': Roomid.toString(),
        'content': content.toString(),
      });

      final Response response2 = await dio.post(
        '/api/AddChatRoom',
        data: formData,
      );

      if (response2.statusCode == 200) {
        sent = true;
        print('true');
      } else {
        sent = false;
        print('false');
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'SEND MESSAGE ERROR: $exception',
      );

      final errNum = _errorNumber(e);

      if (errNum == '3500') {
        // Keep existing behavior.
      }
    }

    return sent;
  }

  Future<bool> sendMention({
    content,
    Roomid,
    Reciver_id,
  }) async {
    bool sent = true;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': Roomid.toString(),
        'content': content.toString(),
        'reciver_id': Reciver_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/AddMention',
        data: formData,
      );

      if (response2.statusCode == 200) {
        sent = true;
        print('true');
      } else {
        sent = false;
        print('false');
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'SEND MENTION ERROR: $exception',
      );

      final errNum = _errorNumber(e);

      if (errNum == '3500') {
        // Keep existing behavior.
      }
    }

    return sent;
  }

  // ============================================================
  // LOCK CHAIR
  // ============================================================

  Future<bool> LockChair({
    Chair_id,
    int? Lock,
    RoomModel? Roominfo,
  }) async {
    bool update = false;

    try {
      final FormData formData = FormData.fromMap({
        'chair_id': Chair_id.toString(),
        'room_id': Roominfo?.id.toString(),
        'Lock': Lock.toString(),
      });

      final Response response2 = await dio.post(
        '/api/LockChair',
        data: formData,
      );

      if (response2.statusCode == 200) {
        update = true;
        print('true');
      } else {
        update = false;
        print('false');
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'LOCK CHAIR ERROR: $exception',
      );
    }

    return update;
  }

  // ============================================================
  // GIFTS
  // ============================================================

  Future<bool> SendGift({
    context,
    Roomid,
    Listuser,
    giftid,
    quantity,
    Cost,
  }) async {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    bool send = true;

    try {
      final FormData formData = FormData.fromMap({
        'Listuser': Listuser.toString(),
        'room_id': Roomid.toString(),
        'user_id': UserId.toString(),
        'quantity': quantity.toString(),
        'gift_id': giftid.toString(),
        'Cost': Cost.toString(),
      });

      final Response response2 = await dio.post(
        '/api/sentGift',
        data: formData,
      );

      if (response2.statusCode == 200) {
        user.Updatecoins(
          coins: int.parse(
            response2.data['user']['coins'].toString(),
          ),
        );

        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'SEND GIFT ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return send;
  }

  Future<String> SentLuckyGift({
    context,
    Roomid,
    Listuser,
    giftid,
    quantity,
    Cost,
  }) async {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    String prsantage = '';

    try {
      final FormData formData = FormData.fromMap({
        'Listuser': Listuser.toString(),
        'room_id': Roomid.toString(),
        'user_id': UserId.toString(),
        'quantity': quantity.toString(),
        'gift_id': giftid.toString(),
        'Cost': Cost.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SentLuckyGift',
        data: formData,
      );

      if (response2.statusCode == 200) {
        print(
          '=====================ReturnMyCOINS========>'
          '${response2.data['gain']['coins'].toString()}'
          '==================>',
        );

        print(
          '=====================ReturnWin========>'
          '${response2.data['gain']['ReturnedValue']['win'].toString()}'
          '==================>',
        );

        print(
          '=====================Persantagec========>'
          '${response2.data['gain']['ReturnedValue']['Persantage'].toString()}'
          '==================>',
        );

        if (response2.data['gain']['ReturnedValue']
                    ['Persantage'] !=
                0 &&
            response2.data['gain']['ReturnedValue']
                    ['Persantage'] !=
                '0') {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).addComboWin(
            amount: response2.data['gain']['ReturnedValue']
                ['win'],
            persantage: response2.data['gain']
                ['ReturnedValue']['Persantage'],
          );
        }

        user.Updatecoins(
          coins: int.parse(
            response2.data['gain']['coins'].toString(),
          ),
        );

        prsantage = response2.data['gain']
                ['ReturnedValue']['win']
            .toString();

        print(response2.data['gain']);
      } else {
        prsantage = '';
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'SEND LUCKY GIFT ERROR: $exception',
      );

      prsantage = '';
    }

    return prsantage;
  }

  Future<String> SentCompoGift({
    context,
    Roomid,
    Listuser,
    giftid,
    quantity,
    Cost,
  }) async {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    String prsantage = '';

    try {
      final FormData formData = FormData.fromMap({
        'Listuser': Listuser.toString(),
        'room_id': Roomid.toString(),
        'user_id': UserId.toString(),
        'quantity': quantity.toString(),
        'gift_id': giftid.toString(),
        'Cost': Cost.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SentCompo',
        data: formData,
      );

      if (response2.statusCode == 200) {
        print(
          '=====================ReturnMyCOINS========>'
          '${response2.data['gain']['coins'].toString()}'
          '==================>',
        );

        print(
          '=====================ReturnWin========>'
          '${response2.data['gain']['ReturnedValue']['win'].toString()}'
          '==================>',
        );

        print(
          '=====================Persantagec========>'
          '${response2.data['gain']['ReturnedValue']['Persantage'].toString()}'
          '==================>',
        );

        if (response2.data['gain']['ReturnedValue']
                    ['Persantage'] !=
                0 &&
            response2.data['gain']['ReturnedValue']
                    ['Persantage'] !=
                '0') {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).addComboWin(
            amount: response2.data['gain']['ReturnedValue']
                ['win'],
            persantage: response2.data['gain']
                ['ReturnedValue']['Persantage'],
          );
        }

        user.Updatecoins(
          coins: int.parse(
            response2.data['gain']['coins'].toString(),
          ),
        );

        prsantage = response2.data['gain']
                ['ReturnedValue']['win']
            .toString();

        print(response2.data['gain']);
      } else {
        prsantage = '';
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'SEND COMPO GIFT ERROR: $exception',
      );

      prsantage = '';

      _showRegisterError(e, context);
    }

    return prsantage;
  }

  // ============================================================
  // EMOJI / IMAGE
  // ============================================================

  Future<bool> SendEmoje({
    context,
    Emoje,
    Room_id,
  }) async {
    print(Emoje.toString());

    bool send = true;

    try {
      final FormData formData = FormData.fromMap({
        'emoji': Emoje.toString(),
        'room_id': Room_id.toString(),
        'user_id': UserId.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Sendemoji',
        data: formData,
      );

      if (response2.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'SEND EMOJI ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return send;
  }

  Future<bool> SentImageRoom({
    context,
    image,
    Room_id,
  }) async {
    bool send = true;

    try {
      final FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        'room_id': Room_id.toString(),
        'user_id': UserId.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SendImage',
        data: formData,
      );

      if (response2.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'SEND ROOM IMAGE ERROR: $exception',
      );

      _showRegisterError(e, context);
    }

    return send;
  }

  // ============================================================
  // ROOM GAMES
  // ============================================================

  Future<bool> Playdice({
    context,
    Room_id,
  }) async {
    bool send = true;

    try {
      final FormData formData = FormData.fromMap({
        'room_id': Room_id.toString(),
        'user_id': UserId.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Playdice',
        data: formData,
      );

      if (response2.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'PLAY DICE ERROR: $exception',
      );
    }

    return send;
  }

  Future<bool> Playrollet({
    context,
    Room_id,
    Name,
  }) async {
    bool send = true;

    try {
      final FormData formData = FormData.fromMap({
        'room_id': Room_id.toString(),
        'user_id': UserId.toString(),
        'name': Name.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Playrollet',
        data: formData,
      );

      if (response2.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'PLAY ROLLET ERROR: $exception',
      );
    }

    return send;
  }

  // ============================================================
  // INSULTS
  // ============================================================

  Future<bool> Addinsults({
    context,
    type,
    message,
  }) async {
    bool update = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId,
        'type': type,
        'text': message.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Addinsult',
        data: formData,
      );

      if (response2.statusCode == 200) {
        update = true;
        print('true');
      } else {
        update = false;
        print('false');
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'ADD INSULT ERROR: $exception',
      );

      _showError(e, context);
    }

    return update;
  }
}