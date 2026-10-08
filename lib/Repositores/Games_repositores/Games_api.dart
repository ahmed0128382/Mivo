import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/GameModel.dart';
import '../../util/Dialogs.dart';
import '../Moment_repositores/Moment_repository.dart';

int GameIndex = 2;

class Gamesapi extends MomentRepository {
  final Dio _dio = ApiClient.instance.dio;

  final List<GamesModel> GamesList = [];

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

  Future<List<GamesModel>> AllGames(context) async {
    GameIndex = 2;

    try {
      final response = await _dio.get(
        '/api/GetAllGames',
      );

      final List list = response.data['games']['data'] ?? [];

      GamesList.clear();

      for (final element in list) {
        GamesList.add(
          GamesModel.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

      print(exception);
    }

    return GamesList;
  }

  Future<List<GamesModel>> GetMoreGames(context) async {
    try {
      final response = await _dio.get(
        '/api/GetAllGames?page=${GameIndex.toString()}',
      );

      final List list = response.data['games']['data'] ?? [];

      if (list.isNotEmpty) {
        GameIndex++;
      }

      for (final element in list) {
        GamesList.add(
          GamesModel.fromJson(element),
        );
      }

      print(GamesList);
    } catch (e) {
      final exception = _handleError(e);

      if (e is DioException) {
        final errNum = e.response?.data?['errNum'];

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

      print(exception);
    }

    return GamesList;
  }

  Future<bool> Increament({
    id,
  }) async {
    try {
      await _dio.get(
        '/api/incrementuser/$id',
      );
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return true;
  }
}