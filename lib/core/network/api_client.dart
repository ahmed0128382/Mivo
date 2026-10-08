import 'package:dio/dio.dart';

import '../../util/app_constants.dart';
import 'api_interceptors.dart';

class ApiClient {
  ApiClient._internal();

  static final ApiClient instance = ApiClient._internal();

  late final Dio dio = _createDio();

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.BASE_URL,

        connectTimeout: const Duration(
          seconds: 20,
        ),

        sendTimeout: const Duration(
          seconds: 20,
        ),

        receiveTimeout: const Duration(
          seconds: 30,
        ),

        headers: {
          'Accept': 'application/json',
        },

        validateStatus: (status) {
          return status != null &&
              status >= 200 &&
              status < 300;
        },
      ),
    );

    dio.interceptors.add(
      ApiInterceptors(),
    );

    return dio;
  }
}