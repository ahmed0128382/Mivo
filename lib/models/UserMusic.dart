
class usermusic {
  int? id;
  int? userId;
  String? name;
  String? url;
  String? createdAt;
  String? updatedAt;

  usermusic({
    this.id,
    this.userId,
    this.name,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  usermusic.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    userId = _toInt(json['user_id']);
    name = json['name']?.toString();
    url = json['url']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'url': url,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
