import 'dart:io';

import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
import 'package:ahlachat/models/Kickedusers.dart';
import 'package:ahlachat/models/RoomKarismaModel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/ShopModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/models/Weeklystarmodel.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/util/images.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../../models/Leaderboardroommodel.dart';
import '../../../models/Leaderboardusermodel.dart';

/// All shared state / properties for RoomViewmodel.
mixin RoomStateMixin on ChangeNotifier {
  // ── Country / Rank ──────────────────────────────────────────
  FlagModel? SelectedCountry;
  int LeaderIndex = 2;
  Color LeaderShipColor = Colors.orange;
  String LeaderShipBack = Images.RoomRankBack;

  Map SelectedRank = {
    'rank1': Images.RoomRank1,
    'rank2': Images.RoomRank2,
    'rank3': Images.RoomRank3,
  };

  List<Map> RankInmages = [
    {
      'rank1': Images.redRank1,
      'rank2': Images.redRank2,
      'rank3': Images.redRank3,
    },
    {
      'rank1': Images.blueRank1,
      'rank2': Images.blueRank2,
      'rank3': Images.blueRank3,
    },
    {
      'rank1': Images.RoomRank1,
      'rank2': Images.RoomRank2,
      'rank3': Images.RoomRank3,
    },
  ];

  List<Color> LeaderShipColors = [
    Color(0xFFff4f5b),
    Color(0xFF0039c4),
    Colors.orange,
  ];

  List<String> LeaderShipBacks = [
    Images.UserRankBackReciver,
    Images.UserRankBackGiver,
    Images.RoomRankBack,
  ];

  // ── Enter animation ─────────────────────────────────────────
  bool selected = false;
  double EnterOffser = 1.0;
  usermodel? EnterUserinfo;

  // ── Combo / Lucky ───────────────────────────────────────────
  bool showcombo = false;
  final CountdownController Timercontroller =
      CountdownController(autoStart: true);
  List Combouser = [];
  List Combowin = [];
  var Combocost;
  var ComboListuser = [];
  var ComboQuantity;
  var ComboGiftid;

  // ── Mention / Roulette ──────────────────────────────────────
  List<String> Rolletchoice = [];
  String? Mentionid;
  String? MentionName;

  // ── Room data ───────────────────────────────────────────────
  Roomkarismamodel? RoomLeader;
  List<KarismaCollectModel> Collectkarismas = [];
  var ChatRoomImage;
  final ImagePicker _picker2 = ImagePicker();
  ImagePicker get picker2 => _picker2;

  bool waitingtimer2 = false;
  bool waitingtimer = false;
  bool showgif = false;
  bool Giftstate = false;
  bool ImageLoading = false;
  bool JoinChairLoding = false;
  bool LeaveLoading = false;
  bool JoinChairs = false;

  ListoflEaderboardcategory? LeaderboardSupporter;
  ListoflEaderboardcategory? Leaderboardsupported;
  ListoflEaderboardFamilycategory? LeaderboardFamily;
  WeeklyStarModel? WeeklyStar;
  ListoflEaderboardcategoryRoom? LeaderboardRoom;

  // ── Chairs ──────────────────────────────────────────────────
  List<Chairs> ChairsRoom = [];
  List<Map<String, dynamic>> ChairMaps = [];
  List<String> InvitedChair = [];
  List<Gifts> RoomGifts = [];
  var Chairids, useridchair, ChairIndes;
  String Chairid = '0';
  int Chairidex = 0;

  // ── Controllers ─────────────────────────────────────────────
  TextEditingController SearchController = TextEditingController();
  TextEditingController Message = TextEditingController();
  TextEditingController RoomName = TextEditingController();
  TextEditingController RoomAds = TextEditingController();
  TextEditingController EditRoomName = TextEditingController();
  TextEditingController EditRoomDescription = TextEditingController();
  TextEditingController PasswordRoom = TextEditingController();
  TextEditingController EnterPasswordRoom = TextEditingController();

  Items? ShowItem;
  ScrollController? controller = ScrollController();

  // ── Room lists ──────────────────────────────────────────────
  List<RoomModel> Rooms = [];
  List<RoomModel> FixedRooms = [];
  List<RoomModel> FollowingUserRooms = [];
  List<RoomModel> RecomendedRoom = [];
  List<RoomModel> CountryRoom = [];
  List<RoomModel> ExploreRooms = [];
  List<RoomModel> FixedRoomList = [];
  List<RoomModel> SearchRooms = [];
  List<RoomModel> FollowedRooms = [];
  List<RoomModel> NewRooms = [];
  List<FlagModel> Countries = [];

  List<joinRoom> joinuserRooms = [];
  List<KickedUser> BlockeduserRooms = [];
  List UserIds = [];
  List Mutedids = [];
  List guesses = [];

  RoomModel? Currentroom;

  RefreshController refreshController5 =
      RefreshController(initialRefresh: false);
  RefreshController refreshController2 =
      RefreshController(initialRefresh: false);
  RefreshController refreshController3 =
      RefreshController(initialRefresh: false);

  // ── Create / Edit room ──────────────────────────────────────
  List choosen = [];
  List choosen2 = [];
  List backchoosen2 = [];
  String flagchoosen = '🇪🇬';
  List flagchoosen2 = [];

  var Roomimage;
  var Roomimage2;
  var Roomimage3;
  File? RoomBackgroundImage;

  // ── Category (referenced by updateSelectedCategory) ─────────
  dynamic SelectedRoomCategory;
}
