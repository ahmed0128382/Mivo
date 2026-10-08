import 'package:ahlachat/Repositores/Shop_repositores/ShopRepository.dart';
import 'package:ahlachat/models/RelationModel.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/MyItemModel.dart';
import '../../models/ShopModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';

class Relationapi extends ShopRepository {
  final Dio _dio = ApiClient.instance.dio;

  final List<RelationModel> UserRelations = [];

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

  Future<int> SendRelations({
    user_id,
    Relationid,
    context,
  }) async {
    int check = 0;

    try {
      final formData = FormData.fromMap({
        'sender_id': UserId.toString(),
        'user_id': user_id.toString(),
        'Relation_id': Relationid.toString(),
      });

      final response = await _dio.post(
        'api/SendRelation',
        data: formData,
      );

      if (response.statusCode == 200) {
        if (response.data['status'] == 'done') {
          check = 1;
        } else {
          Dialogs().showtoast(
            'لقد قمت بارسالها من قبل',
          );
          check = 2;
        }
      } else {
        check = 0;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      check = 0;
    }

    return check;
  }

  Future<bool> RemoveRelations({
    id,
    context,
  }) async {
    try {
      final formData = FormData.fromMap({
        'id': id.toString(),
      });

      final response = await _dio.post(
        'api/RemoveRelation',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> AcceptRelations({
    id,
    userid,
    context,
  }) async {
    print(id.toString());
    print(userid.toString());

    try {
      final formData = FormData.fromMap({
        'id': id.toString(),
        'user_id': UserId.toString(),
      });

      final response = await _dio.post(
        'api/AcceptRelation',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> LeaveRelations({
    id,
    context,
  }) async {
    print(id.toString());

    try {
      final formData = FormData.fromMap({
        'id': id.toString(),
        'user_id': UserId.toString(),
      });

      final response = await _dio.post(
        'api/LeaveRelation',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<List<RelationModel>> GetUserRelation({
    context,
  }) async {
    try {
      final response = await _dio.get(
        '/api/UserRelations/$UserId',
      );

      print(response.data);

      if (response.statusCode == 200) {
        final List list = response.data ?? [];

        UserRelations.clear();

        for (final element in list) {
          UserRelations.add(
            RelationModel.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return UserRelations;
  }

  Future<bool> SendByeShop({
    itemId,
    day,
    price,
    userid,
    context,
    categoryid,
  }) async {
    try {
      final formData = FormData.fromMap({
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

      return response.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> RemoveFrame({
    context,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
      });

      final response = await _dio.post(
        'api/removeframe',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);

      print(exception);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

        if (errNum != null) {
          print(errNum);

          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }

      return false;
    }
  }
}