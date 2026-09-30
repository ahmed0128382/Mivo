

import 'package:ahlachat/models/Usermodel.dart';

class KickedUser {
  int? id;
  int? userId;
  int? roomId;
  String? reason;
  int? state;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

  KickedUser(
      {this.id,
        this.userId,
        this.roomId,
        this.reason,
        this.state,
        this.createdAt,
        this.updatedAt,
        this.user});

  KickedUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    roomId = json['room_id'];
    reason = json['reason'];
    state = json['state'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['room_id'] = this.roomId;
    data['reason'] = this.reason;
    data['state'] = this.state;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}