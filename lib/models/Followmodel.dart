import 'package:ahlachat/models/Usermodel.dart';



class Follows {
  int? id;
  String? userId;
  String? senderId;
  int? status;
  String? createdAt;
  String? updatedAt;
  usermodel? user;
  usermodel? otheruser;
  Follows(
      {this.id,
        this.userId,
        this.senderId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user,this.otheruser});

  Follows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    senderId = json['sender_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otheruser= json['otheruser'] != null ? new usermodel.fromJson(json['otheruser']) : null;
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['sender_id'] = this.senderId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.otheruser != null) {
      data['otheruser'] = this.otheruser!.toJson();
    }
    return data;
  }
}