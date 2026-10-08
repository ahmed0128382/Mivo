import 'dart:io';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';
/// Shared error helpers for Roomapi import 'room_api_error_mixin.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiCreateMixin on RoomApiStateMixin {
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
      final exception = handleError(e);

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

      showRegisterError(e, context);
    } catch (e, stackTrace) {
      final exception = handleError(e);

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

}
