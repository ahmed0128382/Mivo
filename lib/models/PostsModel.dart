import 'package:ahlachat/models/CommentsModel.dart';
import 'package:ahlachat/models/Likemodel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/app_constants.dart';

class PostsModel {
  bool? status;
  String? errNum;
  String? msg;
  List<Postes>? postes;

  PostsModel({
    this.status,
    this.errNum,
    this.msg,
    this.postes,
  });

  PostsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] as bool?;
    errNum = json['errNum']?.toString();
    msg = json['msg']?.toString();

    final dynamic rawPosts = json['Postes'];

    if (rawPosts is List) {
      postes = rawPosts
          .whereType<Map>()
          .map(
            (item) => Postes.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } else {
      postes = <Postes>[];
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'status': status,
      'errNum': errNum,
      'msg': msg,
      if (postes != null)
        'Postes': postes!.map((post) => post.toJson()).toList(),
    };
  }
}

class Postes {
  int? id;
  String? userId;
  String? content;
  int? likes;
  int? comments;
  String? image;
  String? createdAt;
  String? updatedAt;
  usermodel? user;
  List<Like>? like = <Like>[];
  List<Comments>? commentsuser = <Comments>[];

  Postes({
    this.id,
    this.userId,
    this.content,
    this.likes,
    this.comments,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.like,
    this.commentsuser,
  });

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static String _parseImage(dynamic value) {
    if (value == null) return '';

    final String path = value.toString().trim();

    if (path.isEmpty || path.toLowerCase() == 'null') {
      return '';
    }

    // Preserve complete URLs returned by the API.
    if (path.startsWith('https://') || path.startsWith('http://')) {
      return path;
    }

    final String baseUrl = AppConstants.Image_URL;

    // Avoid duplicating the base URL.
    if (path.startsWith(baseUrl)) {
      return path;
    }

    final String normalizedBase = baseUrl.endsWith('/')
        ? baseUrl
        : '$baseUrl/';

    final String normalizedPath = path.startsWith('/')
        ? path.substring(1)
        : path;

    return '$normalizedBase$normalizedPath';
  }

  Postes.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    userId = _parseString(json['user_id']) ?? '';
    content = _parseString(json['content']) ?? '';

    likes = _parseInt(json['likes']);
    comments = _parseInt(json['comments']);

    image = _parseImage(json['image']);

    createdAt = _parseString(json['created_at']);
    updatedAt = _parseString(json['updated_at']);

    final dynamic rawUser = json['user'];

    if (rawUser is Map) {
      user = usermodel.fromJson(
        Map<String, dynamic>.from(rawUser),
      );
    } else {
      user = null;
    }

    final dynamic rawComments = json['commentsuser'];

    if (rawComments is List) {
      commentsuser = rawComments
          .whereType<Map>()
          .map(
            (item) => Comments.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } else {
      commentsuser = <Comments>[];
    }

    final dynamic rawLikes = json['like'];

    if (rawLikes is List) {
      like = rawLikes
          .whereType<Map>()
          .map(
            (item) => Like.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } else {
      like = <Like>[];
    }
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'content': content,
      'likes': likes,
      'comments': comments,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'commentsuser': commentsuser
          ?.map((comment) => comment.toJson())
          .toList(),
      'user': user?.toJson(),
      'like': like?.map((item) => item.toJson()).toList(),
    };
  }
}
