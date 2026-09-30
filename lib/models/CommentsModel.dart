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

  Comments(
      {this.id,
        this.postId,
        this.userId,
        this.comment,
        this.commentReplay,
        this.likes,
        this.createdAt,
        this.updatedAt,
        this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    comment = json['Comment'];
    commentReplay = json['CommentReplay']??"";
    likes = json['likes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['Comment'] = this.comment;
    data['CommentReplay'] = this.commentReplay;
    data['likes'] = this.likes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}