
import '../util/app_constants.dart';

class UserLevelGifts {
  int? id;
  String? userId;
  String? svga;
  String? tittle;
  String? message;
  String? image;
  int? kind;
  String ?svgaurl;
  String? createdAt;
  String? updatedAt;

  UserLevelGifts(
      {this.id,
        this.userId,
        this.svga,
        this.tittle,
        this.message,
        this.image,
        this.kind,
        this.createdAt,
        this.updatedAt});

  UserLevelGifts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    svgaurl=json['svga']==null?'':AppConstants.Image_URL+json['svga'];
    svga=json['svga']==null?'': json['svga'];
    tittle = json['tittle'];
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
    data['svga'] = this.svgaurl;
    data['tittle'] = this.tittle;
    data['message'] = this.message;
    data['image'] = this.image;
    data['kind'] = this.kind;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    return data;
  }
}