import 'package:ahlachat/models/RoomModel.dart';

class FollowedRoom {
  int? id;
  int? userId;
  int? roomId;
  String? createdAt;
  String? updatedAt;
  RoomModel? room;

  FollowedRoom(
      {this.id,
        this.userId,
        this.roomId,
        this.createdAt,
        this.updatedAt,
        this.room});

  FollowedRoom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    roomId = json['room_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    room = json['room'] != null ? new RoomModel.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['room_id'] = this.roomId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    return data;
  }
}
