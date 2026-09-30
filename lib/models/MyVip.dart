

import 'package:ahlachat/models/VipModel.dart';

class MyVipmodel {
  int? id;
  int? userId;
  int? vipId;
  int? status;
  int? days;
  int? cost;
  VipModel ? Vip;
  var newId;
  var colorMessage;
  int? hidden;
  int? updateLevel;
  String? createdAt;
  String? updatedAt;

  MyVipmodel(
      {this.id,
        this.userId,
        this.vipId,
        this.status,
        this.days,
        this.cost,
        this.newId,
        this.colorMessage,
        this.hidden,
        this.updateLevel,
        this.createdAt,
        this.updatedAt,
      this.Vip
      });

  MyVipmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vipId = json['vip_id'];
    status = json['status'];
    days = json['days'];
    cost = json['cost'];
    newId = json['new_id'];
    colorMessage = json['Color_message'];
    hidden = json['Hidden'];
    updateLevel = json['update_level'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    Vip = json['vip'] != null ? new VipModel.fromJson(json['vip']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['vip_id'] = this.vipId;
    data['status'] = this.status;
    data['days'] = this.days;
    data['cost'] = this.cost;
    data['new_id'] = this.newId;
    data['Color_message'] = this.colorMessage;
    data['Hidden'] = this.hidden;
    data['update_level'] = this.updateLevel;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.Vip != null) {
      data['vip'] = this.Vip!.toJson();
    }
    return data;
  }
}