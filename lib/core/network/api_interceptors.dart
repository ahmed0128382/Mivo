import 'package:dio/dio.dart';

import '../../util/app_constants.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // ============================================================
    // GLOBAL HEADERS
    // Applied automatically to EVERY API request.
    // ============================================================

    options.headers['Accept'] = 'application/json';

    // Static application/device headers.
    options.headers['DeviceId'] = deviceId;
    options.headers['awqeASERQW'] = '8/325*mAIOEN';

    // Dynamic authentication/session headers.
    if (Token != null && Token.toString().trim().isNotEmpty) {
      options.headers['Authorization'] = Token.toString();
    } else {
      options.headers.remove('Authorization');
    }

    if (UserId != null && UserId.toString().trim().isNotEmpty) {
      options.headers['userid'] = UserId.toString();
    } else {
      options.headers.remove('userid');
    }

    if (UserIP != null && UserIP.toString().trim().isNotEmpty) {
      options.headers['UserIP'] = UserIP.toString();
    } else {
      options.headers.remove('UserIP');
    }

    _logRequest(options);

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logResponse(response);

    handler.next(response);
  }

  @override
  void onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) {
    _logError(error);

    handler.next(error);
  }

  // ============================================================
  // REQUEST LOG
  // ============================================================

  void _logRequest(RequestOptions options) {
    print('');
    print('╔════════════════ API REQUEST ════════════════');
    print('║ ${options.method} ${options.uri}');

    print('║ Headers:');
    print(
      '║   Authorization: '
      '${options.headers['Authorization'] != null ? 'PRESENT (${options.headers['Authorization'].toString().length} chars)' : 'MISSING'}',
    );
    print('║   userid: ${options.headers['userid'] ?? 'MISSING'}');
    print('║   UserIP: ${options.headers['UserIP'] ?? 'MISSING'}');
    print('║   DeviceId: ${options.headers['DeviceId'] ?? 'MISSING'}');
    print(
      '║   awqeASERQW: '
      '${options.headers['awqeASERQW'] != null ? 'PRESENT' : 'MISSING'}',
    );
    print('║   Accept: ${options.headers['Accept'] ?? 'MISSING'}');

    if (options.queryParameters.isNotEmpty) {
      print('║ Query: ${options.queryParameters}');
    }

    if (options.data != null) {
      print('║ Body: ${_sanitize(options.data)}');
    }

    print('╚════════════════════════════════════════════');
  }

  // ============================================================
  // RESPONSE LOG
  // ============================================================

  void _logResponse(Response response) {
    print('');
    print('╔════════════════ API RESPONSE ══════════════');

    print(
      '║ ${response.statusCode} '
      '${response.requestOptions.method} '
      '${response.requestOptions.uri}',
    );

    print('║ Data: ${_sanitize(response.data)}');

    print('╚════════════════════════════════════════════');
  }

  // ============================================================
  // ERROR LOG
  // ============================================================

  void _logError(DioException error) {
    final request = error.requestOptions;
    final response = error.response;

    print('');
    print('╔════════════════ API ERROR ═════════════════');

    print(
      '║ ${request.method} ${request.uri}',
    );

    print(
      '║ DioError: ${error.type}',
    );

    print(
      '║ Status: ${response?.statusCode}',
    );

    print(
      '║ Message: ${error.message}',
    );

    print('║ Headers:');
    print(
      '║   Authorization: '
      '${request.headers['Authorization'] != null ? 'PRESENT (${request.headers['Authorization'].toString().length} chars)' : 'MISSING'}',
    );
    print(
      '║   userid: ${request.headers['userid'] ?? 'MISSING'}',
    );
    print(
      '║   UserIP: ${request.headers['UserIP'] ?? 'MISSING'}',
    );
    print(
      '║   DeviceId: ${request.headers['DeviceId'] ?? 'MISSING'}',
    );
    print(
      '║   awqeASERQW: '
      '${request.headers['awqeASERQW'] != null ? 'PRESENT' : 'MISSING'}',
    );

    if (request.queryParameters.isNotEmpty) {
      print(
        '║ Query: ${request.queryParameters}',
      );
    }

    if (request.data != null) {
      print(
        '║ Body: ${_sanitize(request.data)}',
      );
    }

    if (response?.data != null) {
      print(
        '║ Server Response: '
        '${_sanitize(response?.data)}',
      );
    }

    print('╚════════════════════════════════════════════');
  }

  // ============================================================
  // SANITIZE SENSITIVE DATA
  // ============================================================

  dynamic _sanitize(dynamic data) {
    if (data is Map) {
      final result = Map<String, dynamic>.from(data);

      const sensitiveKeys = {
        'authorization',
        'token',
        'access_token',
        'refresh_token',
        'password',
        'api_key',
        'apikey',
      };

      for (final key in result.keys.toList()) {
        if (sensitiveKeys.contains(
          key.toString().toLowerCase(),
        )) {
          result[key] = '***REDACTED***';
        }
      }

      return result;
    }

    return data;
  }
}