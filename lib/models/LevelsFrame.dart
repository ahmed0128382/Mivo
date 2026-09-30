
import '../util/app_constants.dart';

class LevelFrame {
  int? id;
  String? image;
  String? svga;
  String? levelStart;
  String? levelEnd;
  String? createdAt;
  String? updatedAt;

  LevelFrame(
      {this.id,
        this.image,
        this.svga,
        this.levelStart,
        this.levelEnd,
        this.createdAt,
        this.updatedAt});

  LevelFrame.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = AppConstants.Image_URL+json['image'];
    svga =AppConstants.Image_URL+ json['svga'];
    levelStart = json['level_start'];
    levelEnd = json['level_end'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['svga'] = this.svga;
    data['level_start'] = this.levelStart;
    data['level_end'] = this.levelEnd;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}