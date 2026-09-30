

import '../util/app_constants.dart';

class StartBannerModel {
  int? id;
  var  roomId;
  String? photo;

  StartBannerModel({this.id, this.roomId, this.photo});

  StartBannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    photo = AppConstants.Image_URL+json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['room_id'] = this.roomId;
    data['photo'] = this.photo;
    return data;
  }
}