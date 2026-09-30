import 'package:ahlachat/models/emoji.dart';
import 'package:ahlachat/util/app_constants.dart';

class emojecategory {
  int? id;
  String? name;
  String? status;

  List<emojimodel>? emoji;

  emojecategory(
      {this.id,
        this.name,
        this.status,

        this.emoji});

  emojecategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name =AppConstants.Image_URL+ json['name'];
    status = json['status'];

    if (json['emoji'] != null) {
      emoji = <emojimodel>[];
      json['emoji'].forEach((v) {
        emoji!.add(new emojimodel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;

    if (this.emoji != null) {
      data['emoji'] = this.emoji!.map((v) => v.toJson()).toList();
    }
    return data;
  }

 }