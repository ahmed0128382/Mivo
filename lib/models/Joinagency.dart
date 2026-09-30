

import 'package:ahlachat/models/Usermodel.dart';

class joinagincy {
  int? id;
  int? userId;
  int? agancyId;
  int? status;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

  joinagincy(
      {this.id,
        this.userId,
        this.agancyId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user});

  joinagincy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    agancyId = json['agancy_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['agancy_id'] = this.agancyId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
