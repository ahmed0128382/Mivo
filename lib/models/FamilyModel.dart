import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/app_constants.dart';
class FamilyModel {
  int? id;
  String? name;
  String? familyid;
  var firstadmin;
  var secondadmin;
  int? karisma;
  int?   GlopalKarisma;
  String? describtion;
  String? image;
  var model;
  int? userId;
  int? nubmers;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<TopStar>? topStar;
  List<RoomModel>? rooms;

  FamilyModel(
      {this.id,
        this.name,
        this.familyid,
        this.firstadmin,
        this.secondadmin,
        this.karisma,
        this.GlopalKarisma,
        this.describtion,
        this.image,
        this.model,
        this.userId,
        this.nubmers,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.topStar,
        this.rooms});

  FamilyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    familyid = json['Familyid'];
    firstadmin = json['firstadmin'];
    secondadmin = json['secondadmin'];
    karisma = json['Karisma'];
    GlopalKarisma = json['GlopalKarisma'];
    describtion = json['describtion'];
    image = AppConstants.Image_URL+json['image'];
    model =json['model']==null?null: AppConstants.Image_URL+json['model'];
    userId = json['user_id'];
    nubmers = json['nubmers'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['TopStar'] != null) {
      topStar = <TopStar>[];
      json['TopStar'].forEach((v) {
        topStar!.add(new TopStar.fromJson(v));
      });
    }
    if (json['rooms'] != null) {
      rooms = <RoomModel>[];
      json['rooms'].forEach((v) {
        rooms!.add(new RoomModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['Familyid'] = this.familyid;
    data['firstadmin'] = this.firstadmin;
    data['secondadmin'] = this.secondadmin;
    data['Karisma'] = this.karisma;
    data['GlopalKarisma'] = this.GlopalKarisma;

    data['describtion'] = this.describtion;
    data['image'] = this.image;
    data['model'] = this.model;
    data['user_id'] = this.userId;
    data['nubmers'] = this.nubmers;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.topStar != null) {
      data['TopStar'] = this.topStar!.map((v) => v.toJson()).toList();
    }
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class TopStar {
  int? userId;
  String? coins;
  usermodel? user;

  TopStar({this.userId, this.coins, this.user});

  TopStar.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    coins = json['coins'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['coins'] = this.coins;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}