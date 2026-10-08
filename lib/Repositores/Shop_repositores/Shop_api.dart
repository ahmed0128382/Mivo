import 'package:ahlachat/Repositores/Shop_repositores/ShopRepository.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/MyItemModel.dart';
import '../../models/ShopModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';

class shopapi extends ShopRepository {
  final Dio _dio = ApiClient.instance.dio;

  Shop shop = Shop();

  List<Shop> AllShop = [];
  List<Salesmodel> AllMyItems = [];

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;

      return ApiException(
        statusCode: response?.statusCode,
        message: response?.data?['message']?.toString() ??
            response?.data?['error']?.toString() ??
            response?.data?['errNum']?.toString() ??
            error.message ??
            'Something went wrong',
        data: response?.data,
      );
    }

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }

  Future<List<Shop>> getShop({context}) async {
    try {
      final response = await _dio.get(
        '/api/GetShopCategory',
      );

      final List list = response.data['ShopCategory'] ?? [];

      AllShop.clear();

      for (final element in list) {
        AllShop.add(
          Shop.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }
      }
    }

    return AllShop;
  }

  Future<bool> ByeItem({
    itemId,
    day,
    price,
    context,
    categoryid,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'item_id': itemId.toString(),
        'user_id': UserId.toString(),
        'day': day.toString(),
        'price': price.toString(),
        'category_id': categoryid.toString(),
      });

      final response = await _dio.post(
        'api/byeitem',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<bool> SendByeShop({
    itemId,
    day,
    price,
    userid,
    context,
    categoryid,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'item_id': itemId.toString(),
        'user_id': UserId.toString(),
        'reciver': userid.toString(),
        'day': day.toString(),
        'price': price.toString(),
        'category_id': categoryid.toString(),
      });

      final response = await _dio.post(
        'api/SendItem',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);
    }

    return check;
  }

  Future<bool> UpdateFrame({
    Frame,
    context,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'frame': Frame.toString(),
      });

      final response = await _dio.post(
        'api/Setframe',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<bool> UpdateEnterbubles({
    Frame,
    context,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'frame': Frame.toString(),
      });

      final response = await _dio.post(
        'api/SetEnterbubles',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<bool> Updateprofilebubles({
    Frame,
    context,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'frame': Frame.toString(),
      });

      final response = await _dio.post(
        'api/Setprofilebubles',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<bool> RemoveFrame({
    context,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
      });

      final response = await _dio.post(
        'api/removeframe',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<bool> UpdateEntry({
    Entry,
    context,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'entry': Entry.toString(),
      });

      final response = await _dio.post(
        'api/SetEntry',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<bool> RemoveEntry({
    context,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
      });

      final response = await _dio.post(
        'api/removeEntry',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<bool> RemoveEnterbubles({
    context,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
      });

      final response = await _dio.post(
        'api/removeEnterbubles',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<bool> RemoveProfilebubles({
    context,
  }) async {
    bool check = false;

    try {
      final FormData formData = FormData.fromMap({
        'user_id': UserId.toString(),
      });

      final response = await _dio.post(
        'api/RemoveProfilebubles',
        data: formData,
      );

      if (response.statusCode == 200) {
        check = true;
      } else {
        check = false;
      }
    } catch (e) {
      check = false;

      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

  Future<List<Salesmodel>> GetMyBag() async {
    try {
      final response = await _dio.get(
        '/api/GetuserShopCategory/${UserId.toString()}',
      );

      if (response.statusCode == 200) {
        final List list = response.data['MyitemsCategory'] ?? [];

        AllMyItems.clear();

        for (final element in list) {
          AllMyItems.add(
            Salesmodel.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return AllMyItems;
  }
}