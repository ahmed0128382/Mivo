import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';

/// Shared error helpers for Roomapi import 'room_api_error_mixin.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiGamesMixin on RoomApiStateMixin {
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
      final exception = handleError(e);

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
      final exception = handleError(e);

      print(
        'PLAY ROLLET ERROR: $exception',
      );
    }

    return send;
  }

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
      final exception = handleError(e);

      print(
        'ADD INSULT ERROR: $exception',
      );

      showError(e, context);
    }

    return update;
  }

}
