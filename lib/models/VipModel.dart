import 'package:ahlachat/util/app_constants.dart';

class VipModel {
  int? id;
  String? gif;
  String? name;
  int? status;
  String? vipicon;
  var backgroundimage;
  String? urlentry;
  String? urlframe;
  String? entry;
  String? frame;
  String? bubbles;
  int? level;
  int? specialID;
  var profileEntry;
  var urlprofileEntry;
  var coloredMessage;
  var hidden;
  String? createdAt;
  String? updatedAt;
  int? cost;
  int? day;

  VipModel({
    this.id,
    this.gif,
    this.name,
    this.status,
    this.vipicon,
    this.backgroundimage,
    this.urlentry,
    this.urlframe,
    this.level,
    this.specialID,
    this.profileEntry,
    this.coloredMessage,
    this.hidden,
    this.cost,
    this.day,
    this.createdAt,
    this.updatedAt,
    this.urlprofileEntry,
  });

  VipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    
    // Safely concatenate base URL only if the field is not null and is a string
    gif = json['Gif'] != null ? AppConstants.Image_URL + json['Gif'].toString() : null;
    
    name = json['name'];
    status = json['status'];
    
    vipicon = json['vipicon'] != null ? AppConstants.Image_URL + json['vipicon'].toString() : null;

    backgroundimage = json['background_image'] == null 
        ? null 
        : AppConstants.Image_URL + json['background_image'].toString();

    urlentry = json['Entry'] != null ? AppConstants.Image_URL + json['Entry'].toString() : null;
    urlframe = json['Frame'] != null ? AppConstants.Image_URL + json['Frame'].toString() : null;
    
    entry = json['Entry']?.toString();
    frame = json['Frame']?.toString();

    level = json['Level'];
    
    // Safely parse cost which could be int or double (e.g. 1000.00)
    if (json['cost'] != null) {
      cost = double.tryParse(json['cost'].toString())?.toInt();
    }
    
    specialID = json['SpecialID'];
    
    profileEntry = json['ProfileEntry'] == null 
        ? null 
        : AppConstants.Image_URL + json['ProfileEntry'].toString();
        
    bubbles = json['ProfileEntry']?.toString();
    coloredMessage = json['ColoredMessage'];
    hidden = json['Hidden'];

    day = json['days'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Gif'] = this.gif;
    data['name'] = this.name;
    data['status'] = this.status;
    data['vipicon'] = this.vipicon;
    data['Entry'] = this.urlentry;
    data['Frame'] = this.urlframe;
    data['Level'] = this.level;
    data['background_image'] = this.backgroundimage;
    data['SpecialID'] = this.specialID;
    data['ProfileEntry'] = this.profileEntry;
    data['ColoredMessage'] = this.coloredMessage;
    data['Hidden'] = this.hidden;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}