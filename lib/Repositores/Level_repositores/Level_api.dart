import 'package:ahlachat/models/AchiveModel.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/LevelGifts.dart';
import '../Moment_repositores/Moment_repository.dart';

class Levelapi extends MomentRepository {
  final Dio _dio = ApiClient.instance.dio;

  final List<AchiveModels> AchiveModelss = [];

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;

      return ApiException(
        statusCode: response?.statusCode,
        message: response?.data?['message']?.toString() ??
            response?.data?['error']?.toString() ??
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

  Future<List<AchiveModels>> GetModels() async {
    try {
      final response = await _dio.get(
        '/api/GetModels',
      );

      final List list = response.data['Models'] ?? [];

      AchiveModelss.clear();

      for (final element in list) {
        AchiveModelss.add(
          AchiveModels.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return AchiveModelss;
  }
}