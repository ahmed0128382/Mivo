part of 'user_api.dart';

// Gifts and related lists
mixin UserApiGifts on _UserApiBase {
  Future<List<usergifts>> GetUserGifts({
    context,
  }) async {
    try {
      Response response2 = await dio.get(
        '/api/GetMyUserGifts/$UserId',
      );

      if (response2.statusCode == 200) {
        List list = response2.data['UserGifts'];

        list.forEach((element) {
          UserGifts.add(
            usergifts.fromJson(element),
          );
        });
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }

        if (errNum == '3500') {
          // Preserve existing behavior.
        }
      }
    }

    return UserGifts;
  }

  Future<List> MyGifts({
    context,
  }) async {
    List data = [];

    try {
      FormData formData =
          FormData.fromMap({
        "user_id": UserId.toString(),
      });

      Response response2 = await dio.post(
        '/api/mygifts',
        data: formData,
      );

      if (response2.statusCode == 200) {
        List list =
            response2.data['users']
                ['giftssent'];

        list.forEach((element) {
          giftssent.add(
            Gifts.fromJson(element),
          );
        });

        List list2 =
            response2.data['users']
                ['giftscollect'];

        list2.forEach((element) {
          giftscollect.add(
            Gifts.fromJson(element),
          );
        });

        data.add(giftssent);
        data.add(giftscollect);
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }
      }
    }

    return data;
  }

  Future<List<Notificationmodel>> UserNotification({
    context,
  }) async {
    try {
      Response response2 = await dio.get(
        '/api/GetUserNotification',
      );

      if (response2.statusCode == 200) {
        List list =
            response2.data['UserNotifications'];

        list.forEach((element) {
          Notifications.add(
            Notificationmodel.fromJson(element),
          );
        });
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }

        if (errNum == '3500') {
          // Preserve existing behavior.
        }
      }
    }

    return Notifications;
  }

}
