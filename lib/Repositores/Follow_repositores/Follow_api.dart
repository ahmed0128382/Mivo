import 'package:ahlachat/Repositores/Follow_repositores/Follow_repository.dart';
import 'package:ahlachat/models/Followmodel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/Visitors.dart';
import '../../util/app_constants.dart';

class Followapi extends FollowRepository {
  final Dio _dio = ApiClient.instance.dio;

  final List<Follows> Myfans = [];
  final List<usermodel> Friends = [];
  final List<visitors> Myvisitors = [];

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

  Future<List<Follows>> GetFans(context) async {
    try {
      final response = await _dio.get(
        '/api/Getmyfollowers/$UserId',
      );

      final List list = response.data['Follow'] ?? [];

      Myfans.clear();

      for (final element in list) {
        Myfans.add(
          Follows.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Myfans;
  }

  Future<bool> SentShareRoom({
    userid,
    roomid,
  }) async {
    try {
      final map = {
        'user_id': userid.toString(),
        'room_id': roomid.toString(),
      };

      map.removeWhere(
        (key, value) => key == null || value == null,
      );

      final formData = FormData.fromMap(map);

      final response = await _dio.post(
        'api/SentShareRoom',
        data: formData,
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<List<visitors>> Getvisitors(context) async {
    try {
      final response = await _dio.get(
        '/api/Getmyvisitors/$UserId',
      );

      final List list = response.data['visitor'] ?? [];

      Myvisitors.clear();

      for (final element in list) {
        Myvisitors.add(
          visitors.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Myvisitors;
  }

  Future<List<visitors>> Getvisitors2({
    required context,
    id,
  }) async {
    try {
      final response = await _dio.get(
        '/api/Getmyvisitors/$id',
      );

      final List list = response.data['visitor'] ?? [];

      print(response.data['visitor']);

      Myvisitors.clear();

      for (final element in list) {
        Myvisitors.add(
          visitors.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Myvisitors;
  }

  Future<List<Follows>> GetFollowing(context) async {
    try {
      final response = await _dio.get(
        '/api/Getmyfollowing/$UserId',
      );

      final List list = response.data['Follow'] ?? [];

      Myfans.clear();

      for (final element in list) {
        Myfans.add(
          Follows.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Myfans;
  }

  Future<List<usermodel>> GetFriends(context) async {
    try {
      final response = await _dio.get(
        '/api/GetMyFriends/$UserId',
      );

      final List list = response.data ?? [];

      Friends.clear();

      for (final element in list) {
        Friends.add(
          usermodel.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Friends;
  }

  Future<bool> CheckFriends(id) async {
    try {
      final response = await _dio.get(
        '/api/CheckFrindstateFriends/$UserId/$id',
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<List<Follows>> GetShareFriends({
    Roomid,
  }) async {
    try {
      final response = await _dio.get(
        '/api/GetSharefrinds/$UserId/$Roomid',
      );

      print(response.data['Follow']);

      if (response.statusCode == 200) {
        final List list = response.data['Follow'] ?? [];

        SharedRoomIds = response.data['ShareIds'];

        Myfans.clear();

        for (final element in list) {
          Myfans.add(
            Follows.fromJson(element),
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Myfans;
  }

  Future<List<Follows>> GetFans2(
    context,
    id,
  ) async {
    try {
      final response = await _dio.get(
        '/api/Getmyfollowers/$id',
      );

      if (response.statusCode == 200) {
        final List list = response.data['Follow'] ?? [];

        print(response.data['Follow']);

        Myfans.clear();

        for (final element in list) {
          Myfans.add(
            Follows.fromJson(element),
          );
        }

        print(Myfans);
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Myfans;
  }

  Future<List<Follows>> GetFollowing2(
    context,
    id,
  ) async {
    try {
      final response = await _dio.get(
        '/api/Getmyfollowing/$id',
      );

      if (response.statusCode == 200) {
        final List list = response.data['Follow'] ?? [];

        print(response.data['Follow']);

        Myfans.clear();

        for (final element in list) {
          Myfans.add(
            Follows.fromJson(element),
          );
        }

        print(Myfans);
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Myfans;
  }

  Future<List<Follows>> GetFriends2(
    context,
    id,
  ) async {
    try {
      final response = await _dio.get(
        '/api/Getmyfrinds/$id',
      );

      if (response.statusCode == 200) {
        final List list = response.data['Follow'] ?? [];

        print(response.data['Follow']);

        Myfans.clear();

        for (final element in list) {
          Myfans.add(
            Follows.fromJson(element),
          );
        }

        print(Myfans);
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Myfans;
  }

  Future<bool> ReturnFollow({
    senderid,
    context,
  }) async {
    try {
      final map = {
        'user_id': UserId.toString(),
        'sender_id': senderid.toString(),
      };

      map.removeWhere(
        (key, value) => key == null || value == null,
      );

      final formData = FormData.fromMap(map);

      final response = await _dio.post(
        'api/ReturnFollow',
        data: formData,
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> RemoveFollow({
    followid,
    context,
  }) async {
    try {
      final map = {
        'follow_id': followid.toString(),
      };

      map.removeWhere(
        (key, value) => key == null || value == null,
      );

      final formData = FormData.fromMap(map);

      final response = await _dio.post(
        'api/RemoveFollow',
        data: formData,
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> RemoveUserFollow({
    Userid,
    context,
  }) async {
    try {
      final map = {
        'user_id': Userid.toString(),
        'sender_id': UserId.toString(),
      };

      map.removeWhere(
        (key, value) => key == null || value == null,
      );

      final formData = FormData.fromMap(map);

      final response = await _dio.post(
        'api/RemoveUserFollow',
        data: formData,
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> SentFollow({
    userid,
    context,
    Sender,
  }) async {
    try {
      final map = {
        'user_id': userid.toString(),
        'sender_id': Sender.toString(),
      };

      map.removeWhere(
        (key, value) => key == null || value == null,
      );

      final formData = FormData.fromMap(map);

      final response = await _dio.post(
        'api/Followuser',
        data: formData,
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> RemoveFollowRoom({
    userid,
    context,
    Sender,
  }) async {
    try {
      final map = {
        'user_id': userid.toString(),
        'sender_id': Sender.toString(),
      };

      map.removeWhere(
        (key, value) => key == null || value == null,
      );

      final formData = FormData.fromMap(map);

      final response = await _dio.post(
        'api/RemoveFollowRoom',
        data: formData,
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }
}