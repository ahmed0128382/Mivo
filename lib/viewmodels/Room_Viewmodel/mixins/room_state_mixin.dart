import 'dart:async';
import 'dart:io';

import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
import 'package:ahlachat/models/Leaderboardroommodel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/models/Weeklystarmodel.dart';
import 'package:ahlachat/models/guessGameModel.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/notification.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/SearchScrean/widgets/SearchRoom.dart';
import 'package:ahlachat/viewmodels/Music_Viewmodel/MusicViewmodel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/repositores/Room_repositores/Room_api.dart';
import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/models/Chatroom.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/Kickedusers.dart';
import 'package:ahlachat/models/RoomKarismaModel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/ShopModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timer_count_down/timer_controller.dart';
mixin RoomStateMixin on ChangeNotifier {
  FlagModel? SelectedCountry;

  bool showcombo = false;

  final CountdownController Timercontroller =
      new CountdownController(autoStart: true);

  List Combouser = [];

  List Combowin = [];

  int LeaderIndex = 2;

  Color LeaderShipColor = Colors.orange;

  String LeaderShipBack = Images.RoomRankBack;

  Map SelectedRank = {
    'rank1': Images.RoomRank1,
    'rank2': Images.RoomRank2,
    'rank3': Images.RoomRank3,
  };

  bool selected = false;

  double EnterOffser = 1.0;

  usermodel? EnterUserinfo;

  bool showloading13 = false;

  List<String> Rolletchoice = [];

  String? Mentionid;

  String? MentionName;

  Roomkarismamodel? RoomLeader;

  var ChatRoomImage;


  bool waitingtimer2 = false;

  ListoflEaderboardcategory? LeaderboardSupporter;

  ListoflEaderboardcategory? Leaderboardsupported;

  ListoflEaderboardFamilycategory? LeaderboardFamily;

  WeeklyStarModel? WeeklyStar;

  ListoflEaderboardcategoryRoom? LeaderboardRoom;

  bool showloading = false;

  bool showloading2 = false;

  bool showloading3 = false;

  bool showloading5 = false;

  bool showloading6 = false;

  bool showloading7 = false;

  bool showloading8 = false;

  bool showloading14 = false;

  bool showloading17 = false;

  bool showloading18 = false;

  bool showloading19 = false;

  bool showloading21 = false;

  bool showloading24 = false;

  bool showloading25 = false;

  bool showloading26 = false;

  bool showloading27 = false;

  bool showloading28 = false;

  bool showloading29 = false;

  bool showloading30 = false;

  bool showloading31 = false;

  bool showloading32 = false;

  bool showloading33 = false;

  bool showloading34 = false;

  bool showloading35 = false;

  bool showloading36 = false;

  bool showloading37 = false;

  bool showloading38 = false;

  bool showloading39 = false;

  bool showloading40 = false;

  bool showloading41 = false;

  bool showloading42 = false;

  bool showloading44 = false;

  bool showloading45 = false;

  bool showloading46 = false;

  bool showloading47 = false;

  List<Chairs> ChairsRoom = [];

  List<Map<String, dynamic>> ChairMaps = [];

  List<String> InvitedChair = [];

  List<Gifts> RoomGifts = [];

  var Chairids, useridchair, ChairIndes;

  String Chairid = '0';

  int Chairidex = 0;

  TextEditingController SearchController =
      TextEditingController();

  TextEditingController Message =
      TextEditingController();

  Items? ShowItem;

  TextEditingController RoomName =
      TextEditingController();

  TextEditingController RoomAds =
      TextEditingController();

  TextEditingController EditRoomName =
      TextEditingController();

  TextEditingController EditRoomDescription =
      TextEditingController();

  TextEditingController PasswordRoom =
      TextEditingController();

  TextEditingController EnterPasswordRoom =
      TextEditingController();

  bool showgif = false;

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

  RoomModel? Currentroom;

  RefreshController refreshController5 =
      RefreshController(initialRefresh: false);

  RefreshController refreshController2 =
      RefreshController(initialRefresh: false);

  RefreshController refreshController3 =
      RefreshController(initialRefresh: false);

  List choosen = [];

  List choosen2 = [];

  List backchoosen2 = [];

  String flagchoosen = '🇪🇬';

  List flagchoosen2 = [];

  List<KarismaCollectModel> Collectkarismas = [];

  bool waitingtimer = false;

  ScrollController? controller =
      ScrollController();

  var Roomimage;

  var Roomimage2;

  var Roomimage3;

  File? RoomBackgroundImage;

  bool Giftstate = false;

  List Mutedids = [];


  bool GetGiverLeadestatr = false;

  bool isCallGiver = false;

  bool GetWeeklyStars = false;

  bool GetReciverLeadestatr = false;

  bool isCallReciver = false;

  bool JoinChairLoding = false;

  bool LeaveLoading = false;

  List guesses = [];

  var Combocost;

  var ComboListuser = [];

  var ComboQuantity;

  var ComboGiftid;

  bool ImageLoading = false;

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
    }
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


  
  bool JoinChairs = false;
  dynamic SelectedRoomCategory;

  // Public so other mixin files can access (library-private _ fields don't cross files)
  final ImagePicker picker = ImagePicker();
  final ImagePicker picker2 = ImagePicker();
}
