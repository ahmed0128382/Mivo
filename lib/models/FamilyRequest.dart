

import 'package:ahlachat/models/Usermodel.dart';

class FamilyRequest {
  int? id;
  int? familyId;
  int? userId;
  int? status;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

  FamilyRequest(
      {this.id,
        this.familyId,
        this.userId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user});

  FamilyRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    familyId = json['Family_id'];
    userId = json['user_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Family_id'] = this.familyId;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
