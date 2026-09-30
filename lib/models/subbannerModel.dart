import 'package:ahlachat/util/app_constants.dart';

class SubBannerModel {
  int? id;
  String? bannerId;
  String? status;
  String? image;
  var phone;

  SubBannerModel(
      {this.id,
        this.bannerId,
        this.status,
        this.image,
        this.phone
        });

  SubBannerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerId = json['banner_id'];
    status = json['status'];
    phone= json['phone']==null?null:json['phone'];
    image =AppConstants.Image_URL+ json['image'];
  ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['banner_id'] = this.bannerId;
    data['status'] = this.status;
    data['image'] = this.image;

    data['phone'] = this.phone;
    return data;
  }
}