
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'room_api_state_mixin.dart';

mixin RoomApiJoinMixin on RoomApiStateMixin {
  // ============================================================
  // SAFE VALUE CONVERSION
  // ============================================================

  Map<String, dynamic>? _asStringMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  // ============================================================
  // JOIN ROOM
  // ============================================================

  Future<RoomModel> joinRooms({
    dynamic context,
    dynamic Roomid,
  }) async {
    RoomViewmodel? roomViewModel;

    try {
      if (context != null) {
        roomViewModel = Provider.of<RoomViewmodel>(
          context,
          listen: false,
        );
      }

      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': Roomid.toString(),
      });

      final Response response = await dio.post(
        '/api/JoinRoom',
        data: formData,
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          debugPrint(
            '[JOIN_ROOM] Unexpected HTTP status: '
            '${response.statusCode}',
          );
        }

        return Roominfo;
      }

      final Map<String, dynamic>? responseData =
          _asStringMap(response.data);

      if (responseData == null) {
        if (kDebugMode) {
          debugPrint(
            '[JOIN_ROOM] Invalid response format.',
          );
        }

        return Roominfo;
      }

      final Map<String, dynamic>? roomData =
          _asStringMap(responseData['Room']);

      if (roomData == null) {
        if (kDebugMode) {
          debugPrint(
            '[JOIN_ROOM] Response does not contain a valid Room object.',
          );
        }

        return Roominfo;
      }

      // Parse the room without dumping raw API data or chair records.
      final RoomModel parsedRoom;

      try {
        parsedRoom = RoomModel.fromJson(roomData);
      } catch (error, stackTrace) {
        if (kDebugMode) {
          debugPrint(
            '[JOIN_ROOM] Failed to parse the room: '
            '${error.runtimeType}',
          );
          debugPrintStack(stackTrace: stackTrace);
        }

        rethrow;
      }

      // Update the shared room state.
      Roominfo = parsedRoom;
      Joinid = roomData['joinid'];

      // Preserve the original cleanup behavior.
      roomViewModel?.clearcompo();
      roomViewModel?.hidewaitingtimer2();

      return Roominfo;
    } on DioException catch (error) {
      handleError(error);

      if (kDebugMode) {
        // Log only concise error metadata.
        // Do not print the response body or sensitive values.
        debugPrint(
          '[JOIN_ROOM] Request failed: '
          'type=${error.type}, '
          'status=${error.response?.statusCode}',
        );
      }

      final Map<String, dynamic>? errorData =
          _asStringMap(error.response?.data);

      if (errorData != null && context != null) {
        Dialogs().ShowErrorRegesterToast(
          errorData['errNum'],
          context,
        );
      }
    } catch (error, stackTrace) {
      handleError(error);

      if (kDebugMode) {
        debugPrint(
          '[JOIN_ROOM] Unexpected error: '
          '${error.runtimeType}',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    return Roominfo;
  }
}
