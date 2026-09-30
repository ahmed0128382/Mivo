class usermusic {
  int? id;
  int? userId;
  String? name;
  String? url;
  String? createdAt;
  String? updatedAt;

  usermusic(
      {this.id,
        this.userId,
        this.name,
        this.url,
        this.createdAt,
        this.updatedAt});

  usermusic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = int.parse(json['user_id'].toString());
    name = json['name'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}