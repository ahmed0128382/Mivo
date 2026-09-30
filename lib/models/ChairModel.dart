import 'package:ahlachat/models/Usermodel.dart';


class Chairs {
  int? id;
  String? userId;
  String? roomId;
  String? chairId;
  int? mute;
  String? createdAt;
  String? updatedAt;
  usermodel? user; 
  int ?Lock;
  int? Karisma;
  int? adminleaved;


  Chairs({this.id,
    this.userId,
    this.roomId,
    this.chairId,
    this.createdAt,
    this.adminleaved,
    this.updatedAt,
    this.user,
    this.mute,
    this.Lock,
    this.Karisma
  });

  Chairs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    roomId = json['room_id'];
    chairId = json['chair_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
    mute=json['mute'];
    Lock=json['Lock'];
    Karisma=json['Karisma'];
    adminleaved=json['adminleaved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['room_id'] = this.roomId;
    data['chair_id'] = this.chairId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['Lock'] = this.Lock;
    data['mute'] = this.mute;
    data['adminleaved']= this.adminleaved;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['Karisma'] = this.Karisma;
    return data;
  }
}