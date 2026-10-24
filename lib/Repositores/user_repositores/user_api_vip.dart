part of 'user_api.dart';

// VIP purchase, use, remove, and custom ID
mixin UserApiVip on _UserApiBase {
  Future<bool> UpdateNewId({
    newid,
    context,
    myvip_id,
  }) async {
    bool check = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "newid": newid.toString(),
        "myvip_id": myvip_id.toString(),
      });

      Response response2 = await dio.post(
        'api/SetNewId',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = false;

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return check;
  }

  Future<MyVipmodel?> ByeVip({
    VipModel? Vip,
    context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "vip_id": Vip?.id.toString(),
        "days": Vip?.day.toString(),
        "cost": Vip?.cost.toString(),
      });

      Response response2 = await dio.post(
        'api/ByeVip',
        data: formData,
      );

      if (response2.statusCode == 200) {
        myvip = MyVipmodel.fromJson(
          response2.data['MyVip'],
        );
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
          print(errNum);

          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return myvip;
  }

  Future<MyVipmodel?> UseVip({
    MyVipmodel? Vip,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "Myvip_id": Vip?.id.toString(),
      });

      Response response2 = await dio.post(
        'api/UseVip',
        data: formData,
      );

      if (response2.statusCode == 200) {
        myvip = MyVipmodel.fromJson(
          response2.data,
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return myvip;
  }

  Future<bool> ByeBackages({
    coins,
    cost,
    kind,
    context,
  }) async {
    bool Status = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "coins": coins.toString(),
        "method": kind.toString(),
        "cost": cost.toString(),
      });

      Response response2 = await dio.post(
        'api/shippingccount',
        data: formData,
      );

      if (response2.statusCode == 200) {
        Status = true;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      Status = false;

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          print(errNum);

          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return Status;
  }

  Future<bool?> RemoveVip({
    MyVipmodel? MyVip,
  }) async {
    bool remove = false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "Myvip_id": MyVip?.id.toString(),
      });

      Response response2 = await dio.post(
        'api/RemoveVip',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200) {
        remove = true;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      remove = false;
    }

    return remove;
  }

}
