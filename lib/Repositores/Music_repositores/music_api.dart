import 'dart:io';

import 'package:ahlachat/util/app_constants.dart';
import 'package:dio/dio.dart';
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
      final data = response?.data;

      String message = error.message ?? 'Music upload failed';

      if (data is Map) {
        message = data['message']?.toString() ??
            data['error']?.toString() ??
            message;
      } else if (data is String && data.trim().isNotEmpty) {
        message = data;
      }

      return ApiException(
        statusCode: response?.statusCode,
        message: message,
        data: data,
      );
    }

    if (error is ApiException) return error;

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }

  Future<usermusic> AddMusic({
    SongModel? Music,
  }) async {
    try {
      if (Music == null) {
        throw ApiException(message: 'Select a song before uploading.');
      }

      final path = Music.data.trim();
      if (path.isEmpty) {
        throw ApiException(message: 'The selected song has no file path.');
      }

      final file = File(path);
      if (!await file.exists()) {
        throw ApiException(message: 'The selected audio file no longer exists.');
      }

      final musicFile = await MultipartFile.fromFile(
        path,
        filename: path.split(Platform.pathSeparator).last,
      );

      final formData = FormData.fromMap({
        'music': musicFile,
        'user_id': UserId.toString(),
        'name': Music.title,
      });

      final response = await _dio.post(
        'api/AddUserMusic',
        data: formData,
      );

      final data = response.data;
      if (response.statusCode != 200 || data is! Map) {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'The server returned an unexpected music upload response.',
          data: data,
        );
      }

      final uploadedMusic = data['UserMusic'];
      if (uploadedMusic is! Map) {
        throw ApiException(
          statusCode: response.statusCode,
          message: data['message']?.toString() ??
              'The server response did not contain UserMusic.',
          data: data,
        );
      }

      return usermusic.fromJson(
        Map<String, dynamic>.from(uploadedMusic),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }
}
