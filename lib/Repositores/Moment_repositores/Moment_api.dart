import 'package:ahlachat/Repositores/Moment_repositores/Moment_repository.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/CommentsModel.dart';
import '../../models/Likemodel.dart';
import '../../models/PostsModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../../viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';

int Index = 2;
int PostIndex = 2;
int FollowIndex = 2;

class Momentapi extends MomentRepository {
  final Dio _dio = ApiClient.instance.dio;

  final List<Postes> GeneralPostes = [];
  final List<Postes> GetMyPostslist = [];

  Comments Commentss = Comments();
  Like Likes = Like();
  Postes post = Postes();

  Future<ApiException> _handleError(dynamic error) async {
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

  Future<List<Postes>> GetPosts(context) async {
    PostIndex = 2;

    try {
      final response = await _dio.get(
        '/api/GetPosts/$UserId',
      );

      final List list =
          response.data['Postes']['date']['data'] ?? [];

      final List ste =
          response.data['Postes']['posts'] ?? [];

      GeneralPostes.clear();

      for (final element in list) {
        GeneralPostes.add(
          Postes.fromJson(element),
        );
      }

      Provider.of<MomentViewModel>(
        context,
        listen: false,
      ).GetLikedPost(ste);
    } catch (e) {
      final exception = await _handleError(e);
      print(exception);
    }

    return GeneralPostes;
  }

  Future<List<Postes>> GetFollowPostes(context) async {
    FollowIndex = 2;

    try {
      final response = await _dio.get(
        '/api/GetPostsUserFollowing/$UserId',
      );

      final List list =
          response.data['Postes']['data'] ?? [];

      GeneralPostes.clear();

      for (final element in list) {
        GeneralPostes.add(
          Postes.fromJson(element),
        );
      }
    } catch (e) {
      final exception = await _handleError(e);
      print(exception);
    }

    return GeneralPostes;
  }

  Future<List<Postes>> AddmoreFollowPosts(context) async {
    try {
      final response = await _dio.get(
        '/api/GetPostsUserFollowing/$UserId?page=$FollowIndex',
      );

      final List list =
          response.data['Postes']['data'] ?? [];

      if (list.isNotEmpty) {
        FollowIndex++;
      }

      for (final element in list) {
        GeneralPostes.add(
          Postes.fromJson(element),
        );
      }
    } catch (e) {
      final exception = await _handleError(e);
      print(exception);
    }

    return GeneralPostes;
  }

  Future<List<Postes>> AddmorePosts(context) async {
    try {
      final response = await _dio.get(
        '/api/GetPosts/$UserId?page=$PostIndex',
      );

      final List list =
          response.data['Postes']['date']['data'] ?? [];

      if (list.isNotEmpty) {
        PostIndex++;
      }

      print('POST INDEX IS $PostIndex');

      for (final element in list) {
        GeneralPostes.add(
          Postes.fromJson(element),
        );
      }

      print(GeneralPostes);
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }

        if (errNum == '3500') {
          // Existing special handling.
        }
      }
    }

    return GeneralPostes;
  }

  Future<bool> ReportPost({
    context,
    Postid,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'post_id': Postid.toString(),
        'reason': 'Post',
      });

      final response = await _dio.post(
        '/api/AddPostReport',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }

      return false;
    }
  }

  Future<bool> ReportUser({
    context,
    Userid,
  }) async {
    try {
      final formData = FormData.fromMap({
        'sender_id': UserId.toString(),
        'user_id': Userid.toString(),
      });

      final response = await _dio.post(
        '/api/AddUserReport',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }

      return false;
    }
  }

  Future<bool> BlockUser({
    context,
    Userid,
  }) async {
    try {
      final formData = FormData.fromMap({
        'sender_id': UserId.toString(),
        'user_id': Userid.toString(),
      });

      final response = await _dio.post(
        '/api/AddBlockList',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }

      return false;
    }
  }

  Future<bool> UnBlockUser({
    context,
    Userid,
  }) async {
    try {
      final formData = FormData.fromMap({
        'sender_id': UserId.toString(),
        'user_id': Userid.toString(),
      });

      final response = await _dio.post(
        '/api/UnBlockUser',
        data: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }

      return false;
    }
  }

  Future<List<Postes>> GetMyPosts(context) async {
    try {
      final response = await _dio.get(
        '/api/GetMyPosts/$UserId',
      );

      final List list =
          response.data['Postes'] ?? [];

      GetMyPostslist.clear();

      for (final element in list) {
        GetMyPostslist.add(
          Postes.fromJson(element),
        );
      }
    } catch (e) {
      final exception = await _handleError(e);
      print(exception);
    }

    return GetMyPostslist;
  }

  Future<bool> DeletePost({
    context,
    postid,
  }) async {
    try {
      final response = await _dio.get(
        '/api/Deletemypost/$postid',
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = await _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<Comments> AddComment({
    context,
    Comment,
    Postid,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'post_id': Postid.toString(),
        'Comment': Comment.toString(),
      });

      final response = await _dio.post(
        '/api/AddComment',
        data: formData,
      );

      print(response.data['Comment']);

      if (response.statusCode == 200) {
        Commentss = Comments.fromJson(
          response.data['Comment'],
        );
      }
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return Commentss;
  }

  Future<Comments> ReplayComment({
    context,
    Commentid,
    Replay,
  }) async {
    try {
      final formData = FormData.fromMap({
        'Comment_id': Commentid.toString(),
        'Replay': Replay.toString(),
      });

      final response = await _dio.post(
        '/api/ReplayComment',
        data: formData,
      );

      if (response.statusCode == 200) {
        print('goooooooooooooooooooooooooooo');

        Commentss = Comments.fromJson(
          response.data['Comment'],
        );
      }
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return Commentss;
  }

  Future<Like> LikePost({
    Postid,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'post_id': Postid.toString(),
      });

      final response = await _dio.post(
        '/api/AddLike',
        data: formData,
      );

      print(response.data['Like']);

      if (response.statusCode == 200) {
        Likes = Like.fromJson(
          response.data['Like'],
        );
      }
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        print(exception.data['errNum']);
      }
    }

    return Likes;
  }

  Future<bool> RemoveLike({
    context,
    Postid,
  }) async {
    try {
      final formData = FormData.fromMap({
        'user_id': UserId.toString(),
        'post_id': Postid.toString(),
      });

      final response = await _dio.post(
        '/api/RemoveLike',
        data: formData,
      );

      print(response.data['Like']);

      return response.statusCode == 200;
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }

      return false;
    }
  }

  Future<Postes> AddPost({
    context,
    tittle,
    image,
  }) async {
    try {
      final Map<String, dynamic> map = {
        'user_id': UserId.toString(),
        'content': tittle.toString(),
      };

      if (image != null) {
        map['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(map);

      final response = await _dio.post(
        '/api/AddPost',
        data: formData,
      );

      print(response.data['Comment']);

      if (response.statusCode == 200) {
        post = Postes.fromJson(
          response.data['Postes'],
        );
      }
    } catch (e) {
      final exception = await _handleError(e);

      print(exception);

      if (exception.data is Map) {
        final errNum = exception.data['errNum'];

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    return post;
  }
}