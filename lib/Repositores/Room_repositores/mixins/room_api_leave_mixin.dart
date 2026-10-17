import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'room_api_state_mixin.dart';

mixin RoomApiLeaveMixin on RoomApiStateMixin {
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

  Future<bool> LeaveRoom({
    context,
    Roomid,
  }) async {
    try {
      final String roomId = Roomid?.toString().trim() ?? '';
      final String joinId = Joinid?.toString().trim() ?? '';
      final String userId = UserId.toString();

      if (roomId.isEmpty ||
          roomId == 'null' ||
          userId.isEmpty ||
          userId == 'null') {
        if (kDebugMode) {
          debugPrint(
            '[LEAVE_ROOM] Missing room ID or user ID.',
          );
        }

        return false;
      }

      final Map<String, dynamic> request = {
        'room_id': roomId,
        'user_id': userId,
      };

      // The tested API uses join_id. Include it when available.
      if (joinId.isNotEmpty && joinId != 'null') {
        request['join_id'] = joinId;
      }

      final FormData formData = FormData.fromMap(request);

      final Response response = await dio.post(
        '/api/LeaveRoom',
        data: formData,
      );

      final Map<String, dynamic>? responseData =
          _asStringMap(response.data);

      final bool success =
          response.statusCode == 200 &&
          responseData != null &&
          _isSuccessful(responseData);

      if (!success) {
        if (kDebugMode) {
          debugPrint(
            '[LEAVE_ROOM] Leave failed: '
            'HTTP ${response.statusCode}, '
            'errNum=${responseData?['errNum']}',
          );
        }

        return false;
      }

      // The current membership has ended. Do not clear Roominfo or its
      // participant list here: other widgets may still be displaying it.
      // The ViewModel should refresh/clear room state as part of navigation.
      Joinid = null;

      if (kDebugMode) {
        debugPrint(
          '[LEAVE_ROOM] Success: roomId=$roomId, userId=$userId',
        );
      }

      return true;
    } on DioException catch (error) {
      handleError(error);

      if (kDebugMode) {
        debugPrint(
          '[LEAVE_ROOM] Request failed: '
          'type=${error.type}, '
          'status=${error.response?.statusCode}',
        );
      }

      showRegisterError(error, context);
      return false;
    } catch (error, stackTrace) {
      handleError(error);

      if (kDebugMode) {
        debugPrint(
          '[LEAVE_ROOM] Unexpected error: ${error.runtimeType}',
        );
        debugPrintStack(stackTrace: stackTrace);
      }

      showRegisterError(error, context);
      return false;
    }
  }
}