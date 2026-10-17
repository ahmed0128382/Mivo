import 'dart:io';

import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'room_api_state_mixin.dart';

mixin RoomApiCreateMixin on RoomApiStateMixin {
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
      if (image == null || backgroundimage == null) {
        if (kDebugMode) {
          debugPrint(
            '[CREATE_ROOM] Room image and background image are required.',
          );
        }

        return Roominfo;
      }

      final String imagePath =
          image is File ? image.path : image.path.toString();

      final String backgroundPath =
          backgroundimage is File
              ? backgroundimage.path
              : backgroundimage.path.toString();

      final File roomImageFile = File(imagePath);
      final File backgroundImageFile = File(backgroundPath);

      if (!await roomImageFile.exists() ||
          !await backgroundImageFile.exists()) {
        if (kDebugMode) {
          debugPrint(
            '[CREATE_ROOM] One or more selected image files do not exist.',
          );
        }

        return Roominfo;
      }

      final MultipartFile roomMultipart =
          await MultipartFile.fromFile(
        roomImageFile.path,
        filename: roomImageFile.path.split('/').last,
      );

      final MultipartFile backgroundMultipart =
          await MultipartFile.fromFile(
        backgroundImageFile.path,
        filename: backgroundImageFile.path.split('/').last,
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

      final Response response = await dio.post(
        '/api/CreateRoom',
        data: formData,
      );

      final Map<String, dynamic>? responseData =
          _asStringMap(response.data);

      if (response.statusCode != 200 ||
          responseData == null ||
          !_isSuccessful(responseData)) {
        if (kDebugMode) {
          debugPrint(
            '[CREATE_ROOM] Creation failed: '
            'HTTP ${response.statusCode}, '
            'errNum=${responseData?['errNum']}',
          );
        }

        showRegisterError(response, context);
        return Roominfo;
      }

      final Map<String, dynamic>? roomData =
          _asStringMap(responseData['room']);

      if (roomData == null) {
        if (kDebugMode) {
          debugPrint(
            '[CREATE_ROOM] Successful response did not contain room.',
          );
        }

        return Roominfo;
      }

      final RoomModel createdRoom =
          RoomModel.fromJson(roomData);

      Roominfo = createdRoom;

      // The create response can already include the creator's membership.
      // Preserve the returned room membership as-is; never create a chair
      // or infer the creator's membership from chair data.
      final dynamic returnedJoinId = roomData['joinid'];

      if (returnedJoinId != null &&
          returnedJoinId.toString().trim().isNotEmpty &&
          returnedJoinId.toString() != 'null') {
        Joinid = returnedJoinId;
      }

      if (kDebugMode) {
        debugPrint(
          '[CREATE_ROOM] Success: '
          'roomId=${Roominfo.id}, '
          'publicRoomId=${Roominfo.RoomID}, '
          'adminId=${Roominfo.adminId}, '
          'hasToken=${Roominfo.Token?.isNotEmpty == true}',
        );
      }

      return Roominfo;
    } on DioException catch (error) {
      final exception = handleError(error);

      if (kDebugMode) {
        debugPrint(
          '[CREATE_ROOM] Request failed: '
          'type=${error.type}, '
          'status=${error.response?.statusCode}, '
          'exception=$exception',
        );
      }

      showRegisterError(error, context);
    } catch (error, stackTrace) {
      final exception = handleError(error);

      if (kDebugMode) {
        debugPrint(
          '[CREATE_ROOM] Unexpected error: ${error.runtimeType}; '
          '$exception',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    return Roominfo;
  }
}