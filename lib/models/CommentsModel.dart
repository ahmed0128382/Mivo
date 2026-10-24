import 'package:ahlachat/models/Usermodel.dart';

class Comments {
  int? id;
  String? postId;
  String? userId;
  String? comment;
  String? commentReplay;
  int? likes;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

  Comments({
    this.id,
    this.postId,
    this.userId,
    this.comment,
    this.commentReplay,
    this.likes,
    this.createdAt,
    this.updatedAt,
    this.user,
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

  Comments.fromJson(Map<String, dynamic> json) {
    id = _parseInt(json['id']);
    postId = _parseString(json['post_id']);
    userId = _parseString(json['user_id']);

    comment = _parseString(json['Comment']) ?? '';

    // CommentReplay may be absent or null for ordinary comments.
    commentReplay = _parseString(json['CommentReplay']) ?? '';

    likes = _parseInt(json['likes']);

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
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'Comment': comment,
      'CommentReplay': commentReplay,
      'likes': likes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
    };
  }
}
