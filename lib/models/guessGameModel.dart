import 'package:ahlachat/models/Usermodel.dart';

class guessgamemodel {
  int? id;
  var senderId;
  var senderGueess;
  var acceptId;
  usermodel? Sender;
  usermodel? Reciver;
  var acceptGueess;
  String? coins;
  int? status;

  var winner;
  String? createdAt;
  String? updatedAt;

  guessgamemodel(
      {this.id,
        this.senderId,
        this.senderGueess,
        this.acceptId,
        this.acceptGueess,
        this.coins,
        this.status,
        this.winner,
        this.createdAt,
        this.updatedAt});

  guessgamemodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['Sender_id'];
    senderGueess = json['Sender_gueess'];
    acceptId = json['Accept_id'];
    acceptGueess = json['Accept_gueess'];
    coins = json['Coins'].toString();
    status = json['status'];
    winner=json['winner'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    Sender = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
    Reciver= json['Reciver'] != null ? new usermodel.fromJson(json['Reciver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Sender_id'] = this.senderId;
    data['Sender_gueess'] = this.senderGueess;
    data['Accept_id'] = this.acceptId;
    data['Accept_gueess'] = this.acceptGueess;
    data['Coins'] = this.coins;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['winner'] = this.winner;
    if (this.Sender != null) {
      data['user'] = this.Sender!.toJson();
    }
    if (this.Reciver != null) {
      data['Reciver'] = this.Reciver!.toJson();
    }
    return data;
  }
}