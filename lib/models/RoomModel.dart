

import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/SupervisorsModel.dart';
import 'package:ahlachat/models/Usermodel.dart';

import '../util/app_constants.dart';

class RoomModel {
  int? id;
  String? name;
  String? image;
  String? nothostedimage;
  String?animateimage;
  String? frame;
  String? password;
  int? userNumber ;
  int? adminId;
  int? SecondKing;
  var  importance;
  int? locked;
  int? state;
  String?Category;
  String? createdAt;
  String? updatedAt;
  String?city;
  List<joinRoom>? joinRooms;
  List<Supervisors>? supervisor =[];
  List<String>? supervisorsId =[];
  usermodel? admin;
  List<Chairs>? chairs;
  List<Chatroom>? chatroom;
  String ? Token;
  String ? agoratoken;
  String ? RoomAds;
  String?RoomID;
  int ?Karisma;
  int ?FollowRoom;

  RoomModel(
      {this.id,
        this.name,
        this.RoomID,
        this.image,
        this.frame,
        this.password,
        this.userNumber,
        this.adminId,
        this.locked,
        this.state,
        this.city,
        this.Category,
        this.createdAt,
        this.updatedAt,
        this.joinRooms,
        this.supervisor,
        this.supervisorsId,
        this.animateimage,
        this.admin,
        this.chairs,
        this.chatroom,
        this.Token,
        this.importance,
        this.nothostedimage,
        this.agoratoken,
        this.RoomAds,
        this.Karisma,
        this.SecondKing,
        this.FollowRoom
      });

  RoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = AppConstants.Image_URL+json['image'];
    animateimage = AppConstants.Image_URL+json['animateimage'];
    frame = json['frame'];
    SecondKing= json['SecondKing'];
    password = json['password'];
    FollowRoom= json['FollowRoom'];
    userNumber = json['user_number'];
    adminId = json['admin_id'];
    locked = json['Locked'];
    state = json['state'];
    Category=json['Category'];
    city=json['city'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    nothostedimage=json['animateimage'];
    Token=json['Token'];
    RoomID=json['RoomID'];
    agoratoken=json['agoratoken'];
    RoomAds=json['RoomAds'];
    importance=json['importance'];
    Karisma=json['Karisma'];
    if (json['join_room'] != null) {
      joinRooms = <joinRoom>[];
      json['join_room'].forEach((v) {
        joinRooms?.add(new joinRoom.fromJson(v));
      });
    }

    if (json['supervisors'] != null) {
      supervisor = <Supervisors>[];
      json['supervisors'].forEach((v) {
        supervisor?.add(new Supervisors.fromJson(v));
        supervisorsId?.add(v['user_id']);
      });
    }


    admin = json['admin'] != null ? new usermodel.fromJson(json['admin']) : null;
    if (json['chairs'] != null) {
      chairs = <Chairs>[];
      json['chairs'].forEach((v) {
        chairs!.add(new Chairs.fromJson(v));
      });
    }
    if (json['chatroom'] != null) {
      chatroom = <Chatroom>[];
      json['chatroom'].forEach((v) {
        chatroom!.add(new Chatroom.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['animateimage'] = this.animateimage;
    data['frame'] = this.frame;
    data['Token']=this.Token;
    data['password'] = this.password;
    data['RoomID'] = this.RoomID;
    data['user_number'] = this.userNumber;
    data['admin_id'] = this.adminId;
    data['Locked'] = this.locked;
    data['state'] = this.state;
    data['FollowRoom']=this.FollowRoom;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['Category']=this.Category;
    data['city']=this.city;
    data['importance']=this.importance;
    data['agoratoken']=this.agoratoken;
    data['RoomAds']=this.RoomAds;
    data['Karisma']=this.Karisma;
    data['SecondKing']=this.SecondKing;
    if (this.joinRooms != null) {
      data['join_room'] = this.joinRooms!.map((v) => v.toJson()).toList();
    }
    if (this.supervisor != null) {
      data['supervisors'] = this.supervisor!.map((v) => v.toJson()).toList();
    }
    if (this.admin != null) {
      data['admin'] = this.admin!.toJson();
    }
    if (this.chairs != null) {
      data['chairs'] = this.chairs!.map((v) => v.toJson()).toList();
    }
    if (this.chatroom != null) {
      data['chatroom'] = this.chatroom!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}