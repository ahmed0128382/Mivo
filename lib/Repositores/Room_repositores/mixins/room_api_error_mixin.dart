import 'package:ahlachat/core/network/api_exception.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:dio/dio.dart';

mixin RoomApiErrorMixin {
  ApiException handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;
      final responseData = response?.data;

      String message = 'Something went wrong';

      if (responseData is Map) {
        message =
            responseData['message']?.toString() ??
            responseData['msg']?.toString() ??
            responseData['error']?.toString() ??
            responseData['errNum']?.toString() ??
            message;
      } else if (error.message != null &&
          error.message!.trim().isNotEmpty) {
        message = error.message!;
      }

      return ApiException(
        statusCode: response?.statusCode,
        message: message,
        data: responseData,
      );
    }

    if (error is ApiException) {
      return error;
    }

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }

  dynamic errorData(dynamic error) {
    if (error is DioException) {
      return error.response?.data;
    }

    if (error is ApiException) {
      return error.data;
    }

    return null;
  }

  dynamic errorNumber(dynamic error) {
    final data = errorData(error);

    if (data is Map) {
      return data['errNum'];
    }

    return null;
  }

  void showRegisterError(dynamic error, context) {
    final errNum = errorNumber(error);

    if (errNum != null && context != null) {
      Dialogs().ShowErrorRegesterToast(
        errNum,
        context,
      );
    }
  }

  void showError(dynamic error, context) {
    final data = errorData(error);

    if (data is Map) {
      final errNum = data['errNum'];

      if (errNum != null && context != null) {
        Dialogs().ShowErrorToast(
          errNum,
          context,
        );
      }
    }
  }

}