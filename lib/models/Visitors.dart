import 'package:ahlachat/models/Usermodel.dart';


class visitors {
  int? id;
  String? userId;
  String? visitorId;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

  visitors(
      {this.id,
        this.userId,
        this.visitorId,
        this.createdAt,
        this.updatedAt,
        this.user});

  visitors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    visitorId = json['visitor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['visitor_id'] = this.visitorId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}