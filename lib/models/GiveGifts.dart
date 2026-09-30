import 'dart:convert';

import 'package:ahlachat/util/app_constants.dart';


class givegifts {
  int? id;
  String? name;
  String? image;
  int? categoryId;
  int? price;
  String? state;
  String? createdAt;
  String? updatedAt;
  List  ListUser=[];
  String? quantity;
  String?  svga;
  var Sound;

  givegifts(
      {this.id,
        this.name,
        this.image,
        this.categoryId,
        this.price,
        this.state,
        this.createdAt,
        this.Sound,
        this.updatedAt,
        required this.ListUser,
        this.quantity,
        this.svga});
  givegifts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = AppConstants.Image_URL+json['image'];
    categoryId = json['category_id'];
    price = json['price'];
    state = json['state'];
    Sound=json['sound']==null?null:AppConstants.Image_URL+json['sound'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ListUser =jsonDecode(json['Listuser']) ;
    quantity = json['quantity'];
    svga = AppConstants.Image_URL+json['svga'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['sound']=this.Sound;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['state'] = this.state;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['Listuser'] = this.ListUser;
    data['quantity'] = this.quantity;
    data['svga']=this.svga;
    return data;
  }
}