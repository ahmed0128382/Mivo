
import 'package:ahlachat/models/Usermodel.dart';

class joinRoom {
  int? id;
  int? userId;
  int? index;
  int? roomId;
  String? createdAt;
  String? updatedAt;
  usermodel? user;
  joinRoom(
      {this.id,
        this.userId,
        this.index,
        this.roomId,
        this.user,
        this.createdAt,
        this.updatedAt});

  joinRoom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    index = json['index'];
    roomId = json['room_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['index'] = this.index;
    data['room_id'] = this.roomId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}