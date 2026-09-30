import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/models/gifts.dart';

class WeeklyStarModel {
  int? id;
  String? starttime;
  String? endtime;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<Leaderboardusermodel>? supporters;
  List<Leaderboardusermodel>? supporteds;
  List<Gift>? gifts;

  WeeklyStarModel(
      {this.id,
        this.starttime,
        this.endtime,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.supporters,
        this.supporteds,
        this.gifts});

  WeeklyStarModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    starttime = json['Starttime'];
    endtime = json['Endtime'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['supporters'] != null) {
      supporters = <Leaderboardusermodel>[];
      json['supporters'].forEach((v) {
        supporters!.add(new Leaderboardusermodel.fromJson(v));
      });
    }
    if (json['supporteds'] != null) {
      supporteds = <Leaderboardusermodel>[];
      json['supporteds'].forEach((v) {
        supporteds!.add(new Leaderboardusermodel.fromJson(v));
      });
    }
    if (json['gifts'] != null) {
      gifts = <Gift>[];
      json['gifts'].forEach((v) {
        gifts!.add(new Gift.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Starttime'] = this.starttime;
    data['Endtime'] = this.endtime;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.supporters != null) {
      data['supporters'] = this.supporters!.map((v) => v.toJson()).toList();
    }
    if (this.supporteds != null) {
      data['supporteds'] = this.supporteds!.map((v) => v.toJson()).toList();
    }
    if (this.gifts != null) {
      data['gifts'] = this.gifts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
