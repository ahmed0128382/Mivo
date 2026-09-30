import 'package:ahlachat/util/app_constants.dart';

class AchiveModels {
  int? id;
  String? image;
  String? blackimage;
  String? name;
  String? status;
   var description;
  String? reason;
  String? createdAt;
  String? updatedAt;

  AchiveModels(
      {this.id,
        this.image,
        this.blackimage,
        this.name,
        this.description,
        this.status,
        this.reason,
        this.createdAt,
        this.updatedAt});

  AchiveModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = AppConstants.Image_URL+json['image'];
    blackimage = AppConstants.Image_URL+json['blackimage'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    reason = json['reason'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['blackimage'] = this.blackimage;
    data['name'] = this.name;
    data['status'] = this.status;
    data['description']  =this.description;
    data['reason'] = this.reason;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}