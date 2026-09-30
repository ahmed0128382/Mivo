import 'package:ahlachat/models/MessageModel.dart';
import 'package:ahlachat/models/Usermodel.dart';


class InboxRoomModel {
  int? id;
  String? userId;
  String? senderId;
  String? lastMessage;
  int? numberUnread;
  String? createdAt;
  String? updatedAt;
  List<Message>? message;
  usermodel? user;
  usermodel? sender;

  InboxRoomModel(
      {this.id,
        this.userId,
        this.senderId,
        this.lastMessage,
        this.numberUnread,
        this.createdAt,
        this.updatedAt,
        this.message,
        this.user,
        this.sender});

  InboxRoomModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    senderId = json['sender_id'];
    lastMessage = json['last_message'];
    numberUnread = json['number_unread'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
    sender =
    json['sender'] != null ? new usermodel.fromJson(json['sender']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['sender_id'] = this.senderId;
    data['last_message'] = this.lastMessage;
    data['number_unread'] = this.numberUnread;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.sender != null) {
      data['sender'] = this.sender!.toJson();
    }
    return data;
  }
}
