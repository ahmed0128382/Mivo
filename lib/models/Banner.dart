

import 'package:ahlachat/models/subbannerModel.dart';

import '../util/app_constants.dart';

class Bannerss {
  String? image;
  var Secondimage;
  String? roomId;
  String? updatedAt;
  String? createdAt;
  int? id;
  List<SubBannerModel> ? SubBanner;

  Bannerss({this.image,this.Secondimage, this.roomId, this.updatedAt, this.createdAt, this.id,this.SubBanner});

  Bannerss.fromJson(Map<String, dynamic> json) {
    image =AppConstants.Image_URL+json['image'];
    Secondimage =json['Secondimage']==null?null:AppConstants.Image_URL+json['Secondimage'];
    roomId = json['Room_id'].toString();
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];

    if (json['subbanner'] != null) {
      SubBanner = <SubBannerModel>[];
      json['subbanner'].forEach((v) {
        SubBanner!.add(new SubBannerModel.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['Secondimage'] = this.Secondimage;

    data['Room_id'] = this.roomId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    if (this.SubBanner != null) {
      data['subbanner'] = this.SubBanner!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

