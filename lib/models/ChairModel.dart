import 'package:ahlachat/models/Usermodel.dart';

class Chairs {
  int? id;
  String? userId;
  String? roomId;
  String? chairId;
  int? mute;
  String? createdAt;
  String? updatedAt;
  usermodel? user;
  int? Lock;
  int? Karisma;
  int? adminleaved;

  Chairs({
    this.id,
    this.userId,
    this.roomId,
    this.chairId,
    this.createdAt,
    this.adminleaved,
    this.updatedAt,
    this.user,
    this.mute,
    this.Lock,
    this.Karisma,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    return int.tryParse(text);
  }

  static String? _toStringOrNull(dynamic value) {
    if (value == null) return null;

    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;

    if (value is Map) {
      try {
        return Map<String, dynamic>.from(value);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  factory Chairs.fromJson(Map<String, dynamic> json) {
    final userJson = _toMap(json['user']);

    return Chairs(
      id: _toInt(json['id']),
      userId: _toStringOrNull(json['user_id']),
      roomId: _toStringOrNull(json['room_id']),
      chairId: _toStringOrNull(json['chair_id']),
      createdAt: _toStringOrNull(json['created_at']),
      updatedAt: _toStringOrNull(json['updated_at']),
      user: userJson != null ? usermodel.fromJson(userJson) : null,
      mute: _toInt(json['mute']),
      Lock: _toInt(json['Lock'] ?? json['lock']),
      Karisma: _toInt(json['Karisma'] ?? json['karisma']),
      adminleaved: _toInt(json['adminleaved']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'room_id': roomId,
      'chair_id': chairId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'Lock': Lock,
      'mute': mute,
      'adminleaved': adminleaved,
      'Karisma': Karisma,
      if (user != null) 'user': user!.toJson(),
    };
  }
}
