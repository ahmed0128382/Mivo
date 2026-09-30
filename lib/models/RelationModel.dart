import 'package:ahlachat/models/UserModels.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/app_constants.dart';

class RelationModel {
  int? id;
  int? senderId;
  int? relationId;
  int? userId;
  int? karisma;
  int? status;
  String? createdAt;
  String? updatedAt;
  usermodel? user;
  usermodel? anotheruser;
  item?items;
  var Leaved;

  RelationModel(
      {this.id,
        this.senderId,
        this.relationId,
        this.Leaved,
        this.userId,
        this.karisma,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user,
        this.items,
        this.anotheruser});

  RelationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['sender_id'];
    relationId = json['Relation_id'];
    userId = json['user_id'];
    karisma = json['karisma'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    Leaved= json['Leaved'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
    items=json['item'] != null ? new item.fromJson(json['item']) : null;
    anotheruser = json['anotheruser'] != null
        ? new usermodel.fromJson(json['anotheruser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sender_id'] = this.senderId;
    data['Relation_id'] = this.relationId;
    data['user_id'] = this.userId;
    data['karisma'] = this.karisma;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['Leaved']=this.Leaved;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.anotheruser != null) {
      data['anotheruser'] = this.anotheruser!.toJson();
    }
    return data;
  }
}
class User {
  int? id;
  String? name;
  String?image;

  User({this.id, this.name,this.image});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image =AppConstants.Image_URL+ json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image']=this.image;
    return data;
  }
}

class item {
  int? id;
  String? name;
  String? image;

  item({this.id, this.name});

  item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image=AppConstants.Image_URL+ json['svggift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image']=this.image;
    return data;
  }
}
