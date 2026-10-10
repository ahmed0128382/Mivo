import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/SupervisorsModel.dart';
import 'package:ahlachat/models/Usermodel.dart';

import '../util/app_constants.dart';

class RoomModel {
  int? id;

  String? name;
  String? image;
  String? nothostedimage;
  String? animateimage;
  String? frame;
  String? password;

  int? userNumber;
  int? adminId;
  int? SecondKing;

  dynamic importance;

  int? locked;
  int? state;

  String? Category;
  String? createdAt;
  String? updatedAt;
  String? city;

  List<joinRoom>? joinRooms;

  List<Supervisors>? supervisor = [];
  List<String>? supervisorsId = [];

  usermodel? admin;

  List<Chairs>? chairs;
  List<Chatroom>? chatroom;

  String? Token;
  String? agoratoken;
  String? RoomAds;
  String? RoomID;

  int? Karisma;
  int? FollowRoom;

  RoomModel({
    this.id,
    this.name,
    this.RoomID,
    this.image,
    this.frame,
    this.password,
    this.userNumber,
    this.adminId,
    this.locked,
    this.state,
    this.city,
    this.Category,
    this.createdAt,
    this.updatedAt,
    this.joinRooms,
    this.supervisor,
    this.supervisorsId,
    this.animateimage,
    this.admin,
    this.chairs,
    this.chatroom,
    this.Token,
    this.importance,
    this.nothostedimage,
    this.agoratoken,
    this.RoomAds,
    this.Karisma,
    this.SecondKing,
    this.FollowRoom,
  });

  // ------------------------------------------------------------
  // Safe JSON helpers
  // ------------------------------------------------------------

  static int? _toInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    if (value is num) return value.toInt();

    final String text = value.toString().trim();

    if (text.isEmpty) return null;

    return int.tryParse(text);
  }

  static String? _toStringOrNull(dynamic value) {
    if (value == null) return null;

    final String text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  static Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  static String _imageUrl(dynamic value) {
    if (value == null) return '';

    final String path = value.toString().trim();

    if (path.isEmpty) return '';

    // Keep absolute URLs unchanged.
    final Uri? uri = Uri.tryParse(path);

    if (uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty) {
      return path;
    }

    final String baseUrl = AppConstants.Image_URL.trim();

    if (baseUrl.isEmpty) return path;

    final String normalizedBase =
        baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl;

    final String normalizedPath =
        path.startsWith('/') ? path.substring(1) : path;

    return '$normalizedBase/$normalizedPath';
  }

  // ------------------------------------------------------------
  // From JSON
  // ------------------------------------------------------------

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    final room = RoomModel();

    // Basic room information.
    room.id = _toInt(json['id']);
    room.name = _toStringOrNull(json['name']);

    room.image = _imageUrl(json['image']);
    room.animateimage = _imageUrl(json['animateimage']);

    room.frame = _toStringOrNull(json['frame']);
    room.password = _toStringOrNull(json['password']);

    // Numeric fields.
    room.userNumber = _toInt(json['user_number']);
    room.adminId = _toInt(json['admin_id']);
    room.SecondKing = _toInt(json['SecondKing']);

    room.locked = _toInt(json['Locked'] ?? json['locked']);
    room.state = _toInt(json['state']);
    room.FollowRoom = _toInt(json['FollowRoom']);
    room.Karisma = _toInt(json['Karisma']);

    // String fields.
    room.Category = _toStringOrNull(json['Category']);
    room.city = _toStringOrNull(json['city']);
    room.createdAt = _toStringOrNull(json['created_at']);
    room.updatedAt = _toStringOrNull(json['updated_at']);

    room.nothostedimage = _toStringOrNull(json['animateimage']);

    room.Token = _toStringOrNull(json['Token']);
    room.RoomID = _toStringOrNull(json['RoomID']);
    room.agoratoken = _toStringOrNull(json['agoratoken']);
    room.RoomAds = _toStringOrNull(json['RoomAds']);

    room.importance = json['importance'];

    // Join rooms.
    final dynamic joinRoomJson = json['join_room'];

    if (joinRoomJson is List) {
      room.joinRooms = <joinRoom>[];

      for (final dynamic value in joinRoomJson) {
        final map = _toMap(value);

        if (map == null) continue;

        room.joinRooms!.add(joinRoom.fromJson(map));
      }
    }

    // Supervisors.
    final dynamic supervisorsJson = json['supervisors'];

    if (supervisorsJson is List) {
      room.supervisor = <Supervisors>[];
      room.supervisorsId = <String>[];

      for (final dynamic value in supervisorsJson) {
        final map = _toMap(value);

        if (map == null) continue;

        room.supervisor!.add(Supervisors.fromJson(map));

        final dynamic supervisorUserId = map['user_id'];

        if (supervisorUserId != null) {
          room.supervisorsId!.add(supervisorUserId.toString());
        }
      }
    }

    // Admin.
    final Map<String, dynamic>? adminJson = _toMap(json['admin']);

    room.admin =
        adminJson != null ? usermodel.fromJson(adminJson) : null;

    // Chairs.
    final dynamic chairsJson = json['chairs'];

    if (chairsJson is List) {
      room.chairs = <Chairs>[];

      for (final dynamic value in chairsJson) {
        final map = _toMap(value);

        if (map == null) continue;

        room.chairs!.add(Chairs.fromJson(map));
      }
    }

    // Chatroom messages.
    final dynamic chatroomJson = json['chatroom'];

    if (chatroomJson is List) {
      room.chatroom = <Chatroom>[];

      for (final dynamic value in chatroomJson) {
        final map = _toMap(value);

        if (map == null) continue;

        room.chatroom!.add(Chatroom.fromJson(map));
      }
    }

    return room;
  }

  // ------------------------------------------------------------
  // To JSON
  // ------------------------------------------------------------

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'animateimage': animateimage,
      'frame': frame,
      'Token': Token,
      'password': password,
      'RoomID': RoomID,
      'user_number': userNumber,
      'admin_id': adminId,
      'Locked': locked,
      'state': state,
      'FollowRoom': FollowRoom,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'Category': Category,
      'city': city,
      'importance': importance,
      'agoratoken': agoratoken,
      'RoomAds': RoomAds,
      'Karisma': Karisma,
      'SecondKing': SecondKing,
      if (joinRooms != null)
        'join_room': joinRooms!.map((value) => value.toJson()).toList(),
      if (supervisor != null)
        'supervisors': supervisor!.map((value) => value.toJson()).toList(),
      if (admin != null) 'admin': admin!.toJson(),
      if (chairs != null)
        'chairs': chairs!.map((value) => value.toJson()).toList(),
      if (chatroom != null)
        'chatroom': chatroom!.map((value) => value.toJson()).toList(),
    };
  }
}