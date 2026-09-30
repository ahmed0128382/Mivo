import 'package:ahlachat/models/AchiveModel.dart';
import 'package:ahlachat/util/app_constants.dart';

class UserModels {
  int? id;
  int? Achiveid;
  int? userId;

  AchiveModels?AchiveModel;
  String? createdAt;
  String? updatedAt;

  UserModels(
      {this.id, this.Achiveid, this.userId, this.createdAt, this.updatedAt});

  UserModels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    Achiveid =json['Achiveid'];
    AchiveModel=json['model'] != null ? new AchiveModels.fromJson(json['model']) : null;
    userId = int.parse(json['user_id'].toString());
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Achiveid'] = this.Achiveid;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;

    if (this.AchiveModel != null) {
      data['model'] = this.AchiveModel!.toJson();
    }
    data['updated_at'] = this.updatedAt;
    return data;
  }
}