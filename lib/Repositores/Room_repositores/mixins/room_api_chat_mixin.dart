import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';

/// Shared error helpers for Roomapi import 'room_api_error_mixin.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiChatMixin on RoomApiStateMixin {
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
      final exception = handleError(e);

      print(
        'SEND MESSAGE ERROR: $exception',
      );

      final errNum = errorNumber(e);

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
      final exception = handleError(e);

      print(
        'SEND MENTION ERROR: $exception',
      );

      final errNum = errorNumber(e);

      if (errNum == '3500') {
        // Keep existing behavior.
      }
    }

    return sent;
  }

}
