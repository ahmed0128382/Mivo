import 'package:ahlachat/models/Usermodel.dart';

class KarismaCollectModel {
  int? senderId;
  String? karisma;
  usermodel? user;

  KarismaCollectModel({this.senderId, this.karisma, this.user});

  KarismaCollectModel.fromJson(Map<String, dynamic> json) {
    senderId = json['sender_id'];
    karisma = json['karisma'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_id'] = this.senderId;
    data['karisma'] = this.karisma;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}