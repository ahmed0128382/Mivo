import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'room_api_state_mixin.dart';

mixin RoomApiJoinMixin on RoomApiStateMixin {
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

  bool _isSuccessful(dynamic value) {
    final Map<String, dynamic>? data = _asStringMap(value);

    if (data == null) return false;

    final dynamic status = data['status'];

    return status == true ||
        status == 1 ||
        status?.toString().toLowerCase() == 'true';
  }

  /// Joins a room using the existing backend API.
  ///
  /// The server's Room.join_room list can be empty even when the
  /// membership was created successfully. Participant loading must
  /// therefore be handled by the participant-list API, not chairs.
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

      final String requestedRoomId = Roomid?.toString().trim() ?? '';

      if (requestedRoomId.isEmpty ||
          requestedRoomId == 'null') {
        if (kDebugMode) {
          debugPrint('[JOIN_ROOM] Missing room ID.');
        }

        return Roominfo;
      }

      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': requestedRoomId,
      });

      final Response response = await dio.post(
        '/api/JoinRoom',
        data: formData,
      );

      final Map<String, dynamic>? responseData =
          _asStringMap(response.data);

      if (response.statusCode != 200 ||
          responseData == null ||
          !_isSuccessful(responseData)) {
        if (kDebugMode) {
          debugPrint(
            '[JOIN_ROOM] Join failed: '
            'HTTP ${response.statusCode}, '
            'errNum=${responseData?['errNum']}',
          );
        }

        if (responseData != null && context != null) {
          Dialogs().ShowErrorRegesterToast(
            responseData['errNum'],
            context,
          );
        }

        return Roominfo;
      }

      final Map<String, dynamic>? roomData =
          _asStringMap(responseData['Room']);

      if (roomData == null) {
        if (kDebugMode) {
          debugPrint(
            '[JOIN_ROOM] Successful response did not contain Room.',
          );
        }

        return Roominfo;
      }

      final RoomModel parsedRoom =
          RoomModel.fromJson(roomData);

      final bool sameRoom =
          Roominfo.id != null &&
          parsedRoom.id != null &&
          Roominfo.id == parsedRoom.id;

      // The API may return join_room: [] even though the user joined.
      // Preserve the existing list only if it belongs to this room.
      if (sameRoom &&
          (parsedRoom.joinRooms == null ||
              parsedRoom.joinRooms!.isEmpty) &&
          Roominfo.joinRooms != null &&
          Roominfo.joinRooms!.isNotEmpty) {
        parsedRoom.joinRooms = Roominfo.joinRooms;
      }

      // Do not infer participants from chairs.
      Roominfo = parsedRoom;

      final dynamic returnedJoinId = roomData['joinid'];

      if (returnedJoinId != null &&
          returnedJoinId.toString().trim().isNotEmpty &&
          returnedJoinId.toString() != 'null') {
        Joinid = returnedJoinId;
      } else {
        if (kDebugMode) {
          debugPrint(
            '[JOIN_ROOM] Response did not contain a valid joinid.',
          );
        }
      }

      roomViewModel?.clearcompo();
      roomViewModel?.hidewaitingtimer2();

      if (kDebugMode) {
        debugPrint(
          '[JOIN_ROOM] Success: '
          'roomId=${Roominfo.id}, '
          'adminId=${Roominfo.adminId}, '
          'joinId=$Joinid',
        );
      }

      return Roominfo;
    } on DioException catch (error) {
      handleError(error);

      if (kDebugMode) {
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

      return Roominfo;
    } catch (error, stackTrace) {
      handleError(error);

      if (kDebugMode) {
        debugPrint(
          '[JOIN_ROOM] Unexpected error: ${error.runtimeType}',
        );
        debugPrintStack(stackTrace: stackTrace);
      }

      return Roominfo;
    }
  }
}