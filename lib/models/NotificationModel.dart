

import 'package:ahlachat/util/app_constants.dart';

class Notificationmodel {
  int? id;
  String? tittle;
  String? message;
  String? image;
  String? createdAt;
  String? updatedAt;

  Notificationmodel(
      {this.id,
        this.tittle,
        this.message,
        this.image,
        this.createdAt,
        this.updatedAt});

  Notificationmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tittle = json['title'];
    message = json['message'];
    image = AppConstants.Image_URL+json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tittle'] = this.tittle;
    data['message'] = this.message;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

