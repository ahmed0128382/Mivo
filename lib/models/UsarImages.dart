import 'package:ahlachat/util/app_constants.dart';

class UserImages {
  int? id;
  String? image;
  int? userId;
  String? createdAt;
  String? updatedAt;

  UserImages(
      {this.id, this.image, this.userId, this.createdAt, this.updatedAt});

  UserImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image =AppConstants.Image_URL+ json['image'];
    userId = int.parse(json['user_id'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}