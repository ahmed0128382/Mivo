

import 'package:ahlachat/models/GiveGifts.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/models/guessGameModel.dart';

class Chatroom {
  String? userId;
  String? roomId;
  String? content;
  String? Coins;
  String? updatedAt;
  String? createdAt;
  int? id;
  usermodel? user;
  int? kind;
  givegifts?Gift;
  usermodel? RecevedUser;
  guessgamemodel? Guess;
  Chatroom(
      {this.userId,
        this.roomId,
        this.content,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.user,
        this.kind,
        this.Gift,
        this.Coins,
        this.RecevedUser,
        this.Guess
      });

  Chatroom.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roomId = json['room_id'];
    content = json['content'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    Coins = '0';
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
    Guess = json['Guess'] != null ? new guessgamemodel.fromJson(json['Guess']) : null;
    kind=0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['room_id'] = this.roomId;
    data['content'] = this.content;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['Coins'] =  this.Coins;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.Guess != null) {
      data['Guess'] = this.Guess!.toJson();
    }
    return data;
  }
}