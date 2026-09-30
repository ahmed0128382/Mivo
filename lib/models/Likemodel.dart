

import 'package:ahlachat/models/Usermodel.dart';

class Like {
  int? id;
  String? postId;
  String? userId;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

  Like(
      {this.id,
        this.postId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.user});

  Like.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}