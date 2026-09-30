class FamilyRequestModel {
  int? userId;
  int? familyId;
  String? updatedAt;
  String? createdAt;
  int? id;

  FamilyRequestModel(
      {this.userId, this.familyId, this.updatedAt, this.createdAt, this.id});

  FamilyRequestModel.fromJson(Map<String, dynamic> json) {
    userId = int.parse(json['user_id'].toString());
    familyId = int.parse(json['Family_id'].toString());
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['Family_id'] = this.familyId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
