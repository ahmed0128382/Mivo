import 'package:ahlachat/core/network/api_client.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/Kickedusers.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
import 'package:ahlachat/models/SupervisorsModel.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:dio/dio.dart';

import 'room_api_error_mixin.dart';

/// Shared state for room API operations.
///
/// Room participants are represented by joinuserRooms and the room's
/// joinRooms list. Chair data must not be used to determine membership.
mixin RoomApiStateMixin on RoomApiErrorMixin {
  final Dio dio = ApiClient.instance.dio;

  List<RoomModel> ImportantRooms = [];
  List<FlagModel> Countries = [];
  List<RoomModel> FixedRooms = [];
  List<RoomModel> TradeRooms = [];

  List<KickedUser> KickeduserRooms = [];

  /// Membership records loaded from the room participants API.
  List<joinRoom> joinuserRooms = [];

  RoomModel Roominfo = RoomModel();

  final List<KarismaCollectModel> karismas = [];
  final List<Gifts> RoomGifts = [];
  final List<Supervisors> SupervisorRoom = [];
}