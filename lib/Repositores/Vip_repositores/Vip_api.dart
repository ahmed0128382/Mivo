import 'package:ahlachat/models/MyVip.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/VipModel.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';

class Vipapi extends MomentRepository {
  final Dio _dio = ApiClient.instance.dio;

  List<VipModel> Vips = [];
  List<MyVipmodel> MyVips = [];

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;

      dynamic responseData = response?.data;

      String? message;

      if (responseData is Map) {
        message =
            responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            responseData['errNum']?.toString();
      }

      return ApiException(
        statusCode: response?.statusCode,
        message:
            message ??
            error.message ??
            'Something went wrong',
        data: responseData,
      );
    }

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }

  Future<List<VipModel>> GetVips() async {
    // Prevent duplicate entries when this method is called again.
    Vips.clear();

    try {
      print('');
      print('========== GET VIPS ==========');
      print('GET /api/GetVip');
      print('USER ID: ${UserId ?? 'NULL'}');
      print('TOKEN PRESENT: '
          '${Token != null && Token.toString().trim().isNotEmpty}');
      print('==============================');

      final Response response = await _dio.get(
        '/api/GetVip',
      );

      print('');
      print('========== GET VIPS RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');
      print('=======================================');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['Vip'] is List) {
          final List list = data['Vip'];

          for (final element in list) {
            if (element is Map) {
              Vips.add(
                VipModel.fromJson(
                  Map<String, dynamic>.from(element),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      final exception = _handleError(e);

      print('');
      print('========== GET VIPS ERROR ==========');
      print(exception);

      if (e is DioException) {
        print('TYPE: ${e.type}');
        print('STATUS: ${e.response?.statusCode}');
        print('MESSAGE: ${e.message}');
        print('RESPONSE: ${e.response?.data}');
      }

      print('====================================');
    }

    return Vips;
  }

  Future<List<MyVipmodel>> GetMyVips() async {
    // Prevent duplicate entries when this method is called again.
    MyVips.clear();

    final String userId = UserId?.toString().trim() ?? '';

    if (userId.isEmpty) {
      print('');
      print('========== GET MY VIPS ==========');
      print('SKIPPED: UserId is empty');
      print('=================================');

      return MyVips;
    }

    try {
      print('');
      print('========== GET MY VIPS ==========');
      print('GET /api/GetMyVips/$userId');
      print('USER ID: $userId');
      print('TOKEN PRESENT: '
          '${Token != null && Token.toString().trim().isNotEmpty}');
      print('=================================');

      final Response response = await _dio.get(
        '/api/GetMyVips/$userId',
      );

      print('');
      print('========== GET MY VIPS RESPONSE ==========');
      print('STATUS: ${response.statusCode}');
      print('DATA: ${response.data}');
      print('==========================================');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['MyVip'] is List) {
          final List list = data['MyVip'];

          for (final element in list) {
            if (element is Map) {
              MyVips.add(
                MyVipmodel.fromJson(
                  Map<String, dynamic>.from(element),
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      final exception = _handleError(e);

      print('');
      print('========== GET MY VIPS ERROR ==========');
      print(exception);

      if (e is DioException) {
        print('TYPE: ${e.type}');
        print('STATUS: ${e.response?.statusCode}');
        print('MESSAGE: ${e.message}');
        print('RESPONSE: ${e.response?.data}');
      }

      print('=======================================');
    }

    return MyVips;
  }
}