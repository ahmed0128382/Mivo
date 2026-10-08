import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:on_audio_query/on_audio_query.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/UserMusic.dart';
import '../Moment_repositores/Moment_repository.dart';

class Musicapi extends MomentRepository {
  final Dio _dio = ApiClient.instance.dio;

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

  Future<usermusic> AddMusic({
    context,
    SongModel? Music,
  }) async {
    print(Music?.data.runtimeType);
    print(Music?.data);
    print('11111111111111111111111111111111111111111111');

    final musicFile = await MultipartFile.fromFile(
      Music?.data ?? '',
      filename: Music?.data.split('/').last,
    );

    print(musicFile);
    print(musicFile.runtimeType);
    print(musicFile.filename);

    usermusic? music;

    try {
      final formData = FormData.fromMap({
        'music': musicFile,
        'user_id': UserId.toString(),
        'name': Music?.title.toString(),
      });

      final response = await _dio.post(
        'api/AddUserMusic',
        data: formData,
      );

      if (response.statusCode == 200) {
        music = usermusic.fromJson(
          response.data['UserMusic'],
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return music!;
  }
}