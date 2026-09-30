

import 'package:ahlachat/models/Usermodel.dart';

class Supervisors {
  int? id;
  String? userId;
  String? roomId;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

  Supervisors(
      {this.id,
        this.userId,
        this.roomId,
        this.createdAt,
        this.updatedAt,
        this.user});

  Supervisors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    roomId = json['room_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['room_id'] = this.roomId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
