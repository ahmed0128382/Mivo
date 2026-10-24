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

// General feed pagination.
int PostIndex = 1;
bool HasMorePosts = true;
bool IsLoadingMorePosts = false;

// Following feed pagination.
int FollowIndex = 1;
bool HasMoreFollowPosts = true;
bool IsLoadingMoreFollowPosts = false;

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
  PostIndex = 1;
  HasMorePosts = true;
  IsLoadingMorePosts = false;

  try {
    final response = await _dio.get('/api/GetPosts/$UserId');

    final root = _asMap(response.data);
    final postes = _asMap(root['Postes']);
    final pagination = _asMap(postes['date']);

    final rawData = pagination['data'];
    final List<dynamic> list =
        rawData is List ? rawData : <dynamic>[];

    final currentPage = _asInt(
      pagination['current_page'],
      fallback: 1,
    );

    final lastPage = _asInt(
      pagination['last_page'],
      fallback: currentPage,
    );

    final nextPageUrl = pagination['next_page_url'];

    final result = list
        .map((item) => Postes.fromJson(_asMap(item)))
        .toList();

    // Update pagination only after a successful response.
    PostIndex = currentPage + 1;
    HasMorePosts = nextPageUrl != null &&
        nextPageUrl.toString().isNotEmpty &&
        currentPage < lastPage;

    // The API supplies IDs of posts liked by the current user here.
    final likedPosts = postes['posts'];
    if (likedPosts is List) {
      Provider.of<MomentViewModel>(
        context,
        listen: false,
      ).GetLikedPost(likedPosts);
    }

    GeneralPostes
      ..clear()
      ..addAll(result);

    return result;
  } catch (e) {
    final exception = await _handleError(e);
    print('GET POSTS ERROR: $exception');

    // Keep the pagination state retryable after a failed request.
    rethrow;
  }
}

 Future<List<Postes>> GetFollowPostes(context) async {
  FollowIndex = 1;
  HasMoreFollowPosts = true;
  IsLoadingMoreFollowPosts = false;

  try {
    final response = await _dio.get(
      '/api/GetPostsUserFollowing/$UserId',
    );

    final root = _asMap(response.data);
    final pagination = _asMap(root['Postes']);

    final rawData = pagination['data'];
    final List<dynamic> list =
        rawData is List ? rawData : <dynamic>[];

    final currentPage = _asInt(
      pagination['current_page'],
      fallback: 1,
    );

    final lastPage = _asInt(
      pagination['last_page'],
      fallback: currentPage,
    );

    final nextPageUrl = pagination['next_page_url'];

    final result = list
        .map((item) => Postes.fromJson(_asMap(item)))
        .toList();

    FollowIndex = currentPage + 1;
    HasMoreFollowPosts = nextPageUrl != null &&
        nextPageUrl.toString().isNotEmpty &&
        currentPage < lastPage;

    print(
      'FOLLOWING FEED: page=$currentPage/$lastPage, '
      'items=${result.length}, '
      'hasMore=$HasMoreFollowPosts',
    );

    return result;
  } catch (e) {
    final exception = await _handleError(e);
    print('GET FOLLOWING POSTS ERROR: $exception');
    rethrow;
  }
}

 Future<List<Postes>> AddmoreFollowPosts(context) async {
  if (!HasMoreFollowPosts || IsLoadingMoreFollowPosts) {
    return <Postes>[];
  }

  IsLoadingMoreFollowPosts = true;

  try {
    final requestedPage = FollowIndex;

    final response = await _dio.get(
      '/api/GetPostsUserFollowing/$UserId',
      queryParameters: {'page': requestedPage},
    );

    final root = _asMap(response.data);
    final pagination = _asMap(root['Postes']);

    final rawData = pagination['data'];
    final List<dynamic> list =
        rawData is List ? rawData : <dynamic>[];

    final currentPage = _asInt(
      pagination['current_page'],
      fallback: requestedPage,
    );

    final lastPage = _asInt(
      pagination['last_page'],
      fallback: currentPage,
    );

    final nextPageUrl = pagination['next_page_url'];

    final newPosts = list
        .map((item) => Postes.fromJson(_asMap(item)))
        .toList();

    FollowIndex = currentPage + 1;

    HasMoreFollowPosts = newPosts.isNotEmpty &&
        nextPageUrl != null &&
        nextPageUrl.toString().isNotEmpty &&
        currentPage < lastPage;

    print(
      'FOLLOWING FEED: requested=$requestedPage, '
      'received=$currentPage/$lastPage, '
      'items=${newPosts.length}, '
      'hasMore=$HasMoreFollowPosts',
    );

    return newPosts;
  } catch (e) {
    final exception = await _handleError(e);
    print('LOAD MORE FOLLOWING POSTS ERROR: $exception');
    rethrow;
  } finally {
    IsLoadingMoreFollowPosts = false;
  }
}
 Future<List<Postes>> AddmorePosts(context) async {
  if (!HasMorePosts || IsLoadingMorePosts) {
    return <Postes>[];
  }

  IsLoadingMorePosts = true;

  try {
    final requestedPage = PostIndex;

    final response = await _dio.get(
      '/api/GetPosts/$UserId',
      queryParameters: {'page': requestedPage},
    );

    final root = _asMap(response.data);
    final postes = _asMap(root['Postes']);
    final pagination = _asMap(postes['date']);

    final rawData = pagination['data'];
    final List<dynamic> list =
        rawData is List ? rawData : <dynamic>[];

    final currentPage = _asInt(
      pagination['current_page'],
      fallback: requestedPage,
    );

    final lastPage = _asInt(
      pagination['last_page'],
      fallback: currentPage,
    );

    final nextPageUrl = pagination['next_page_url'];

    final newPosts = list
        .map((item) => Postes.fromJson(_asMap(item)))
        .toList();

    // Use the page actually returned by the server.
    PostIndex = currentPage + 1;

    HasMorePosts = newPosts.isNotEmpty &&
        nextPageUrl != null &&
        nextPageUrl.toString().isNotEmpty &&
        currentPage < lastPage;

    print(
      'GENERAL FEED: requested=$requestedPage, '
      'received=$currentPage/$lastPage, '
      'items=${newPosts.length}, '
      'hasMore=$HasMorePosts',
    );

    // Return ONLY this page. The ViewModel appends it once.
    return newPosts;
  } catch (e) {
    final exception = await _handleError(e);
    print('LOAD MORE GENERAL POSTS ERROR: $exception');

    // Do not advance PostIndex on failure; the next attempt retries it.
    rethrow;
  } finally {
    IsLoadingMorePosts = false;
  }
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

 
Future<Postes?> AddPost({
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

    print('ADD POST: Sending POST /api/AddPost');

    final response = await _dio.post(
      '/api/AddPost',
      data: formData,
    );

    print('ADD POST: HTTP ${response.statusCode}');
    print('ADD POST: Response = ${response.data}');

    if (response.statusCode == 200 &&
        response.data is Map &&
        response.data['status'] == true &&
        response.data['Postes'] is Map) {
      final Postes createdPost = Postes.fromJson(
        Map<String, dynamic>.from(response.data['Postes']),
      );

      print('ADD POST: Success. Created post ID = ${createdPost.id}');

      return createdPost;
    }

    print('ADD POST: Server did not confirm success.');
    return null;
  } catch (e) {
    final exception = await _handleError(e);

    print('ADD POST ERROR: $exception');

    if (exception.data is Map) {
      final errNum = exception.data['errNum'];

      if (errNum != null && context != null) {
        Dialogs().ShowErrorRegesterToast(errNum, context);
      }
    }

    return null;
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return <String, dynamic>{};
}

int _asInt(dynamic value, {required int fallback}) {
  if (value is int) return value;

  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
}