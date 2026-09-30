
import 'package:ahlachat/util/app_constants.dart';

class usergifts {
  int? id;
  String? userId;
  String? urlsvga;
  String? svga;
  String? tittle;
  String? message;
  String? image;
  String? kind;
  String? createdAt;
  String? updatedAt;
  usergifts(
      {this.id,
        this.userId,
        this.svga,
        this.tittle,
        this.message,
        this.image,
        this.kind,
        this.createdAt,this.urlsvga,
        this.updatedAt});

  usergifts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    svga = json['svga'];
    urlsvga=AppConstants.Image_URL+ json['svga'];
    tittle = json['title'];
    message = json['message'];
    image =AppConstants.Image_URL+ json['image'];
    kind = json['kind'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['svga'] = this.svga;

    data['tittle'] = this.tittle;
    data['message'] = this.message;
    data['image'] = this.image;
    data['kind'] = this.kind;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}