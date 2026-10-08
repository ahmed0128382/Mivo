import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';


/// Shared error helpers for Roomapi import 'room_api_error_mixin.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiLeaveMixin on RoomApiStateMixin {
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
      final exception = handleError(e);

      print(
        'LEAVE ROOM ERROR: $exception',
      );

      showRegisterError(e, context);
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
      final exception = handleError(e);

      print(
        'LEAVE CHAIR ERROR: $exception',
      );

      showRegisterError(e, context);
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
      final exception = handleError(e);

      print(
        'LEAVE USER CHAIR ERROR: $exception',
      );

      showRegisterError(e, context);
    }

    return false;
  }

}
