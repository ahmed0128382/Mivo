

import 'package:ahlachat/models/Usermodel.dart';

import '../util/app_constants.dart';

class Agencymodel {
  int? id;
  String? name ;
  int? userId;
  var description ;
  String? password ;
  int? coins;
  int? agencyKind;
  var model ;
  var image ;
  String? appid='';
  var userNumber;
  int? ban;
  String? createdAt;
  String? updatedAt;
  usermodel? user;

  Agencymodel(
      {this.id,
        this.name,
        this.userId,

        this.description,
        this.password,
        this.coins,
        this.agencyKind,
         this.model,
         this.image,
        this.userNumber,
        this.ban,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.appid
      });

  Agencymodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userId = json['user_id'];
    appid= json['appid'];
     description = json['description'];
    password = json['password'];
     coins = json['coins'];
     agencyKind = json['AgencyKind'];
       model = json['model']==null?null:AppConstants.Image_URL+ json['model'];
       image =json['image']==null?null:AppConstants.Image_URL+ json['image'];
       userNumber = json['user_number'];
      ban = json['ban'];
      createdAt = json['created_at'];
     updatedAt = json['updated_at'];
     user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['user_id'] = this.userId;
    data['appid'] = this.appid;
   data['description'] = this.description;
    data['password'] = this.password;
    data['coins'] = this.coins;
    data['AgencyKind'] = this.agencyKind;
    data['model'] = this.model;
    // data['image'] = this.image;

     data['user_number'] = this.userNumber;
    data['ban'] = this.ban;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}