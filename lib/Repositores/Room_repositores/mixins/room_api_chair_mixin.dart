
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';

/// Shared error helpers for Roomapi import 'room_api_error_mixin.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiChairMixin on RoomApiStateMixin {
  Future<bool> joinChair({
    context,
    index,
    room_id,
    chair_id,
  }) async {
    bool joicchair = false;

    try {
      print('xxxxxxxxxxxxxxxxx');
      print(UserId.toString());
      print(room_id.toString());
      print(chair_id.toString());

      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': room_id.toString(),
        'chair_id': chair_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/JoinChair',
        data: formData,
      );

      print(
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
      );

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        joicchair = true;
      } else {
        print(
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        );

        joicchair = false;
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'JOIN CHAIR ERROR: $exception',
      );

      showRegisterError(e, context);
    }

    return joicchair;
  }

  Future<bool> ChangeChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) async {
    bool joicchair = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': room_id.toString(),
        'Current_chair': CurrentChairid.toString(),
        'chair_id': NewCharid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/ChangeChair',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        joicchair = true;
      } else {
        joicchair = false;
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'CHANGE CHAIR ERROR: $exception',
      );
    }

    return joicchair;
  }

  Future<bool> AdminChangeChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) async {
    bool joicchair = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': room_id.toString(),
        'Current_chair': CurrentChairid.toString(),
        'chair_id': NewCharid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/AdminChangeChair',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        joicchair = true;
      } else {
        joicchair = false;
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'ADMIN CHANGE CHAIR ERROR: $exception',
      );
    }

    return joicchair;
  }

  Future<bool> ReturnAdminChair({
    context,
    index,
    room_id,
    NewCharid,
    CurrentChairid,
  }) async {
    bool joicchair = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'room_id': room_id.toString(),
        'Current_chair': CurrentChairid.toString(),
        'chair_id': NewCharid.toString(),
      });

      final Response response2 = await dio.post(
        '/api/ReturntoAdminChair',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        joicchair = true;
      } else {
        joicchair = false;
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'RETURN ADMIN CHAIR ERROR: $exception',
      );
    }

    return joicchair;
  }

  Future<bool> KickJoinadminuser({
    context,
    room_id,
    user_id,
  }) async {
    bool update = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Removeadminroom',
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
        'KICK JOIN ADMIN USER ERROR: $exception',
      );

      showError(e, context);
    }

    return update;
  }

  Future<bool> InviteUserToSET({
    context,
    room_id,
    user_id,
  }) async {
    bool update = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': user_id.toString(),
        'room_id': room_id.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Inviteuser',
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
        'INVITE USER ERROR: $exception',
      );

      showError(e, context);
    }

    return update;
  }

  Future<bool> LockChair({
    Chair_id,
    int? Lock,
    RoomModel? Roominfo,
  }) async {
    bool update = false;

    try {
      final FormData formData = FormData.fromMap({
        'chair_id': Chair_id.toString(),
        'room_id': Roominfo?.id.toString(),
        'Lock': Lock.toString(),
      });

      final Response response2 = await dio.post(
        '/api/LockChair',
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
        'LOCK CHAIR ERROR: $exception',
      );
    }

    return update;
  }

}
