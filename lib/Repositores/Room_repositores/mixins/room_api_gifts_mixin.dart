import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
/// Shared error helpers for Roomapi import 'room_api_error_mixin.dart';
import 'room_api_state_mixin.dart';

mixin RoomApiGiftsMixin on RoomApiStateMixin {
  Future<bool> SendGift({
    context,
    Roomid,
    Listuser,
    giftid,
    quantity,
    Cost,
  }) async {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    bool send = true;

    try {
      final FormData formData = FormData.fromMap({
        'Listuser': Listuser.toString(),
        'room_id': Roomid.toString(),
        'user_id': UserId.toString(),
        'quantity': quantity.toString(),
        'gift_id': giftid.toString(),
        'Cost': Cost.toString(),
      });

      final Response response2 = await dio.post(
        '/api/sentGift',
        data: formData,
      );

      if (response2.statusCode == 200) {
        user.Updatecoins(
          coins: int.parse(
            response2.data['user']['coins'].toString(),
          ),
        );

        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'SEND GIFT ERROR: $exception',
      );

      showRegisterError(e, context);
    }

    return send;
  }

  Future<String> SentLuckyGift({
    context,
    Roomid,
    Listuser,
    giftid,
    quantity,
    Cost,
  }) async {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    String prsantage = '';

    try {
      final FormData formData = FormData.fromMap({
        'Listuser': Listuser.toString(),
        'room_id': Roomid.toString(),
        'user_id': UserId.toString(),
        'quantity': quantity.toString(),
        'gift_id': giftid.toString(),
        'Cost': Cost.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SentLuckyGift',
        data: formData,
      );

      if (response2.statusCode == 200) {
        print(
          '=====================ReturnMyCOINS========>'
          '${response2.data['gain']['coins'].toString()}'
          '==================>',
        );

        print(
          '=====================ReturnWin========>'
          '${response2.data['gain']['ReturnedValue']['win'].toString()}'
          '==================>',
        );

        print(
          '=====================Persantagec========>'
          '${response2.data['gain']['ReturnedValue']['Persantage'].toString()}'
          '==================>',
        );

        if (response2.data['gain']['ReturnedValue']
                    ['Persantage'] !=
                0 &&
            response2.data['gain']['ReturnedValue']
                    ['Persantage'] !=
                '0') {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).addComboWin(
            amount: response2.data['gain']['ReturnedValue']
                ['win'],
            persantage: response2.data['gain']
                ['ReturnedValue']['Persantage'],
          );
        }

        user.Updatecoins(
          coins: int.parse(
            response2.data['gain']['coins'].toString(),
          ),
        );

        prsantage = response2.data['gain']
                ['ReturnedValue']['win']
            .toString();

        print(response2.data['gain']);
      } else {
        prsantage = '';
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'SEND LUCKY GIFT ERROR: $exception',
      );

      prsantage = '';
    }

    return prsantage;
  }

  Future<String> SentCompoGift({
    context,
    Roomid,
    Listuser,
    giftid,
    quantity,
    Cost,
  }) async {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    String prsantage = '';

    try {
      final FormData formData = FormData.fromMap({
        'Listuser': Listuser.toString(),
        'room_id': Roomid.toString(),
        'user_id': UserId.toString(),
        'quantity': quantity.toString(),
        'gift_id': giftid.toString(),
        'Cost': Cost.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SentCompo',
        data: formData,
      );

      if (response2.statusCode == 200) {
        print(
          '=====================ReturnMyCOINS========>'
          '${response2.data['gain']['coins'].toString()}'
          '==================>',
        );

        print(
          '=====================ReturnWin========>'
          '${response2.data['gain']['ReturnedValue']['win'].toString()}'
          '==================>',
        );

        print(
          '=====================Persantagec========>'
          '${response2.data['gain']['ReturnedValue']['Persantage'].toString()}'
          '==================>',
        );

        if (response2.data['gain']['ReturnedValue']
                    ['Persantage'] !=
                0 &&
            response2.data['gain']['ReturnedValue']
                    ['Persantage'] !=
                '0') {
          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).addComboWin(
            amount: response2.data['gain']['ReturnedValue']
                ['win'],
            persantage: response2.data['gain']
                ['ReturnedValue']['Persantage'],
          );
        }

        user.Updatecoins(
          coins: int.parse(
            response2.data['gain']['coins'].toString(),
          ),
        );

        prsantage = response2.data['gain']
                ['ReturnedValue']['win']
            .toString();

        print(response2.data['gain']);
      } else {
        prsantage = '';
      }
    } catch (e) {
      final exception = handleError(e);

      print(
        'SEND COMPO GIFT ERROR: $exception',
      );

      prsantage = '';

      showRegisterError(e, context);
    }

    return prsantage;
  }

  Future<bool> SendEmoje({
    context,
    Emoje,
    Room_id,
  }) async {
    print(Emoje.toString());

    bool send = true;

    try {
      final FormData formData = FormData.fromMap({
        'emoji': Emoje.toString(),
        'room_id': Room_id.toString(),
        'user_id': UserId.toString(),
      });

      final Response response2 = await dio.post(
        '/api/Sendemoji',
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
        'SEND EMOJI ERROR: $exception',
      );

      showRegisterError(e, context);
    }

    return send;
  }

  Future<bool> SentImageRoom({
    context,
    image,
    Room_id,
  }) async {
    bool send = true;

    try {
      final FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        'room_id': Room_id.toString(),
        'user_id': UserId.toString(),
      });

      final Response response2 = await dio.post(
        '/api/SendImage',
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
        'SEND ROOM IMAGE ERROR: $exception',
      );

      showRegisterError(e, context);
    }

    return send;
  }

}
