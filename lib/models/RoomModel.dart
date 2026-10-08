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

  var importance;

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

  // ============================================================
  // Safe JSON Helpers
  // ============================================================

  int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    final String stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return null;
    }

    return int.tryParse(stringValue);
  }

  String? _toStringOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }

  String _imageUrl(dynamic value) {
    if (value == null) {
      return '';
    }

    final String path = value.toString().trim();

    if (path.isEmpty) {
      return '';
    }

    return AppConstants.Image_URL + path;
  }

  Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  // ============================================================
  // From JSON
  // ============================================================

  RoomModel.fromJson(Map<String, dynamic> json) {
    // ============================================================
    // Basic room information
    // ============================================================

    id = _toInt(json['id']);

    name = _toStringOrNull(json['name']);

    image = _imageUrl(json['image']);

    animateimage = _imageUrl(json['animateimage']);

    frame = _toStringOrNull(json['frame']);

    password = _toStringOrNull(json['password']);

    // ============================================================
    // Numeric fields
    // ============================================================

    userNumber = _toInt(json['user_number']);

    adminId = _toInt(json['admin_id']);

    SecondKing = _toInt(json['SecondKing']);

    locked = _toInt(json['Locked']);

    state = _toInt(json['state']);

    FollowRoom = _toInt(json['FollowRoom']);

    Karisma = _toInt(json['Karisma']);

    // ============================================================
    // String fields
    // ============================================================

    Category = _toStringOrNull(json['Category']);

    city = _toStringOrNull(json['city']);

    createdAt = _toStringOrNull(json['created_at']);

    updatedAt = _toStringOrNull(json['updated_at']);

    nothostedimage = _toStringOrNull(json['animateimage']);

    Token = _toStringOrNull(json['Token']);

    RoomID = _toStringOrNull(json['RoomID']);

    agoratoken = _toStringOrNull(json['agoratoken']);

    RoomAds = _toStringOrNull(json['RoomAds']);

    importance = json['importance'];

    // ============================================================
    // Join Rooms
    // ============================================================

    if (json['join_room'] is List) {
      joinRooms = <joinRoom>[];

      for (final dynamic value in json['join_room']) {
        final map = _toMap(value);

        if (map != null) {
          joinRooms!.add(
            joinRoom.fromJson(map),
          );
        }
      }
    }

    // ============================================================
    // Supervisors
    // ============================================================

    if (json['supervisors'] is List) {
      supervisor = <Supervisors>[];
      supervisorsId = <String>[];

      for (final dynamic value in json['supervisors']) {
        final map = _toMap(value);

        if (map == null) {
          continue;
        }

        supervisor!.add(
          Supervisors.fromJson(map),
        );

        final dynamic userId = map['user_id'];

        if (userId != null) {
          supervisorsId!.add(
            userId.toString(),
          );
        }
      }
    }

    // ============================================================
    // Admin
    // ============================================================

    final adminJson = _toMap(json['admin']);

    admin = adminJson != null
        ? usermodel.fromJson(adminJson)
        : null;

    // ============================================================
    // Chairs
    // ============================================================

    if (json['chairs'] is List) {
      chairs = <Chairs>[];

      for (final dynamic value in json['chairs']) {
        final map = _toMap(value);

        if (map != null) {
          chairs!.add(
            Chairs.fromJson(map),
          );
        }
      }
    }

    // ============================================================
    // Chatroom
    // ============================================================

    if (json['chatroom'] is List) {
      chatroom = <Chatroom>[];

      for (final dynamic value in json['chatroom']) {
        final map = _toMap(value);

        if (map != null) {
          chatroom!.add(
            Chatroom.fromJson(map),
          );
        }
      }
    }
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;

    data['image'] = image;
    data['animateimage'] = animateimage;

    data['frame'] = frame;

    data['Token'] = Token;

    data['password'] = password;

    data['RoomID'] = RoomID;

    data['user_number'] = userNumber;
    data['admin_id'] = adminId;

    data['Locked'] = locked;
    data['state'] = state;

    data['FollowRoom'] = FollowRoom;

    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    data['Category'] = Category;
    data['city'] = city;

    data['importance'] = importance;

    data['agoratoken'] = agoratoken;
    data['RoomAds'] = RoomAds;

    data['Karisma'] = Karisma;
    data['SecondKing'] = SecondKing;

    if (joinRooms != null) {
      data['join_room'] = joinRooms!
          .map((v) => v.toJson())
          .toList();
    }

    if (supervisor != null) {
      data['supervisors'] = supervisor!
          .map((v) => v.toJson())
          .toList();
    }

    if (admin != null) {
      data['admin'] = admin!.toJson();
    }

    if (chairs != null) {
      data['chairs'] = chairs!
          .map((v) => v.toJson())
          .toList();
    }

    if (chatroom != null) {
      data['chatroom'] = chatroom!
          .map((v) => v.toJson())
          .toList();
    }

    return data;
  }
}
