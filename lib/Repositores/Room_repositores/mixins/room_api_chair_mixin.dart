
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'room_api_state_mixin.dart';

/// API operations related to room chairs and room invitations.
///
/// Logging policy:
/// - Debug builds only.
/// - One concise line per event.
/// - Successful responses do not dump response bodies.
/// - Errors retain useful HTTP and API diagnostics.
/// - Never log request headers, tokens, or complete payloads.
mixin RoomApiChairMixin on RoomApiStateMixin {
  // ============================================================
  // Compact diagnostic logging
  // ============================================================

  void _apiChairLog(String stage, [Object? details]) {
    if (!kDebugMode) return;

    final message = details == null ? stage : '$stage | $details';
    final compact = message.replaceAll(RegExp(r'\s+'), ' ').trim();

    const maxLength = 240;
    final output = compact.length > maxLength
        ? '${compact.substring(0, maxLength - 3)}...'
        : compact;

    debugPrint('[CHAIR_API] $output');
  }

  String _shortValue(Object? value, {int maxLength = 180}) {
    if (value == null) return '';

    final text = value.toString().replaceAll(RegExp(r'\s+'), ' ').trim();

    if (text.length <= maxLength) return text;

    return '${text.substring(0, maxLength - 3)}...';
  }

  void _logApiResponse({
    required String operation,
    required String endpoint,
    required Response response,
  }) {
    if (!kDebugMode) return;

    final statusCode = response.statusCode;
    final isHttpSuccess =
        statusCode != null && statusCode >= 200 && statusCode < 300;

    // Do not print full bodies for successful requests.
    if (isHttpSuccess) {
      _apiChairLog(
        '$operation response',
        'endpoint=$endpoint status=$statusCode',
      );
      return;
    }

    final body = response.data;
    final message = body is Map
        ? body['message'] ?? body['msg'] ?? body['error']
        : null;

    _apiChairLog(
      '$operation HTTP failure',
      'endpoint=$endpoint status=$statusCode '
          'message=${_shortValue(message ?? body)}',
    );
  }

  void _logApiException({
    required String operation,
    required String endpoint,
    required Object error,
  }) {
    if (!kDebugMode) return;

    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final responseBody = error.response?.data;

      final responseMessage = responseBody is Map
          ? responseBody['message'] ??
              responseBody['msg'] ??
              responseBody['error']
          : responseBody;

      _apiChairLog(
        '$operation failed',
        'endpoint=$endpoint '
            'type=${error.type.name} '
            'status=$statusCode '
            'message=${_shortValue(responseMessage ?? error.message)}',
      );
      return;
    }

    // Keep unexpected errors diagnosable without printing a full stack trace.
    _apiChairLog(
      '$operation failed',
      'endpoint=$endpoint type=${error.runtimeType} '
          'message=${_shortValue(error)}',
    );
  }

  // ============================================================
  // Safe request helpers
  // ============================================================

  bool _isSuccessfulResponse(Response response) {
    final statusCode = response.statusCode;

    if (statusCode != 200 && statusCode != 201) {
      _apiChairLog(
        'Request rejected',
        'status=$statusCode',
      );
      return false;
    }

    final body = response.data;

    if (body is Map) {
      final dynamic successValue = body['success'];
      final dynamic statusValue = body['status'];

      if (_isExplicitFailure(successValue)) {
        _apiChairLog(
          'API reported failure',
          'success=$successValue',
        );
        return false;
      }

      if (_isExplicitFailure(statusValue)) {
        _apiChairLog(
          'API reported failure',
          'status=$statusValue',
        );
        return false;
      }
    }

    return true;
  }

  bool _isExplicitFailure(dynamic value) {
    return value == false ||
        value == 0 ||
        value?.toString().toLowerCase() == 'false';
  }

  String? _requestValue(dynamic value) {
    if (value == null) return null;

    final result = value.toString().trim();

    if (result.isEmpty || result == 'null') {
      return null;
    }

    return result;
  }

  bool _hasRequiredValues(Iterable<dynamic> values) {
    return values.every(
      (value) => _requestValue(value) != null,
    );
  }

  /// Common form fields for chair assignment endpoints.
  ///
  /// Field names remain unchanged to preserve the backend API contract.
  Map<String, dynamic> _chairRequestData({
    required dynamic userId,
    required dynamic roomId,
    required dynamic currentChairId,
    required dynamic newChairId,
  }) {
    return <String, dynamic>{
      'user_id': _requestValue(userId),
      'room_id': _requestValue(roomId),
      'Current_chair': _requestValue(currentChairId),
      'chair_id': _requestValue(newChairId),
    };
  }

  // ============================================================
  // Join chair
  // ============================================================

  Future<bool> joinChair({
    context,
    index,
    room_id,
    chair_id,
  }) async {
    const endpoint = '/api/JoinChair';
    const operation = 'Join chair';

    try {
      final String? userId = _requestValue(UserId);
      final String? roomId = _requestValue(room_id);
      final String? chairId = _requestValue(chair_id);

      if (!_hasRequiredValues([userId, roomId, chairId])) {
        _apiChairLog(
          '$operation aborted',
          'reason=missing_required_value index=$index',
        );
        return false;
      }

      _apiChairLog(
        '$operation request',
        'room=$roomId chair=$chairId index=$index',
      );

      final formData = FormData.fromMap({
        'user_id': userId,
        'room_id': roomId,
        'chair_id': chairId,
      });

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logApiResponse(
        operation: operation,
        endpoint: endpoint,
        response: response,
      );

      final success = _isSuccessfulResponse(response);

      if (!success) {
        _apiChairLog(
          '$operation rejected',
          'room=$roomId chair=$chairId',
        );
      }

      return success;
    } catch (error) {
      _logApiException(
        operation: operation,
        endpoint: endpoint,
        error: error,
      );

      showRegisterError(error, context);
      return false;
    }
  }

  // ============================================================
  // Change chair
  // ============================================================

  Future<bool> ChangeChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) {
    return _changeChairRequest(
      endpoint: '/api/ChangeChair',
      errorLabel: 'Change chair',
      userId: UserId,
      roomId: room_id,
      currentChairId: CurrentChairid,
      newChairId: NewCharid,
    );
  }

  // ============================================================
  // Admin changes chair
  // ============================================================

  Future<bool> AdminChangeChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) {
    return _changeChairRequest(
      endpoint: '/api/AdminChangeChair',
      errorLabel: 'Admin change chair',
      userId: UserId,
      roomId: room_id,
      currentChairId: CurrentChairid,
      newChairId: NewCharid,
    );
  }

  // ============================================================
  // Return admin chair
  // ============================================================

  Future<bool> ReturnAdminChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) {
    return _changeChairRequest(
      endpoint: '/api/ReturntoAdminChair',
      errorLabel: 'Return admin chair',
      userId: UserId,
      roomId: room_id,
      currentChairId: CurrentChairid,
      newChairId: NewCharid,
    );
  }

  // ============================================================
  // Shared chair change request
  // ============================================================

  Future<bool> _changeChairRequest({
    required String endpoint,
    required String errorLabel,
    required dynamic userId,
    required dynamic roomId,
    required dynamic currentChairId,
    required dynamic newChairId,
  }) async {
    try {
      if (!_hasRequiredValues([
        userId,
        roomId,
        currentChairId,
        newChairId,
      ])) {
        _apiChairLog(
          '$errorLabel aborted',
          'reason=missing_required_value',
        );
        return false;
      }

      final requestData = _chairRequestData(
        userId: userId,
        roomId: roomId,
        currentChairId: currentChairId,
        newChairId: newChairId,
      );

      _apiChairLog(
        '$errorLabel request',
        'room=${requestData['room_id']} '
            'currentChair=${requestData['Current_chair']} '
            'newChair=${requestData['chair_id']}',
      );

      final Response response = await dio.post(
        endpoint,
        data: FormData.fromMap(requestData),
      );

      _logApiResponse(
        operation: errorLabel,
        endpoint: endpoint,
        response: response,
      );

      final success = _isSuccessfulResponse(response);

      if (!success) {
        _apiChairLog(
          '$errorLabel rejected',
          'room=${requestData['room_id']}',
        );
      }

      return success;
    } catch (error) {
      _logApiException(
        operation: errorLabel,
        endpoint: endpoint,
        error: error,
      );

      return false;
    }
  }

  // ============================================================
  // Remove admin from room
  // ============================================================

  Future<bool> KickJoinadminuser({
    context,
    room_id,
    user_id,
  }) async {
    const endpoint = '/api/Removeadminroom';
    const operation = 'Remove admin from room';

    try {
      final String? userId = _requestValue(user_id);
      final String? roomId = _requestValue(room_id);

      if (!_hasRequiredValues([userId, roomId])) {
        _apiChairLog(
          '$operation aborted',
          'reason=missing_required_value',
        );
        return false;
      }

      _apiChairLog(
        '$operation request',
        'room=$roomId user=$userId',
      );

      final formData = FormData.fromMap({
        'user_id': userId,
        'room_id': roomId,
      });

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logApiResponse(
        operation: operation,
        endpoint: endpoint,
        response: response,
      );

      return _isSuccessfulResponse(response);
    } catch (error) {
      _logApiException(
        operation: operation,
        endpoint: endpoint,
        error: error,
      );

      showError(error, context);
      return false;
    }
  }

  // ============================================================
  // Invite user to chair / room
  // ============================================================

  Future<bool> InviteUserToSET({
    context,
    room_id,
    user_id,
  }) async {
    const endpoint = '/api/Inviteuser';
    const operation = 'Invite user';

    try {
      final String? userId = _requestValue(user_id);
      final String? roomId = _requestValue(room_id);

      if (!_hasRequiredValues([userId, roomId])) {
        _apiChairLog(
          '$operation aborted',
          'reason=missing_required_value',
        );
        return false;
      }

      _apiChairLog(
        '$operation request',
        'room=$roomId user=$userId',
      );

      final formData = FormData.fromMap({
        'user_id': userId,
        'room_id': roomId,
      });

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logApiResponse(
        operation: operation,
        endpoint: endpoint,
        response: response,
      );

      return _isSuccessfulResponse(response);
    } catch (error) {
      _logApiException(
        operation: operation,
        endpoint: endpoint,
        error: error,
      );

      showError(error, context);
      return false;
    }
  }

  // ============================================================
  // Lock / unlock chair
  // ============================================================

  Future<bool> LockChair({
    Chair_id,
    int? Lock,
    RoomModel? Roominfo,
  }) async {
    const endpoint = '/api/LockChair';
    const operation = 'Lock chair';

    try {
      final String? chairId = _requestValue(Chair_id);
      final String? roomId = _requestValue(Roominfo?.id);
      final String? lockValue = _requestValue(Lock);

      if (!_hasRequiredValues([chairId, roomId, lockValue])) {
        _apiChairLog(
          '$operation aborted',
          'reason=missing_required_value',
        );
        return false;
      }

      _apiChairLog(
        '$operation request',
        'room=$roomId chair=$chairId lock=$lockValue',
      );

      final formData = FormData.fromMap({
        'chair_id': chairId,
        'room_id': roomId,
        'Lock': lockValue,
      });

      final Response response = await dio.post(
        endpoint,
        data: formData,
      );

      _logApiResponse(
        operation: operation,
        endpoint: endpoint,
        response: response,
      );

      final success = _isSuccessfulResponse(response);

      if (!success) {
        _apiChairLog(
          '$operation rejected',
          'room=$roomId chair=$chairId lock=$lockValue',
        );
      }

      return success;
    } catch (error) {
      _logApiException(
        operation: operation,
        endpoint: endpoint,
        error: error,
      );

      return false;
    }
  }
}