import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/RoomKarismaModel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/SupervisorsModel.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiAdminMixin on RoomApiStateMixin {

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
      final exception = handleError(e);

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
      final exception = handleError(e);

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
      final exception = handleError(e);

      print('UNKICK USER ERROR: $exception');

      showRegisterError(e, context);
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
      final exception = handleError(e);

      print('UPDATE THRONE CHAIR ERROR: $exception');

      showRegisterError(e, context);
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
      final exception = handleError(e);

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
      final exception = handleError(e);

      print('DELETE ROOM CHAT ERROR: $exception');

      showRegisterError(e, context);
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
      final exception = handleError(e);

      print('SET ROOM PASSWORD ERROR: $exception');

      showRegisterError(e, context);
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
      final exception = handleError(e);

      print('REMOVE ROOM PASSWORD ERROR: $exception');

      showRegisterError(e, context);
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
      final exception = handleError(e);

      print('GET JOIN USERS ERROR: $exception');

      showError(e, context);
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
      final exception = handleError(e);

      print('GET ROOM KARISMA ERROR: $exception');

      showError(e, context);
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
      final exception = handleError(e);

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
      final exception = handleError(e);

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
      final exception = handleError(e);

      print('DISBAND ROOM ERROR: $exception');

      showRegisterError(e, context);
    }

    return JoinRoom;
  }

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

      final exception = handleError(e);

      print(
        'ADD SUPERVISOR ERROR: $exception',
      );

      showRegisterError(e, context);
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
      final exception = handleError(e);

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
      final exception = handleError(e);

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

      final exception = handleError(e);

      print(
        'FOLLOW ROOM ERROR: $exception',
      );

      showRegisterError(e, context);
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

      final exception = handleError(e);

      print(
        'REMOVE FOLLOW ROOM ERROR: $exception',
      );

      showRegisterError(e, context);
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
      final exception = handleError(e);

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
      final exception = handleError(e);

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

      final exception = handleError(e);

      print(
        'REMOVE SUPERVISOR ERROR: $exception',
      );
    }

    return state;
  }


}