import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
/// Shared error helpers for Roomapi import 'room_api_error_mixin.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiJoinMixin on RoomApiStateMixin {
  Future<RoomModel> joinRooms({
    context,
    Roomid,
  }) async {
    final RoomViewmodel Roomss =
        Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': Roomid.toString(),
      });

      print(
        '========== JOIN ROOM REQUEST ==========',
      );

      print('METHOD: POST');

      print(
        'URL: ${dio.options.baseUrl}/api/JoinRoom',
      );

      print('USER ID: $UserId');

      print(
        'ROOM DB ID REQUESTED: $Roomid',
      );

      print(
        '=======================================',
      );

      final Response response2 = await dio.post(
        '/api/JoinRoom',
        data: formData,
      );

      print(
        '========== JOIN ROOM RESPONSE ==========',
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
        '========================================',
      );

      if (response2.statusCode == 200) {
        print('Join Response received');

        final dynamic roomData =
            response2.data['Room'];

        if (roomData == null) {
          print(
            'JOIN ROOM ERROR: response.data["Room"] is null',
          );

          return Roominfo;
        }

        Roominfo = RoomModel.fromJson(
          roomData,
        );

        Joinid = roomData['joinid'];

        print(
          '========== JOIN ROOM PARSED ==========',
        );

        print(
          'DB ID: ${Roominfo.id}',
        );

        print(
          'PUBLIC RoomID: ${Roominfo.RoomID}',
        );

        print(
          'JOIN ID: $Joinid',
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
          '======================================',
        );

        Roomss.clearcompo();
        Roomss.hidewaitingtimer2();

        print(
          'JOIN ID IS $Joinid',
        );
      }
    } on DioException catch (e, stackTrace) {
      final exception = handleError(e);

      print(
        '========== JOIN ROOM DIO ERROR ==========',
      );

      print(
        'TYPE: ${e.type}',
      );

      print(
        'METHOD: ${e.requestOptions.method}',
      );

      print(
        'URL: ${e.requestOptions.uri}',
      );

      print(
        'STATUS: ${e.response?.statusCode}',
      );

      print(
        'RESPONSE DATA: ${e.response?.data}',
      );

      print(
        'MESSAGE: ${e.message}',
      );

      print(
        'STACK: $stackTrace',
      );

      print(
        'API EXCEPTION: $exception',
      );

      print(
        '=========================================',
      );

      if (e.response?.data is Map) {
        print(
          'JOIN ROOM ERROR NUM: '
          '${e.response?.data['errNum']}',
        );

        print(
          'JOIN ROOM ERROR MESSAGE: '
          '${e.response?.data['msg']}',
        );

        if (context != null) {
          Dialogs().ShowErrorRegesterToast(
            e.response?.data['errNum'],
            context,
          );
        }
      }
    } catch (e, stackTrace) {
      final exception = handleError(e);

      print(
        '========== JOIN ROOM UNKNOWN ERROR '
        '==========',
      );

      print('ERROR: $e');

      print('STACK: $stackTrace');

      print(
        'API EXCEPTION: $exception',
      );

      print(
        '=============================================',
      );
    }

    return Roominfo;
  }

}
