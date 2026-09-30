class FlagModel {
  int? id;
  String? name;
  String? flag;

  FlagModel({this.id, this.name, this.flag});

  FlagModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['flag'] = this.flag;
    return data;
  }
}