import 'dart:async';
import 'dart:io';

import 'package:ahlachat/main.dart';
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
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
import 'package:ahlachat/Repositores/Room_repositores/Room_api.dart';
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

import '../../models/Leaderboardroommodel.dart';
import '../../models/Leaderboardusermodel.dart';

class RoomViewmodel extends ChangeNotifier {
  FlagModel? SelectedCountry;
  bool showcombo = false;

  final CountdownController Timercontroller =
      new CountdownController(autoStart: true);

  ShowLuckyCombo() {
    showcombo = true;
    Timercontroller.start();
    notifyListeners();
  }

  HideLuckyCombo() {
    showcombo = false;
    Timercontroller.pause();
    notifyListeners();
  }

  List Combouser = [];
  List Combowin = [];

  addCombo({
    int? id,
    image,
    image2,
    count,
  }) {
    var DDDD =
        Combouser.where((element) => element['uid'] == id);

    print(
      'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD',
    );
    print(DDDD.toList());
    print(
      'DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD',
    );

    if (DDDD.toList().length != 0) {
      DDDD.first['count'] =
          int.parse(DDDD.first['count'].toString()) +
              int.parse(count.toString());

      DDDD.first['time'] = DateTime.now();

      notifyListeners();
    } else {
      Combouser.add({
        'uid': id,
        'time': DateTime.now(),
        'image': image,
        'count': count,
        'imagegift': image2,
      });

      if (Combouser.length > 0) {
        Timer.periodic(
          Duration(seconds: 2),
          (timer) {
            for (var i in Combouser) {
              if (DateTime.now()
                      .difference(i['time'])
                      .inSeconds >
                  6) {
                if (Combouser.length > 0) {
                  Combouser.remove(i);
                  notifyListeners();
                  break;
                }
              }
            }
          },
        );
      }
    }

    notifyListeners();
  }

  addComboWin({
    persantage,
    amount,
  }) {
    Combowin.add({
      'time': DateTime.now(),
      'persantage': persantage,
      'amount': amount,
    });

    if (Combowin.length > 0) {
      Timer.periodic(
        Duration(seconds: 2),
        (timer) {
          for (var i in Combowin) {
            if (DateTime.now()
                    .difference(i['time'])
                    .inSeconds >
                2) {
              if (Combowin.length > 0) {
                Combowin.remove(i);
                notifyListeners();
                break;
              }
            }
          }
        },
      );
    }

    notifyListeners();
  }

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

  ShowEnterWidget({
    usermodel? Info,
  }) {
    EnterUserinfo = Info;
    EnterOffser = -1;
    selected = true;
    notifyListeners();
  }

  HideEnterWidget() {
    if (EnterOffser == -10.5) {
      EnterOffser = 6.0;
    } else {
      EnterOffser = -10.5;

      Future.delayed(
        Duration(milliseconds: 500),
        () {
          selected = false;
        },
      );
    }

    notifyListeners();
  }

 EnterRoom({
  required id,
  required context,
  required adminId,
}) async {
  if (LeaveLoading == true) {
    Dialogs().showtoast('رجاء انتظر ترك الغرفه');
    return 'asd';
  }

  if (Currentroom?.id.toString() == id.toString()) {
    Provider.of<SvgViewmodel>(
      context,
      listen: false,
    ).animationController?.clear();

    Provider.of<RoomViewmodel>(
      context,
      listen: false,
    ).initscrollcontroller();

    Provider.of<GiftsViewModel>(
      context,
      listen: false,
    ).DeleteGlopal();

    Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).stopAudioMexing(context);

    HideEnterWidget();

    Navigator.pushNamed(
      context,
      AppConstants.Room_Screan,
    );
  } else {
    await TrackRoomPassword(id).then(
      (password) {
        if (password == true &&
            adminId.toString() != UserId &&
            Provider.of<LoginViewmodel>(
                  context,
                  listen: false,
                ).userinfo?.Hidden ==
                0) {
          DismissGlopalLoading();

          final TextEditingController EnterPasswordRoom =
              TextEditingController();

          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) => AlertDialog(
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          getLang(
                            context: context,
                            key: "Enter_Password",
                          ),
                          style: style1,
                        ),
                        SizedBox(height: 25),
                        PinCodeTextField(
                          keyboardType: TextInputType.number,
                          length: 4,
                          obscureText: false,
                          textStyle: TextStyle(
                            color: Color(0xFFeae2be),
                          ),
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            borderWidth: 0.0,
                            shape: PinCodeFieldShape.box,
                            fieldOuterPadding:
                                EdgeInsets.symmetric(horizontal: 3),
                            activeColor: Color(0xFFeae2be),
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Color(0xFFeae2be),
                            inactiveColor: Color(0xFFeae2be),
                            fieldHeight: 40,
                            fieldWidth: 40,
                            activeFillColor: Color(0xFFeae2be),
                          ),
                          animationDuration:
                              Duration(milliseconds: 300),
                          cursorColor: Color(0xFFeae2be),
                          enablePinAutofill: true,
                          enableActiveFill: false,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          enabled: true,
                          controller: EnterPasswordRoom,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                        InkWell(
                          onTap: () {
                            if (EnterPasswordRoom.text.length < 4) {
                              return;
                            }

                            Navigator.pop(context);

                            EnterTrackRoomPassword(
                              id: id,
                              pass: EnterPasswordRoom.text,
                            ).then(
                              (value) {
                                if (value == true) {
                                  Provider.of<GiftsViewModel>(
                                    context,
                                    listen: false,
                                  ).hidpanner2();

                                  // IMPORTANT:
                                  // Do NOT call SvgViewmodel.dispose().
                                  // Provider owns the SvgViewmodel lifecycle.

                                  JoinRoom4(
                                    Roomid: id,
                                    context: context,
                                  );
                                } else {
                                  DismissGlopalLoading();

                                  Dialogs().showtoast(
                                    getLang(
                                      context: context,
                                      key: "Wrong_Password",
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                getLang(
                                  context: context,
                                  key: "Done",
                                ),
                                style: style6.copyWith(
                                  fontSize: 15,
                                  height: 1,
                                ),
                              ),
                            ),
                            width: SizeConfig.screenWidth!,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10),
                              color: Color(0xFFeae2be),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              backgroundColor: Color(0xFF2b2f3b),
            ),
          );
        } else {
          Provider.of<GiftsViewModel>(
            context,
            listen: false,
          ).hidpanner2();

          JoinRoom4(
            Roomid: id,
            context: context,
          );
        }
      },
    );
  }
}

SelectedLeader(val) {
    LeaderShipColor = LeaderShipColors[val];
    LeaderShipBack = LeaderShipBacks[val];
    SelectedRank = RankInmages[val];
    notifyListeners();
  }

EnterRoom2({
  id,
  context,
}) async {
  if (LeaveLoading == true) {
    Dialogs().showtoast('رجاء انتظر ترك الغرفه');
    return 'asd';
  }

  if (Currentroom?.id.toString() == id.toString()) {
    return;
  } else {
    await TrackRoomPassword(id).then(
      (password) {
        if (password == true) {
          DismissGlopalLoading();

          final TextEditingController EnterPasswordRoom =
              TextEditingController();

          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) => AlertDialog(
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          getLang(
                            context: context,
                            key: "Enter_Password",
                          ),
                          style: style1,
                        ),
                        SizedBox(height: 25),
                        PinCodeTextField(
                          keyboardType: TextInputType.number,
                          length: 4,
                          obscureText: false,
                          textStyle: TextStyle(
                            color: Color(0xFFeae2be),
                          ),
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            borderWidth: 0.0,
                            shape: PinCodeFieldShape.box,
                            fieldOuterPadding:
                                EdgeInsets.symmetric(horizontal: 3),
                            activeColor: Color(0xFFeae2be),
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Color(0xFFeae2be),
                            inactiveColor: Color(0xFFeae2be),
                            fieldHeight: 40,
                            fieldWidth: 40,
                            activeFillColor: Color(0xFFeae2be),
                          ),
                          animationDuration:
                              Duration(milliseconds: 300),
                          cursorColor: Color(0xFFeae2be),
                          enablePinAutofill: true,
                          enableActiveFill: false,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          enabled: true,
                          controller: EnterPasswordRoom,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                        InkWell(
                          onTap: () {
                            if (EnterPasswordRoom.text.length < 4) {
                              return;
                            }

                            Navigator.pop(context);

                            EnterTrackRoomPassword(
                              id: id,
                              pass: EnterPasswordRoom.text,
                            ).then(
                              (value) {
                                if (value == true) {
                                  Provider.of<GiftsViewModel>(
                                    context,
                                    listen: false,
                                  ).hidpanner2();

                                  // IMPORTANT:
                                  // Do NOT call SvgViewmodel.dispose().
                                  // Provider owns the SvgViewmodel lifecycle.

                                  JoinRoom4(
                                    context: context,
                                    Roomid: id,
                                  );
                                } else {
                                  DismissGlopalLoading();

                                  Dialogs().showtoast(
                                    getLang(
                                      context: context,
                                      key: "Wrong_Password",
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                getLang(
                                  context: context,
                                  key: "Done",
                                ),
                                style: style6.copyWith(
                                  fontSize: 15,
                                  height: 1,
                                ),
                              ),
                            ),
                            width: SizeConfig.screenWidth!,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10),
                              color: Color(0xFFeae2be),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              backgroundColor: Color(0xFF2b2f3b),
            ),
          );
        } else {
          Provider.of<GiftsViewModel>(
            context,
            listen: false,
          ).hidpanner2();

          // IMPORTANT:
          // Do NOT call SvgViewmodel.dispose() here.

          JoinRoom4(
            context: context,
            Roomid: id,
          );
        }
      },
    );
  }
}

EnterRoom3({
  id,
  context,
}) async {
  if (LeaveLoading == true) {
    Dialogs().showtoast('رجاء انتظر ترك الغرفه');
    return 'asd';
  }

  if (Currentroom?.id.toString() == id.toString()) {
    return;
  } else {
    await TrackRoomPassword(id).then(
      (password) {
        if (password == true) {
          DismissGlopalLoading();

          final TextEditingController EnterPasswordRoom =
              TextEditingController();

          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (_) => AlertDialog(
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          getLang(
                            context: context,
                            key: "Enter_Password",
                          ),
                          style: style1,
                        ),
                        SizedBox(height: 25),
                        PinCodeTextField(
                          keyboardType: TextInputType.number,
                          length: 4,
                          obscureText: false,
                          textStyle: TextStyle(
                            color: Color(0xFFeae2be),
                          ),
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            borderWidth: 0.0,
                            shape: PinCodeFieldShape.box,
                            fieldOuterPadding:
                                EdgeInsets.symmetric(horizontal: 3),
                            activeColor: Color(0xFFeae2be),
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: Color(0xFFeae2be),
                            inactiveColor: Color(0xFFeae2be),
                            fieldHeight: 40,
                            fieldWidth: 40,
                            activeFillColor: Color(0xFFeae2be),
                          ),
                          animationDuration:
                              Duration(milliseconds: 300),
                          cursorColor: Color(0xFFeae2be),
                          enablePinAutofill: true,
                          enableActiveFill: false,
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          enabled: true,
                          controller: EnterPasswordRoom,
                          onCompleted: (v) {},
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            return true;
                          },
                          appContext: context,
                        ),
                        InkWell(
                          onTap: () {
                            if (EnterPasswordRoom.text.length < 4) {
                              return;
                            }

                            Navigator.pop(context);

                            EnterTrackRoomPassword(
                              id: id,
                              pass: EnterPasswordRoom.text,
                            ).then(
                              (value) {
                                if (value == true) {
                                  Provider.of<GiftsViewModel>(
                                    context,
                                    listen: false,
                                  ).hidpanner2();

                                  // IMPORTANT:
                                  // Do NOT call SvgViewmodel.dispose().
                                  // Provider owns the SvgViewmodel lifecycle.

                                  JoinRoom2(
                                    context: context,
                                    Roomid: id,
                                  );
                                } else {
                                  DismissGlopalLoading();

                                  Dialogs().showtoast(
                                    getLang(
                                      context: context,
                                      key: "Wrong_Password",
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                getLang(
                                  context: context,
                                  key: "Done",
                                ),
                                style: style6.copyWith(
                                  fontSize: 15,
                                  height: 1,
                                ),
                              ),
                            ),
                            width: SizeConfig.screenWidth!,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(10),
                              color: Color(0xFFeae2be),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              backgroundColor: Color(0xFF2b2f3b),
            ),
          );
        } else {
          Provider.of<GiftsViewModel>(
            context,
            listen: false,
          ).hidpanner2();

          JoinRoom2(
            context: context,
            Roomid: id,
          );
        }
      },
    );
  }
}

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

  GetSelectedCountry(FlagModel val) {
    SelectedCountry = val;
    GetCountriRoom();
    notifyListeners();
  }

  bool showloading13 = false;
  List<String> Rolletchoice = [];
  String? Mentionid;
  String? MentionName;
  Roomkarismamodel? RoomLeader;
  var ChatRoomImage;

  final ImagePicker _picker2 = ImagePicker();

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

  // Used for editing an existing room.
  List backchoosen2 = [];

  String flagchoosen = '🇪🇬';
  List flagchoosen2 = [];

  void changeloading13() {
    showloading13 = !showloading13;
    notifyListeners();
  }

  updateSelectedCategory({
    Category,
    context,
  }) {
    SelectedRoomCategory = Category;
    GetRoom(context: context);
    notifyListeners();
  }

  GetRoomKarisma({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .RoomsKarisma(
      context: context,
      room_id: Currentroom?.id,
    )
        .then(
      (value) {
        RoomLeader = value;
        notifyListeners();
        DismissGlopalLoading();
      },
    );
  }

  List<KarismaCollectModel> Collectkarismas = [];

  GetCollectKarisma({
    context,
    userid,
    required chairid,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .GetCollectKarisma(
      context: context,
      room_id: Currentroom?.id,
      user_id: userid,
      chairid: chairid,
    )
        .then(
      (value) {
        Collectkarismas = value;
        notifyListeners();
        DismissGlopalLoading();
      },
    );
  }

  GetMentionid({
    String? id,
    String? name,
  }) {
    Mentionid = id;
    MentionName = name;
  }

  Future getChatRoomImage() async {
    bool selected = false;

    final pickedFile =
        await _picker2.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      ChatRoomImage = File(
        pickedFile.path,
      );

      selected = true;

      notifyListeners();
    } else {
      selected = false;
    }

    notifyListeners();

    return selected;
  }

  ClearMentionid() {
    Mentionid = null;
    MentionName = null;
  }

  AddRolletchoice(String name) {
    Rolletchoice.add(name);
    notifyListeners();
  }

  RemoveRolletchoice(String userinfo) {
    Rolletchoice.remove(userinfo);
    notifyListeners();
  }

  showwaitingtimer2() {
    waitingtimer2 = true;
    notifyListeners();
  }

  hidewaitingtimer2() {
    waitingtimer2 = false;
    notifyListeners();
  }

  bool waitingtimer = false;

  showwaitingtimer() {
    waitingtimer = true;
  }

  hidewaitingtimer() {
    waitingtimer = false;
    notifyListeners();
  }

  void showSpinner44() {
    showloading44 = true;
    notifyListeners();
  }

  void hideSpinner44() {
    showloading44 = false;
    notifyListeners();
  }

  GetRoomSupervisor() async {
    ShowGlopalLoading();

    await Roomapi()
        .GetRoomSupercisors(
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        Currentroom?.supervisor = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  void hideSpinner38() {
    showloading38 = false;
    notifyListeners();
  }

  void showSpinner38() {
    showloading38 = true;
    notifyListeners();
  }

  ClearCurrentroom() {
    Currentroom = null;
    notifyListeners();
  }

  AddsupervisorsRoom({
    context,
    userid,
  }) async {
    await Roomapi()
        .Addsupervisors(
      context: context,
      Roomid: Currentroom?.id,
      userid: userid,
    )
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        hideSpinner31();
      },
    );

    notifyListeners();
  }

  FollowRoom({
    context,
  }) async {
    await Roomapi()
        .FollowRoom(
      context: context,
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          Currentroom?.FollowRoom = 1;
          notifyListeners();
        } else {
          Currentroom?.FollowRoom = 0;
          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  RemoveFollowRoom({
    context,
  }) async {
    await Roomapi()
        .RemoveFollowRoom(
      context: context,
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          Currentroom?.FollowRoom = 0;
          notifyListeners();
        } else {
          Currentroom?.FollowRoom = 1;
          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  InviteToRoom({
    user,
    Roominfo,
    context,
  }) {
    RoomPlayViewModel playroom =
        Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    );

    RoomViewmodel Room =
        Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    SvgViewmodel svga =
        Provider.of<SvgViewmodel>(
      context,
      listen: false,
    );

    if (Roominfo['id'].toString() ==
            Currentroom?.id.toString() &&
        playroom.HasRoom) {
      Dialogs().showdialog5(
        context: context,
        content:
            '${user['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "INVITE_SET")}',
      );
    } else {
      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "inviteyou")} ${Roominfo['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "Room_now")}  ',
        onTap: () {
          Navigator.pop(context);

          if (playroom.HasRoom) {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            Room.JoinRoom2(
              Roomid: Roominfo['id'],
              context: context,
            );
          } else {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            Room.JoinRoom5(
              Roomid: Roominfo['id'],
              context: context,
            );
          }
        },
        tittle: '',
        buttontext: getLang(
          context: context,
          key: "Yes",
        ),
      );
    }

    notifyListeners();
  }

  InviteToChair({
    user,
    Roominfo,
    Chair_id,
    context,
  }) {
    RoomPlayViewModel playroom =
        Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    );

    RoomViewmodel Room =
        Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    SvgViewmodel svga =
        Provider.of<SvgViewmodel>(
      context,
      listen: false,
    );

    if (Roominfo['id'].toString() ==
            Currentroom?.id.toString() &&
        playroom.HasRoom) {
      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "INVITE_SET")}',
        onTap: () {
          Navigator.pop(context);

          if (JoinChairs) {
            Dialogs().showtoast(
              getLang(
                context:
                    NavigationService
                        .navigatorKey
                        .currentContext,
                key: "AlreadySet",
              ),
            );
          } else {
            if (Currentroom
                    ?.chairs?[
                        int.parse(Chair_id) - 1]
                    .user ==
                null) {
              if (playroom.IsRoom) {
                Room.JoinChair(
                  index: int.parse(Chair_id) - 1,
                  context: context,
                  chairid: Chair_id,
                );
              } else {
                svga.animationController?.clear();

                Provider.of<RoomViewmodel>(
                  context,
                  listen: false,
                ).initscrollcontroller();

                Provider.of<GiftsViewModel>(
                  context,
                  listen: false,
                ).DeleteGlopal();

                Navigator.pushNamed(
                  context,
                  AppConstants.Room_Screan,
                );

                Future.delayed(
                  Duration(seconds: 1),
                  () => Room.JoinChair(
                    index:
                        int.parse(Chair_id) - 1,
                    context: context,
                    chairid: Chair_id,
                  ),
                );
              }
            } else {
              Dialogs().showtoast(
                getLang(
                  context:
                      NavigationService
                          .navigatorKey
                          .currentContext,
                  key: "Another_Set",
                ),
              );
            }
          }
        },
        tittle: '',
        buttontext: getLang(
          context: context,
          key: "Yes",
        ),
      );
    } else {
      Dialogs().showdialog(
        context: context,
        content:
            '${user['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "inviteyou")} ${Roominfo['name']} ${getLang(context: NavigationService.navigatorKey.currentContext, key: "Room_now")} ',
        onTap: () {
          Navigator.pop(context);

          if (playroom.HasRoom) {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            Room.JoinRoom2(
              Roomid: Roominfo['id'],
              context: context,
            );
          } else {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).hidpanner2();

            svga.dispose();

            Room.JoinRoom5(
              Roomid: Roominfo['id'],
              context: context,
            );
          }
        },
        tittle: '',
        buttontext: getLang(
          context: context,
          key: "Yes",
        ),
      );
    }

    notifyListeners();
  }

  GetRoomGifts() async {
    showSpinner37();

    await Roomapi()
        .GetRoomGifts(
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        RoomGifts = value;
        hideSpinner37();
      },
    );

    notifyListeners();
  }

  void showSpinner37() {
    showloading37 = true;
    notifyListeners();
  }

  void hideSpinner37() {
    showloading37 = false;
    notifyListeners();
  }

  RemovesupervisorsRoom({
    context,
    userid,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .Removesupervisors(
      context: context,
      Roomid: Currentroom?.id,
      userid: userid,
    )
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          Currentroom?.supervisor?.removeWhere(
            (element) => element.user?.id == userid,
          );

          notifyListeners();
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  Addsupervisors({id}) {
    Currentroom?.supervisorsId?.add(id);
    notifyListeners();
  }

  Removesupervisors({id}) {
    Currentroom?.supervisorsId
        ?.removeWhere(
          (element) => element == id,
        );

    notifyListeners();
  }

  cleanMessage() {
    showloading7 = false;
    Message.clear();
    notifyListeners();
  }

  void hideSpinner33() {
    showloading33 = false;
    notifyListeners();
  }

  void showSpinner33() {
    showloading33 = true;
    notifyListeners();
  }

  void hideSpinner34() {
    showloading34 = false;
    notifyListeners();
  }

  void showSpinner34() {
    showloading34 = true;
    notifyListeners();
  }

  void hideSpinner35() {
    showloading35 = false;
    notifyListeners();
  }

  void showSpinner35() {
    showloading35 = true;
    notifyListeners();
  }

  void showSpinner41() {
    showloading41 = true;
    notifyListeners();
  }

  void showSpinner42() {
    showloading42 = true;
    notifyListeners();
  }

  void hideSpinner32() {
    showloading32 = false;
    notifyListeners();
  }

  void showSpinner32() {
    showloading32 = true;
    notifyListeners();
  }

  void hideSpinner31() {
    showloading31 = false;
    notifyListeners();
  }

  void showSpinner31() {
    showloading31 = true;
    notifyListeners();
  }

  void hideSpinner46() {
    showloading46 = false;
    notifyListeners();
  }

  void showSpinner46() {
    showloading46 = true;
    notifyListeners();
  }

  void hideSpinner47() {
    showloading47 = false;
    notifyListeners();
  }

  void showSpinner47() {
    showloading47 = true;
    notifyListeners();
  }

  void hideSpinner28() {
    showloading28 = false;
    notifyListeners();
  }

  void showSpinner28() {
    showloading28 = true;
    notifyListeners();
  }

  void hideSpinner29() {
    showloading29 = false;
    notifyListeners();
  }

  void showSpinner29() {
    showloading29 = true;
    notifyListeners();
  }

  void showSpinner30() {
    showloading30 = true;
    notifyListeners();
  }

  void hideSpinner30() {
    showloading30 = false;
    notifyListeners();
  }

  FlagChose({flag}) {
    flagchoosen = flag;
    notifyListeners();
  }

  FlagChose2({flag}) {
    flagchoosen2.clear();
    flagchoosen2.add(flag);
    notifyListeners();
  }

  GetShowItem(item) {
    ShowItem = item;
    notifyListeners();
  }

  deleteroomchat() {
    Currentroom?.chatroom?.clear();
    notifyListeners();
  }

  removecurrentroom() {
    Currentroom?.id = 0654;
    notifyListeners();
  }

  addnewchoosen2(value) {
    choosen2.add(value);
    notifyListeners();
  }

  addflagchoosen2(value) {
    flagchoosen2.add(value);
    notifyListeners();
  }

  addbackchhosen2({value}) {
    backchoosen2.add(value);
    notifyListeners();
  }

  AddtoEdit() {
    backchoosen2.add(
      Currentroom?.nothostedimage,
    );

    flagchoosen2.add(
      Currentroom?.city,
    );

    choosen2.add(
      Currentroom?.Category,
    );

    EditRoomName.text =
        Currentroom?.name ?? '';

    EditRoomDescription.text =
        Currentroom?.RoomAds ?? '';

    notifyListeners();
  }

  clearadd2() {
    backchoosen2.clear();
    EditRoomName.clear();
    flagchoosen2.clear();
    ClearImage2();
    ClearImage3();
    choosen2.clear();
    notifyListeners();
  }

  DisposeController() {
    controller?.dispose();
    notifyListeners();
  }

  ScrollController? controller =
      ScrollController();

  // ============================================================
  // ROOM CREATE IMAGES
  // ============================================================

  var Roomimage;
  var Roomimage2;

  // Kept because existing edit-room code still references it.
  var Roomimage3;

  // New Create Room background.
  // This is a local File selected by the user and uploaded
  // directly through CreateRoom.
  File? RoomBackgroundImage;

  bool Giftstate = false;

  List Mutedids = [];

  closealltap() {
    showloading14 = false;
    showloading17 = false;
    showloading18 = false;
    showloading19 = false;
    showloading8 = false;
    showloading21 = false;
    showloading39 = false;
    showloading40 = false;
    notifyListeners();
  }

  AddUserIds({id}) {
    GiftsViewModel gits =
        Provider.of<GiftsViewModel>(
      roomcontext,
      listen: false,
    );

    UserIds.add(id);

    if (gits.GiftList.isNotEmpty) {
      gits.addtogiftlist(
        value: gits.GiftList.first,
        costs:
            (int.parse(
                  gits.SentValue.toString(),
                ) *
                gits.GiftList.first['price'])
            .toInt() *
            UserIds.length,
      );
    }

    notifyListeners();
  }

  RemoveUserIds({id}) {
    UserIds.remove(id);

    GiftsViewModel gits =
        Provider.of<GiftsViewModel>(
      roomcontext,
      listen: false,
    );

    if (gits.GiftList.isNotEmpty) {
      gits.addtogiftlist(
        value: gits.GiftList.first,
        costs:
            (int.parse(
                  gits.SentValue.toString(),
                ) *
                gits.GiftList.first['price'])
            .toInt() *
            UserIds.length,
      );
    }

    notifyListeners();
  }

  ClearUserIds() {
    UserIds.clear();
    notifyListeners();
  }

  ChangeChairLock({
    int? State,
    String? chairId,
  }) {
    Currentroom?.chairs?[
            int.parse(
                  chairId ?? '0',
                ) -
                1]
        .Lock = State;

    notifyListeners();
  }

  NulledKaresmaChair({
    String? chairId,
  }) {
    Currentroom?.chairs?[
            int.parse(
                  chairId ?? '0',
                ) -
                1]
        .Karisma = 0;

    notifyListeners();
  }

  addKaresmaChair({
    String? chairId,
  }) {
    Currentroom?.chairs?[
            int.parse(
                  chairId ?? '0',
                ) -
                1]
        .Karisma = 100;

    notifyListeners();
  }

  updatekaresma({
    required int Amount,
    context,
  }) {
    Currentroom?.Karisma =
        (Currentroom?.Karisma ?? 0) +
            Amount;

    Provider.of<SvgViewmodel>(
      context,
      listen: false,
    ).getcontroller4(
      Svga:
          'assets/image/16207300489766.svga',
    );

    print(Amount);
    notifyListeners();
  }

  AddKaresmaChair({
    required List userids,
    int? Amount,
  }) {
    userids.forEach(
      (elements) {
        Currentroom?.chairs?.forEach(
          (element) {
            if (element.userId.toString() ==
                elements.toString()) {
              element.Karisma =
                  (element.Karisma ?? 0) +
                      Amount!;
            }
          },
        );

        print(
          Currentroom?.chairs?.where(
            (element) =>
                element.userId.toString() ==
                element.toString(),
          ),
        );

        notifyListeners();
      },
    );
  }

  Changemicestateadmin({
    userId,
    state,
    context,
  }) async {
    Currentroom?.chairs?.forEach(
      (element) async {
        if (element.userId == userId) {
          element.mute = state;
        }
      },
    );

    notifyListeners();
  }

  bool checkmute() {
    var muted = false;

    Currentroom?.chairs?.forEach(
      (element) {
        if (element.userId == UserId &&
            element.mute == 0) {
          muted = false;
        } else if (element.userId == UserId &&
            element.mute == 1) {
          muted = true;
        }
      },
    );

    notifyListeners();

    return muted;
  }

  updateRoom() async {
    ShowGlopalLoading();

    await Roomapi()
        .UpdateRoom(
      RoomAds: EditRoomDescription.text,
      image: Roomimage2,
      name: EditRoomName.text,
      backimage: backchoosen2.first,
      Category: choosen2.first,
      roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value != null) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          clearadd2();
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  updateThroneChair({
    State,
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .UpdateThroneChair(
      context: context,
      room_id: Currentroom?.id,
      State: State,
    )
        .then(
      (value) {
        if (value != null) {
          Dialogs().showtoast(
            'updated',
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  unkickuserRoom({
    context,
    kickid,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .UnkickeuserRoom(
      context: context,
      kickid: kickid,
    )
        .then(
      (value) {
        if (value != false) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          BlockeduserRooms.removeWhere(
            (element) => element.id == kickid,
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  SentInviteChairRoom({
    context,
    user_id,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .SendInviteChairRoom(
      context: context,
      roomid: Currentroom?.id,
      userid: user_id,
    )
        .then(
      (value) {
        if (value != false) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  deletechat({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .deleteChatRoom(
      context: context,
      RoomID: Currentroom?.id,
    )
        .then(
      (value) {
        if (value != false) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  SetRoomPassword({
    context,
    PasswordRoom,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .SetRoomPssword(
      context: context,
      roomid: Currentroom?.id,
      password: PasswordRoom.text,
    )
        .then(
      (value) {
        if (value != null) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          PasswordRoom.clear();
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );

          PasswordRoom.clear();
        }

        Navigator.pop(context);
        notifyListeners();
      },
    );
  }

  RemoveRoomPassword({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .RemoveRoomPssword(
      context: context,
      roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value != null) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  updatemute({
    context,
    state,
    user_id,
  }) async {
    await Roomapi()
        .Updatemute(
      context: context,
      room_id: Currentroom?.id,
      state: state,
      user_id: user_id,
    )
        .then(
      (value) {
        if (value == true) {
          if (state == 1) {
            Provider.of<AgoraViewmodel>(
              roomcontext,
              listen: false,
            ).muteusermic(
              int.parse(
                user_id.toString(),
              ),
            );
          } else {
            Provider.of<AgoraViewmodel>(
              roomcontext,
              listen: false,
            ).unmuteusermic(
              int.parse(
                user_id.toString(),
              ),
            );
          }
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        notifyListeners();
      },
    );
  }

  GetUserJoin({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .Roomsjoinuser(
      context: context,
      room_id: Currentroom?.id,
    )
        .then(
      (value) {
        if (value.isNotEmpty) {
          joinuserRooms = value;
          notifyListeners();
        }

        DismissGlopalLoading();
        notifyListeners();
      },
    );
  }

  updateCurrentRoom({
    required RoomModel NewRoom,
  }) {
    Currentroom?.name = NewRoom.name;
    Currentroom?.animateimage =
        NewRoom.animateimage;
    Currentroom?.locked = NewRoom.locked;
    Currentroom?.password = NewRoom.password;
    Currentroom?.image = NewRoom.image;
    Currentroom?.Category = NewRoom.Category;
    Currentroom?.nothostedimage =
        NewRoom.nothostedimage;
    Currentroom?.RoomAds = NewRoom.RoomAds;

    Rooms.forEach(
      (element) {
        if (element.id == NewRoom.id) {
          element.name = NewRoom.name;
          element.image = NewRoom.image;
          element.password = NewRoom.password;
          element.RoomAds = NewRoom.RoomAds;
          element.Category = NewRoom.Category;
        }
      },
    );

    notifyListeners();
  }

  updateCurrentRoomPassword({
    required var Password,
    required String Id,
  }) {
    Currentroom?.password = Password;

    Rooms.forEach(
      (element) {
        if (element.id.toString() ==
            Id.toString()) {
          element.password = Password;
          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  AddMuted(id) {
    Mutedids.add(id);
    notifyListeners();
  }

  final ImagePicker _picker =
      ImagePicker();

  Evictionuser({
    Userid,
    context,
  }) async {
    await Roomapi()
        .Evictionuser(
      context: context,
      Roomid: Currentroom?.id,
      Userid: Userid,
    )
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        notifyListeners();
      },
    );

    notifyListeners();
  }

  RemoveRoomFromlist({
    RoomId,
  }) {
    Rooms.removeWhere(
      (element) => element.id == RoomId,
    );

    NewRooms.removeWhere(
      (element) => element.id == RoomId,
    );

    notifyListeners();
  }

  DisbandRoom({
    context,
  }) async {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    await Roomapi()
        .DisbandRoom(
      context: context,
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );

          Agora.EndAgora();

          Rooms.removeWhere(
            (element) =>
                element.id ==
                Currentroom?.id,
          );

          NewRooms.removeWhere(
            (element) =>
                element.id ==
                Currentroom?.id,
          );

          user.userinfo?.currentroom =
              null;
        }

        notifyListeners();
      },
    );

    notifyListeners();
  }

  checkadmin({
    context,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    if (Currentroom?.adminId.toString() ==
        user.userinfo?.id.toString()) {
      return true;
    } else {
      return false;
    }
  }

  // ============================================================
  // CREATE ROOM RESET
  // ============================================================

  void clearadd() {
    RoomName.clear();
    RoomAds.clear();

    Roomimage = null;
    RoomBackgroundImage = null;

    choosen.clear();

    notifyListeners();
  }

  // ============================================================
  // ROOM IMAGE
  // ============================================================

  Future<void> getImage() async {
  final XFile? pickedFile =
      await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
    maxWidth: 1600,
    maxHeight: 1600,
  );

  if (pickedFile != null) {
    Roomimage = File(
      pickedFile.path,
    );

    print(
      'ROOM IMAGE: ${Roomimage.path}',
    );

    print(
      'ROOM IMAGE SIZE: '
      '${await Roomimage.length()} bytes',
    );
  }

  notifyListeners();
}

  Future getImage2() async {
    final pickedFile =
        await _picker2.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      Roomimage2 = File(
        pickedFile.path,
      );
    }

    notifyListeners();
  }

  // ============================================================
  // NEW ROOM BACKGROUND
  // ============================================================

  Future<void> getImage3() async {
  final XFile? pickedFile =
      await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
    maxWidth: 1600,
    maxHeight: 1600,
  );

  if (pickedFile != null) {
    RoomBackgroundImage =
        File(pickedFile.path);

    print(
      'ROOM BACKGROUND IMAGE: '
      '${RoomBackgroundImage!.path}',
    );

    print(
      'ROOM BACKGROUND IMAGE SIZE: '
      '${await RoomBackgroundImage!.length()} bytes',
    );
  }

  notifyListeners();
}

  ClearImage() {
    Roomimage = null;
    notifyListeners();
  }

  ClearImage2() {
    Roomimage2 = null;
    notifyListeners();
  }

  ClearImage3() {
    Roomimage3 = null;
    notifyListeners();
  }

  hidegiffalse() {
    showgif = false;
    notifyListeners();
  }

  initscrollcontroller() {}

  GetNewRoom({
    context,
  }) async {
    if (NewRooms.isEmpty) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .NewRooms(context)
        .then(
      (value) {
        NewRooms = value;
        print(NewRooms.length);
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetRoomLeaderboard({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .getRoomLeaderboard(context)
        .then(
      (value) {
        LeaderboardRoom = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  bool GetGiverLeadestatr = false;
  bool isCallGiver = false;
  bool GetWeeklyStars = false;

  GetGiverLeaderboard({
    context,
  }) async {
    GetGiverLeadestatr = true;

    if (!isCallGiver) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .getGiverLeaderboard(context)
        .then(
      (value) {
        isCallGiver = true;
        LeaderboardSupporter = value;
        GetGiverLeadestatr = false;

        print(
          LeaderboardSupporter
              ?.monthlysupporter
              ?.length,
        );

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetWeeklyStar({
    context,
  }) async {
    if (WeeklyStar == null) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .GetWeeklystar(context)
        .then(
      (value) {
        WeeklyStar = value;

        print(
          'WeeklyStar?.supporteds?.length'
          'WeeklyStar?.supporteds?.length',
        );

        print(
          WeeklyStar?.supporteds?.length,
        );

        print(
          WeeklyStar?.supporters?.length,
        );

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetFamilyLeaderboard({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .getFamilyLeaderboard(context)
        .then(
      (value) {
        LeaderboardFamily = value;

        print(
          LeaderboardFamily
              ?.weeklysupporter
              ?.length,
        );

        print(
          LeaderboardFamily
              ?.dailysupporter
              ?.length,
        );

        print(
          LeaderboardFamily
              ?.monthlysupporter
              ?.length,
        );

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  bool GetReciverLeadestatr = false;
  bool isCallReciver = false;

  GetReciverLeaderboard({
    context,
  }) async {
    print(
      'GetReciverLeaderboard',
    );

    if (!isCallReciver) {
      ShowGlopalLoading();
    }

    GetReciverLeadestatr = true;

    await Roomapi()
        .getReciverLeaderboard(context)
        .then(
      (value) {
        Leaderboardsupported = value;
        GetReciverLeadestatr = false;
        isCallReciver = true;

        print(
          Leaderboardsupported
              ?.monthlysupporter
              ?.length,
        );

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetMoreNewRoom(context) async {
    showSpinner2();

    await Roomapi()
        .GetMoreTrendRoom(context)
        .then(
      (value) {
        value.forEach(
          (element) {
            NewRooms.add(element);
          },
        );

        print(NewRooms.length);
        hideSpinner2();
      },
    );

    notifyListeners();
  }

  GetRoom({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .Rooms(context)
        .then(
      (value) {
        Rooms = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetFixedRoom({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .getFixedRooms(context)
        .then(
      (value) {
        FixedRooms = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  SearchGetRoom({
    context,
    text,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .SearchRooms(
      context,
      text,
    )
        .then(
      (value) {
        SearchRooms = value;

        navigateTo(
          context: context,
          screen: SearchRoom(),
        );

        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetFollowedRoom({
    context,
  }) async {
    hideSpinner46();

    await Roomapi()
        .GetFollowedRooms(context)
        .then(
      (value) {
        FollowedRooms = value;
        showSpinner46();
      },
    );

    notifyListeners();
  }

  GetMoreRoom(context) async {
    showSpinner2();

    await Roomapi()
        .AddmoreRooms(context)
        .then(
      (value) {
        value.forEach(
          (element) {
            Rooms.add(element);
          },
        );

        print(Rooms.length);
        hideSpinner2();
      },
    );

    notifyListeners();
  }

  GetFollowingUserRoom(context) async {
    if (FollowingUserRooms.isEmpty) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .FoolowingUserRooms(context)
        .then(
      (value) {
        ShowGlopalLoading();

        FollowingUserRooms = value;

        print(
          FollowingUserRooms.length,
        );

        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  GetRecommendedRoom(context) async {
    await Roomapi()
        .RecommendedRooms(context)
        .then(
      (value) {
        RecomendedRoom = value;

        print(
          FollowingUserRooms.length,
        );

        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetExploreRoom(context) async {
    if (ExploreRooms.isEmpty) {
      ShowGlopalLoading();
    }

    await Roomapi()
        .ExploreRooms(context)
        .then(
      (value) {
        ExploreRooms = value;

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetCountriRoom() async {
    ShowGlopalLoading();

    await Roomapi()
        .CountryRooms(
      Country: SelectedCountry?.name,
    )
        .then(
      (value) {
        CountryRoom = value;

        DismissGlopalLoading();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetCountries(context) async {
    await Roomapi()
        .GetCountries(context)
        .then(
      (value) {
        Countries = value;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  GetMoreExploreRoom(context) async {
    showloading2 = true;

    await Roomapi()
        .AddExploreRecommended(context)
        .then(
      (value) {
        value.forEach(
          (element) {
            ExploreRooms.add(element);
          },
        );

        hideSpinner2();
      },
    );

    notifyListeners();
  }

  GetMoreRecommended(context) async {
    await Roomapi()
        .AddmoreRecommended(context)
        .then(
      (value) {
        value.forEach(
          (element) {
            RecomendedRoom.add(element);
          },
        );

        hideSpinner2();
      },
    );

    notifyListeners();
  }

  Future<bool> TrackRoomPassword(id) async {
    ShowGlopalLoading();

    return await Roomapi()
        .CheckPassworRooms(
      id: id.toString(),
    );
  }

  Future<bool> EnterTrackRoomPassword({
    id,
    pass,
  }) async {
    ShowGlopalLoading();

    return await Roomapi()
        .EnterCheckPassworRooms(
      id: id.toString(),
      pass: pass,
    );
  }

  GetKickeduser({
    context,
  }) async {
    ShowGlopalLoading();

    await Roomapi()
        .KickedUserRooms(
      context: context,
      roomid: Currentroom?.id,
    )
        .then(
      (value) {
        BlockeduserRooms = value;
        DismissGlopalLoading();
      },
    );

    notifyListeners();
  }

  // ============================================================
  // CREATE ROOM
  // ============================================================

  Future<bool> CreateRoom({
  required context,
  required name,
  required Category,
  required city,
  required File backgroundimage,
}) async {
  final LoginViewmodel user = Provider.of<LoginViewmodel>(
    context,
    listen: false,
  );

  try {
    if (Roomimage == null) {
      print('CREATE ROOM: Roomimage is null');
      return false;
    }

    if (!Roomimage.existsSync()) {
      print(
        'CREATE ROOM: Room image file does not exist: '
        '${Roomimage.path}',
      );
      return false;
    }

    if (!backgroundimage.existsSync()) {
      print(
        'CREATE ROOM: Background image file does not exist: '
        '${backgroundimage.path}',
      );
      return false;
    }

    print(
      'CREATE ROOM IMAGE EXISTS: '
      '${Roomimage.existsSync()}',
    );

    print(
      'CREATE ROOM IMAGE SIZE: '
      '${await Roomimage.length()} bytes',
    );

    print(
      'CREATE ROOM BACKGROUND EXISTS: '
      '${backgroundimage.existsSync()}',
    );

    print(
      'CREATE ROOM BACKGROUND SIZE: '
      '${await backgroundimage.length()} bytes',
    );

    print(
      'CREATE ROOM: '
      'name=$name, '
      'category=$Category, '
      'city=$city',
    );

    print(
      'CREATE ROOM PHOTO: '
      '${Roomimage.path}',
    );

    print(
      'CREATE ROOM BACKGROUND: '
      '${backgroundimage.path}',
    );

    ShowGlopalLoading();
    showSpinner6();

    Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).disableAudioroomvoice();

    final RoomModel value = await Roomapi().CreateRoom(
      RoomAds: RoomAds.text.trim(),
      context: context,
      name: name,
      Category: Category,
      image: Roomimage,
      backgroundimage: backgroundimage,
      city: city,
    );

    print(
      'CREATE ROOM RESULT: '
      'id=${value.id}',
    );

    if (value.id == null) {
      print(
        'CREATE ROOM FAILED: backend returned no room id',
      );
      return false;
    }

    clearadd();

    Currentroom = value;

    user.userinfo?.currentroom = value;

    Rooms.insert(
      0,
      value,
    );

    initscrollcontroller();

    Currentroom?.userNumber =
        (Currentroom?.userNumber ?? 0) + 1;

    JoinChairs = true;

    Provider.of<SocketViewmodel>(
      context,
      listen: false,
    ).ConnectRoomScocket(
      context,
      value.id,
    );

    Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    ).changeHasRoomstate(true);

    final String agoraChannel =
        value.id?.toString().trim() ?? '';

    final String agoraToken =
        value.Token?.toString().trim() ?? '';

    print('========== CREATE ROOM AGORA ==========');
    print('DB ROOM ID: ${value.id}');
    print('AGORA ROOM ID / CHANNEL: "$agoraChannel"');
    print('AGORA TOKEN PRESENT: ${agoraToken.isNotEmpty}');
    print('AGORA TOKEN LENGTH: ${agoraToken.length}');
    print('========================================');

    if (agoraChannel.isEmpty) {
      print(
        'CREATE ROOM AGORA ERROR: RoomID is empty',
      );
      return false;
    }

    if (agoraToken.isEmpty) {
      print(
        'CREATE ROOM AGORA ERROR: Token is empty',
      );
      return false;
    }

    await Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).initialize(
      role: ClientRole.Broadcaster,
      Token: agoraToken,
      channelName: agoraChannel,
    );

    Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    ).changeIsRoomstate(true);

    Provider.of<GiftsViewModel>(
      context,
      listen: false,
    ).DeleteGlopal();

    final int? userId = int.tryParse(
      user.userinfo?.id.toString() ?? '',
    );

    if (userId != null) {
      Provider.of<AgoraViewmodel>(
        roomcontext,
        listen: false,
      ).unmuteusermic(userId);
    } else {
      print(
        'CREATE ROOM: Unable to parse current user id',
      );
    }

    return true;
  } catch (e, stackTrace) {
    print(
      'CREATE ROOM ERROR: $e',
    );

    print(
      'CREATE ROOM STACK: $stackTrace',
    );

    return false;
  } finally {
    hideSpinner6();
    DismissGlopalLoading();
  }
}

JoinRoom4({
  context,
  Roomid,
}) async {
  Provider.of<SocketViewmodel>(
    context,
    listen: false,
  ).DisConnect(
    id: Currentroom?.id,
  );

  Currentroom?.id = 0;
  Currentroom = null;

  final AgoraViewmodel agora =
      Provider.of<AgoraViewmodel>(
    context,
    listen: false,
  );

  final LoginViewmodel user =
      Provider.of<LoginViewmodel>(
    context,
    listen: false,
  );

  await agora.EndAgora();

  await Roomapi()
      .joinRooms(
    context: context,
    Roomid: Roomid,
  )
      .then(
    (value) async {
      DismissGlopalLoading();

      if (value.state == 1) {
        Rooms.removeWhere(
          (element) => element.id == Roomid,
        );

        NewRooms.removeWhere(
          (element) => element.id == Roomid,
        );

        Dialogs().showtoast(
          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Room_Disbanded",
          ),
        );

        return;
      }

      if (value.id == null) {
        print(
          'JOIN ROOM 4 ERROR: value.id is null',
        );
        return;
      }

      JoinChairs = false;

      final String agoraChannel =
          value.id?.toString().trim() ?? '';

      final String agoraToken =
          value.Token?.toString().trim() ?? '';

      final bool isAdmin =
          value.admin?.id.toString() ==
              UserId.toString();

      print(
        '========== JOIN ROOM 4 AGORA ==========',
      );
      print(
        'DB ROOM ID: ${value.id}',
      );
      print(
        'PUBLIC ROOM ID / AGORA CHANNEL: "$agoraChannel"',
      );
      print(
        'TOKEN PRESENT: ${agoraToken.isNotEmpty}',
      );
      print(
        'TOKEN LENGTH: ${agoraToken.length}',
      );
      print(
        'USER ID: $UserId',
      );
      print(
        'IS ADMIN: $isAdmin',
      );
      print(
        '========================================',
      );

      if (agoraChannel.isEmpty) {
        print(
          'JOIN ROOM 4 AGORA ERROR: RoomID is empty',
        );
        return;
      }

      if (agoraToken.isEmpty) {
        print(
          'JOIN ROOM 4 AGORA ERROR: Token is empty',
        );
        return;
      }

      if (isAdmin) {
        JoinChairs = true;

        print(
          'JOIN ROOM 4: User is ADMIN',
        );

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Broadcaster,
          Token: agoraToken,
          channelName: agoraChannel,
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      } else {
        print(
          'JOIN ROOM 4: User is NOT ADMIN',
        );

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Audience,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      }

      // Set the room BEFORE scheduling the delayed entry animation.
      Currentroom = value;

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).hidpanner();

      Provider.of<SvgViewmodel>(
        context,
        listen: false,
      ).animationController?.clear();

      Provider.of<RoomViewmodel>(
        context,
        listen: false,
      ).initscrollcontroller();

      Provider.of<SocketViewmodel>(
        context,
        listen: false,
      ).ConnectRoomScocket(
        context,
        Roomid,
      );

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeHasRoomstate(true);

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeIsRoomstate(true);

      if (Currentroom?.RoomAds != null) {
        Currentroom?.chatroom?.add(
          Chatroom(
            kind: 1,
            user: Currentroom?.admin,
            id: 0,
            content: Currentroom?.RoomAds,
            userId: Currentroom?.admin?.id.toString(),
            updatedAt: Currentroom?.updatedAt,
            roomId: Currentroom?.id.toString(),
            createdAt: Currentroom?.createdAt,
          ),
        );
      }

      if (checkadmin(context: context)) {
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      }

      Provider.of<AgoraViewmodel>(
        context,
        listen: false,
      ).KickedFromChair = false;

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).DeleteGlopal();

      HideEnterWidget();

      final int? userId = int.tryParse(
        user.userinfo?.id.toString() ?? '',
      );

      if (userId != null) {
        Provider.of<AgoraViewmodel>(
          roomcontext,
          listen: false,
        ).unmuteusermic(userId);
      }

      /*
       * IMPORTANT:
       * We do NOT call SvgViewmodel.dispose().
       *
       * SvgViewmodel is owned by Provider.
       * Its dispose() must only happen when Provider removes
       * the ViewModel from the widget tree.
       *
       * getcontroller() itself must safely handle its lifecycle.
       */
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) {
            return;
          }

          try {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              print(
                'JOIN ROOM 4 SVGA: No entry animation',
              );
              return;
            }

            Provider.of<SvgViewmodel>(
              context,
              listen: false,
            ).getcontroller(
              enterImage: user.userinfo?.image,
              entername: user.userinfo?.name,
              svga: entry,
            );
          } catch (e, stackTrace) {
            print(
              'JOIN ROOM 4 DELAYED SVGA ERROR: $e',
            );
            print(stackTrace);
          }
        },
      );

      Navigator.pushNamed(
        context,
        AppConstants.Room_Screan,
      );
    },
  );

  notifyListeners();
}

JoinRoom2({
  context,
  Roomid,
}) async {
  Provider.of<SocketViewmodel>(
    context,
    listen: false,
  ).DisConnect(
    id: Currentroom?.id,
  );

  final LoginViewmodel user =
      Provider.of<LoginViewmodel>(
    context,
    listen: false,
  );

  print(
    'JoinRoom2JoinRoom2JoinRoom2JoinRoom2JoinRoom2JoinRoom2',
  );

  final AgoraViewmodel agora =
      Provider.of<AgoraViewmodel>(
    context,
    listen: false,
  );

  await agora.EndAgora();

  showSpinner3();

  await Roomapi()
      .joinRooms(
    context: context,
    Roomid: Roomid,
  )
      .then(
    (value) async {
      print(value.state);
      print(value.name);

      print(
        'Room Data is ====================================>',
      );

      if (value.state == 1) {
        Rooms.removeWhere(
          (element) => element.id == Roomid,
        );

        NewRooms.removeWhere(
          (element) => element.id == Roomid,
        );

        hideSpinner3();

        Dialogs().showtoast(
          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Room_Disbanded",
          ),
        );

        return;
      }

      if (value.id == null) {
        print(
          'JOIN ROOM 2 ERROR: value.id is null',
        );
        hideSpinner3();
        return;
      }

      Provider.of<SocketViewmodel>(
        context,
        listen: false,
      ).DisConnect(
        id: Currentroom?.id,
      );

      JoinChairs = false;

      final String agoraChannel =
          value.id?.toString().trim() ?? '';

      final String agoraToken =
          value.Token?.toString().trim() ?? '';

      final bool isAdmin =
          value.admin?.id.toString() ==
              UserId.toString();

      print(
        '========== JOIN ROOM 2 AGORA ==========',
      );
      print(
        'DB ROOM ID: ${value.id}',
      );
      print(
        'PUBLIC ROOM ID / AGORA CHANNEL: "$agoraChannel"',
      );
      print(
        'TOKEN PRESENT: ${agoraToken.isNotEmpty}',
      );
      print(
        'TOKEN LENGTH: ${agoraToken.length}',
      );
      print(
        'USER ID: $UserId',
      );
      print(
        'IS ADMIN: $isAdmin',
      );
      print(
        '========================================',
      );

      if (agoraChannel.isEmpty) {
        print(
          'JOIN ROOM 2 AGORA ERROR: RoomID is empty',
        );
        hideSpinner3();
        return;
      }

      if (agoraToken.isEmpty) {
        print(
          'JOIN ROOM 2 AGORA ERROR: Token is empty',
        );
        hideSpinner3();
        return;
      }

      if (isAdmin) {
        JoinChairs = true;

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Broadcaster,
          Token: agoraToken,
          channelName: agoraChannel,
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      } else {
        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Audience,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      }

      Currentroom = value;

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).hidpanner();

      Provider.of<SvgViewmodel>(
        context,
        listen: false,
      ).animationController?.clear();

      Provider.of<RoomViewmodel>(
        context,
        listen: false,
      ).initscrollcontroller();

      Currentroom?.userNumber =
          (Currentroom?.userNumber ?? 0) + 1;

      Provider.of<SocketViewmodel>(
        context,
        listen: false,
      ).ConnectRoomScocket(
        context,
        Currentroom?.id,
      );

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeHasRoomstate(true);

      if (Currentroom?.RoomAds != null) {
        Currentroom?.chatroom?.add(
          Chatroom(
            user: Currentroom?.admin,
            id: 0,
            content: Currentroom?.RoomAds,
            userId: Currentroom?.admin?.id.toString(),
            updatedAt: Currentroom?.updatedAt,
            roomId: Currentroom?.id?.toString(),
            createdAt: Currentroom?.createdAt,
          ),
        );
      }

      Provider.of<AgoraViewmodel>(
        context,
        listen: false,
      ).KickedFromChair = false;

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeIsRoomstate(true);

      if (checkadmin(context: context)) {
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      }

      HideEnterWidget();

      /*
       * IMPORTANT:
       * No SvgViewmodel.dispose().
       *
       * The ViewModel is still owned by Provider.
       */
      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) {
            return;
          }

          try {
            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              print(
                'JOIN ROOM 2 SVGA: No entry animation',
              );
              return;
            }

            Provider.of<SvgViewmodel>(
              context,
              listen: false,
            ).getcontroller(
              enterImage: user.userinfo?.image,
              entername: user.userinfo?.name,
              svga: entry,
            );
          } catch (e, stackTrace) {
            print(
              'JOIN ROOM 2 DELAYED SVGA ERROR: $e',
            );
            print(stackTrace);
          }
        },
      );

      hideSpinner3();
    },
  );

  notifyListeners();
}


JoinRoom5({
  context,
  Roomid,
}) async {
  Provider.of<SocketViewmodel>(
    context,
    listen: false,
  ).DisConnect(
    id: Currentroom?.id,
  );

  Currentroom?.id = 0;
  Currentroom = null;

  print(
    'Test ============================> 1',
  );

  final AgoraViewmodel agora =
      Provider.of<AgoraViewmodel>(
    context,
    listen: false,
  );

  await agora.EndAgora();

  final LoginViewmodel user =
      Provider.of<LoginViewmodel>(
    context,
    listen: false,
  );

  showSpinner3();

  print(
    'Test ============================> 3',
  );

  await Roomapi()
      .joinRooms(
    context: context,
    Roomid: Roomid,
  )
      .then(
    (value) async {
      if (value.state == 1) {
        print(
          'Test ============================> 4',
        );

        Rooms.removeWhere(
          (element) => element.id == Roomid,
        );

        NewRooms.removeWhere(
          (element) => element.id == Roomid,
        );

        hideSpinner3();

        Dialogs().showtoast(
          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Room_Disbanded",
          ),
        );

        return;
      }

      if (value.id == null) {
        print(
          'JOIN ROOM 5 ERROR: value.id is null',
        );
        hideSpinner3();
        return;
      }

      JoinChairs = false;

      print(
        'Test ============================> 6',
      );

      final String agoraChannel =
          value.id?.toString().trim() ?? '';

      final String agoraToken =
          value.Token?.toString().trim() ?? '';

      final bool isAdmin =
          value.admin?.id.toString() ==
              UserId.toString();

      print(
        '========== JOIN ROOM 5 AGORA ==========',
      );
      print(
        'DB ROOM ID: ${value.id}',
      );
      print(
        'PUBLIC ROOM ID / AGORA CHANNEL: "$agoraChannel"',
      );
      print(
        'TOKEN PRESENT: ${agoraToken.isNotEmpty}',
      );
      print(
        'TOKEN LENGTH: ${agoraToken.length}',
      );
      print(
        'USER ID: $UserId',
      );
      print(
        'IS ADMIN: $isAdmin',
      );
      print(
        '========================================',
      );

      if (agoraChannel.isEmpty) {
        print(
          'JOIN ROOM 5 AGORA ERROR: RoomID is empty',
        );
        hideSpinner3();
        return;
      }

      if (agoraToken.isEmpty) {
        print(
          'JOIN ROOM 5 AGORA ERROR: Token is empty',
        );
        hideSpinner3();
        return;
      }

      if (isAdmin) {
        JoinChairs = true;

        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Broadcaster,
          Token: agoraToken,
          channelName: agoraChannel,
        );

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      } else {
        await Provider.of<AgoraViewmodel>(
          context,
          listen: false,
        ).initialize(
          role: ClientRole.Audience,
          Token: agoraToken,
          channelName: agoraChannel,
        );
      }

      print(
        'Test ============================> 8',
      );

      Currentroom = value;

      print(
        'CURRENT ROOM DB ID: ${Currentroom?.id}',
      );

      print(
        'CURRENT ROOM PUBLIC ROOM ID: ${Currentroom?.RoomID}',
      );

      print(
        'Test ============================> 9',
      );

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).hidpanner();

      Provider.of<SvgViewmodel>(
        context,
        listen: false,
      ).animationController?.clear();

      Provider.of<RoomViewmodel>(
        context,
        listen: false,
      ).initscrollcontroller();

      print(
        'Number of users is '
        '${Currentroom?.userNumber}',
      );

      print(
        'Test ============================> 10',
      );

      Provider.of<SocketViewmodel>(
        context,
        listen: false,
      ).ConnectRoomScocket(
        context,
        Roomid,
      );

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeHasRoomstate(true);

      Provider.of<RoomPlayViewModel>(
        context,
        listen: false,
      ).changeIsRoomstate(true);

      if (Currentroom?.RoomAds != null) {
        print(
          'Test ============================> 11',
        );

        Currentroom?.chatroom?.add(
          Chatroom(
            kind: 1,
            user: Currentroom?.admin,
            id: 0,
            content: Currentroom?.RoomAds,
            userId: Currentroom?.admin?.id.toString(),
            updatedAt: Currentroom?.updatedAt,
            roomId: Currentroom?.id?.toString(),
            createdAt: Currentroom?.createdAt,
          ),
        );
      }

      if (checkadmin(context: context)) {
        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].mute = 0;

        Provider.of<RoomViewmodel>(
          roomcontext,
          listen: false,
        ).Currentroom?.chairs?[8].adminleaved = 0;
      }

      print(
        'Test ============================> 12',
      );

      Provider.of<AgoraViewmodel>(
        context,
        listen: false,
      ).KickedFromChair = false;

      Provider.of<GiftsViewModel>(
        context,
        listen: false,
      ).DeleteGlopal();

      HideEnterWidget();

      final int? userId = int.tryParse(
        user.userinfo?.id.toString() ?? '',
      );

      if (userId != null) {
        Provider.of<AgoraViewmodel>(
          roomcontext,
          listen: false,
        ).unmuteusermic(userId);
      }

      /*
       * IMPORTANT:
       * Do NOT call SvgViewmodel.dispose().
       * Provider owns the SvgViewmodel lifecycle.
       */

      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!context.mounted) {
            return;
          }

          try {
            print(
              'Test ============================> 13',
            );

            Provider.of<GiftsViewModel>(
              context,
              listen: false,
            ).sidepanner();

            final String entry =
                user.userinfo?.entry?.trim() ?? '';

            if (entry.isEmpty) {
              print(
                'JOIN ROOM 5 SVGA: No entry animation',
              );
              return;
            }

            Provider.of<SvgViewmodel>(
              context,
              listen: false,
            ).getcontroller(
              enterImage: user.userinfo?.image,
              entername: user.userinfo?.name,
              svga: entry,
            );
          } catch (e, stackTrace) {
            print(
              'JOIN ROOM 5 DELAYED SVGA ERROR: $e',
            );
            print(stackTrace);
          }
        },
      );

      Navigator.pushNamed(
        context,
        AppConstants.Room_Screan,
      );

      hideSpinner3();
    },
  );

  notifyListeners();
}


  bool JoinChairLoding = false;

  UpdateThronechair({
    int? value,
  }) {
    Currentroom?.SecondKing = value;
    notifyListeners();
  }

  showLoding() {
    JoinChairLoding = true;
  }

  hideLoding() {
    JoinChairLoding = false;
  }

  JoinChair({
    context,
    index,
    chairid,
  }) async {
    showLoding();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    Currentroom?.chairs?[index].userId =
        user.userinfo?.id.toString();

    JoinChairs = true;

    await Roomapi()
        .joinChair(
      context: context,
      index: index,
      room_id: Currentroom?.id,
      chair_id: chairid,
    )
        .then(
      (value) {
        hideLoding();

        print(
          'Join Chairsssssssssssssssssss',
        );

        if (value == true) {
          Agora.updateKickedFromChair(
            value: false,
          );

          Chairid = chairid;
          Chairidex = index;

          if (Currentroom
                  ?.chairs?[index]
                  .mute ==
              0) {
            Agora.UnMute();
          } else {
            Agora.Mute();
          }
        } else {
          Currentroom
              ?.chairs?[index]
              .userId = null;

          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Another_Set",
          );

          JoinChairs = false;
          notifyListeners();
        }
      },
    );

    notifyListeners();
  }

  ChangeChair({
    context,
    Index,
    Newchairid,
  }) async {
    showSpinner47();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    Currentroom
        ?.chairs?[Chairidex]
        .userId = null;

    Currentroom
        ?.chairs?[Chairidex]
        .user = null;

    Currentroom
        ?.chairs?[Index]
        .userId = user.userinfo?.id
            .toString();

    Currentroom
        ?.chairs?[Index]
        .user = user.userinfo;

    notifyListeners();

    await Roomapi()
        .ChangeChair(
      context: context,
      room_id: Currentroom?.id,
      CurrentChairid:
          Currentroom
              ?.chairs?[Chairidex]
              .id,
      NewCharid:
          Currentroom
              ?.chairs?[Index]
              .id,
    )
        .then(
      (value) {
        if (value == true) {
          if (Currentroom
                  ?.chairs?[Index]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Chairidex = Index;

          notifyListeners();
        } else {
          Currentroom
              ?.chairs?[Index]
              .userId = null;

          Currentroom
              ?.chairs?[Index]
              .user = null;

          Currentroom
              ?.chairs?[Chairidex]
              .userId =
              user.userinfo?.id.toString();

          Currentroom
              ?.chairs?[Chairidex]
              .user = user.userinfo;

          if (Currentroom
                  ?.chairs?[Chairidex]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Another_Set",
          );

          notifyListeners();
        }

        hideSpinner47();
      },
    );

    notifyListeners();
  }

  ChangeAdminsChair({
    context,
    Index,
    Newchairid,
  }) async {
    showSpinner47();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    Currentroom
        ?.chairs?[8]
        .adminleaved = 1;

    if (Chairidex != 0) {
      Currentroom
          ?.chairs?[Chairidex]
          .userId = null;

      Currentroom
          ?.chairs?[Chairidex]
          .user = null;
    }

    Currentroom
        ?.chairs?[Index]
        .userId = user.userinfo
        ?.id
        .toString();

    Currentroom
        ?.chairs?[Index]
        .user = user.userinfo;

    notifyListeners();

    await Roomapi()
        .AdminChangeChair(
      context: context,
      room_id: Currentroom?.id,
      CurrentChairid:
          Currentroom
              ?.chairs?[Chairidex]
              .id,
      NewCharid:
          Currentroom
              ?.chairs?[Index]
              .id,
    )
        .then(
      (value) {
        if (value == true) {
          if (Currentroom
                  ?.chairs?[Index]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Chairidex = Index;

          notifyListeners();
        } else {
          Currentroom
              ?.chairs?[8]
              .adminleaved = 0;

          if (Currentroom
                  ?.chairs?[8]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Currentroom
              ?.chairs?[Index]
              .userId = null;

          Currentroom
              ?.chairs?[Index]
              .user = null;

          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Another_Set",
          );

          notifyListeners();
        }

        hideSpinner47();
      },
    );

    notifyListeners();
  }

  ReturnAdminsChair({
    context,
    Index,
    Newchairid,
  }) async {
    showSpinner47();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    Currentroom
        ?.chairs?[8]
        .adminleaved = 0;

    if (Chairidex != 0) {
      Currentroom
          ?.chairs?[Chairidex]
          .userId = null;

      Currentroom
          ?.chairs?[Chairidex]
          .user = null;
    }

    Currentroom
        ?.chairs?[Index]
        .userId = user.userinfo
        ?.id
        .toString();

    Currentroom
        ?.chairs?[Index]
        .user = user.userinfo;

    notifyListeners();

    await Roomapi()
        .ReturnAdminChair(
      context: context,
      room_id: Currentroom?.id,
      CurrentChairid:
          Currentroom
              ?.chairs?[Chairidex]
              .id,
      NewCharid:
          Currentroom
              ?.chairs?[Index]
              .id,
    )
        .then(
      (value) {
        if (value == true) {
          if (Currentroom
                  ?.chairs?[Index]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Chairidex = Index;

          notifyListeners();
        } else {
          Currentroom
              ?.chairs?[8]
              .adminleaved = 1;

          if (Currentroom
                  ?.chairs?[8]
                  .mute ==
              1) {
            Agora.SetasAudience();
          } else {
            Agora.SetasBroadcaster();
          }

          Currentroom
              ?.chairs?[Index]
              .userId = null;

          Currentroom
              ?.chairs?[Index]
              .user = null;

          getLang(
            context:
                NavigationService
                    .navigatorKey
                    .currentContext,
            key: "Another_Set",
          );

          notifyListeners();
        }

        hideSpinner47();
      },
    );

    notifyListeners();
  }

  KickJoinadminuser({
    context,
    user_id,
  }) async {
    await Roomapi()
        .KickJoinadminuser(
      context: context,
      user_id: user_id,
      room_id: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }
      },
    );
  }

  InviteUserToSET({
    context,
    user_id,
  }) async {
    await Roomapi()
        .InviteUserToSET(
      context: context,
      user_id: user_id,
      room_id: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }
      },
    );
  }

  bool LeaveLoading = false;

  Leaveroom({
    context,
  }) async {
    LeaveLoading = true;

    Provider.of<SocketViewmodel>(
      context,
      listen: false,
    ).DisConnect(
      id: Currentroom?.id.toString(),
    );

    Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).disableAudioroomvoice();

    Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    ).stopAudioMexing(context);

    await Roomapi()
        .LeaveRoom(
      context: context,
      Roomid: Currentroom?.id,
    )
        .then(
      (value) {
        if (value == true) {
          List rrr = Rooms
              .where(
                (element) =>
                    element.id ==
                    Currentroom?.id,
              )
              .toList();

          if (rrr.isNotEmpty) {
            rrr.first.userNumber =
                (rrr.first.userNumber ?? 0) -
                    1;
          }

          Dialogs().showtoast(
            getLang(
              context: roomcontext,
              key: "Leaved_Room",
            ),
          );

          Currentroom = null;
          removecurrentroom();
          LeaveLoading = false;
        }
      },
    );

    notifyListeners();
  }

  LeaveChair({
    context,
    chairid,
    index,
  }) async {
    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    Currentroom
        ?.chairs?[index]
        .userId = null;

    Currentroom
        ?.chairs?[index]
        .user = null;

    await Roomapi()
        .LeaveChair(
      context: context,
      Roomid: Currentroom?.id,
      chairid: chairid,
    )
        .then(
      (value) {
        if (value == true) {
          Agora.SetasAudience();

          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        hideSpinner3();
      },
    );

    notifyListeners();
  }

  LeaveuserChair({
    context,
  }) async {
    showloading8 = false;

    Currentroom
        ?.chairs?[ChairIndes]
        .userId = null;

    Currentroom
        ?.chairs?[ChairIndes]
        .user = null;

    await Roomapi()
        .LeaveuserChair(
      context: context,
      user_id: useridchair,
      Roomid: Currentroom?.id,
      chairid: Chairids,
    )
        .then(
      (value) {
        if (value == true) {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Done_Succ",
            ),
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }

        hideSpinner3();
      },
    );

    notifyListeners();
  }

  AddusertoRoom({
    usermodel? join,
    joinRoom? JoinRoom,
    ctx,
    index,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      ctx,
      listen: false,
    );

    if (join?.id !=
        user.userinfo?.id) {
      Currentroom?.userNumber =
          (Currentroom?.userNumber ?? 0) +
              1;

      Currentroom?.joinRooms
          ?.insert(
            0,
            JoinRoom!,
          );

      print(index);
    } else {
      print(
        'You Join This Room',
      );
    }

    notifyListeners();
  }

  AddusertoChair({
    Chairs? data,
    ctx,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      ctx,
      listen: false,
    );

    if (data?.userId !=
        user.userinfo?.id) {
      print(data?.user);
      print(data?.chairId);
      print(data?.roomId);

      Currentroom?.chairs?[
              int.parse(
                    data?.chairId
                            ?.toString() ??
                        '',
                  ) -
                  1] =
          data!;
    } else {
      print(
        'You take This Chair',
      );
    }

    notifyListeners();
  }

  LockChair({
    int? state,
    int? chairId,
  }) {
    if (state != null) {
      Currentroom
          ?.chairs?[chairId ?? 0 - 1]
          .Lock = state;
    } else {
      print(
        'You take This Chair',
      );
    }

    notifyListeners();
  }

  RemoveuserfromRoom({
    String? id,
  }) {
    ComboListuser.removeWhere(
      (element) =>
          element.toString() ==
          id.toString(),
    );

    Rooms.where(
      (element) =>
          element.id.toString() ==
          id.toString(),
    );

    if (Rooms.isNotEmpty) {
      Rooms.first.userNumber =
          Rooms.first.userNumber! - 1;
    }

    Currentroom?.chairs?.forEach(
      (element) {
        if (element.userId == id) {
          Currentroom
              ?.chairs?[
                  int.parse(
                        element.chairId
                                ?.toString() ??
                            '',
                      ) -
                      1]
              .userId = null;

          Currentroom
              ?.chairs?[
                  int.parse(
                        element.chairId
                                ?.toString() ??
                            '',
                      ) -
                      1]
              .user = null;
        }
      },
    );

    Currentroom?.userNumber =
        (Currentroom?.userNumber ?? 0) -
            1;

    Currentroom?.joinRooms
        ?.removeWhere(
      (element) =>
          element.userId.toString() ==
          id.toString(),
    );

    ChairsRoom.removeWhere(
      (element) =>
          element.userId.toString() ==
          id.toString(),
    );

    notifyListeners();
  }

  ChangeRoomChair({
    usermodel? user,
    String? CurrentChair,
    String? newChair,
  }) {
    LoginViewmodel userinfo =
        Provider.of<LoginViewmodel>(
      roomcontext,
      listen: false,
    );

    RoomViewmodel Room =
        Provider.of<RoomViewmodel>(
      roomcontext,
      listen: false,
    );

    if (user?.id ==
        Room.Currentroom?.adminId) {
      Room.Currentroom
          ?.chairs?[8]
          .adminleaved = 1;

      notifyListeners();
    }

    List<Chairs>? item =
        Currentroom?.chairs
            ?.where(
              (element) =>
                  element.user?.id ==
                  user?.id,
            )
            .toList();

    if (item!.isNotEmpty) {
      item.first.userId = null;
      item.first.Karisma = 0;
      item.first.user = null;
    }

    Currentroom
        ?.chairs?[
            int.parse(
                  newChair ?? '',
                ) -
                1]
        .userId = user?.id.toString();

    Currentroom
        ?.chairs?[
            int.parse(
                  newChair ?? '',
                ) -
                1]
        .user = user;

    notifyListeners();
  }

  returntoAdminRoomChair({
    usermodel? user,
    String? CurrentChair,
    String? newChair,
  }) {
    LoginViewmodel userinfo =
        Provider.of<LoginViewmodel>(
      roomcontext,
      listen: false,
    );

    RoomViewmodel Room =
        Provider.of<RoomViewmodel>(
      roomcontext,
      listen: false,
    );

    if (user?.id ==
        Room.Currentroom?.adminId) {
      Room.Currentroom
          ?.chairs?[8]
          .adminleaved = 0;
    }

    List<Chairs>? item =
        Currentroom?.chairs
            ?.where(
              (element) =>
                  element.user?.id ==
                  user?.id,
            )
            .toList();

    if (item!.isNotEmpty) {
      item.first.userId = null;
      item.first.Karisma = 0;
      item.first.user = null;
    }

    Currentroom
        ?.chairs?[
            int.parse(
                  newChair ?? '',
                ) -
                1]
        .userId = user?.id.toString();

    Currentroom
        ?.chairs?[
            int.parse(
                  newChair ?? '',
                ) -
                1]
        .user = user;

    notifyListeners();
  }

  RemoveuserfromChair({
    String? id,
  }) {
    AgoraViewmodel Agora =
        Provider.of<AgoraViewmodel>(
      roomcontext,
      listen: false,
    );

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      roomcontext,
      listen: false,
    );

    if (id.toString() ==
        user.userinfo?.id.toString()) {
      Agora.keickedfromasAudience();
    }

    ChairsRoom.removeWhere(
      (element) =>
          element.userId.toString() ==
          id.toString(),
    );

    Currentroom?.chairs?.forEach(
      (element) {
        if (element.userId == id) {
          print(element.chairId);

          Currentroom
              ?.chairs?[
                  int.parse(
                        element.chairId
                                ?.toString() ??
                            '',
                      ) -
                      1]
              .userId = null;

          Currentroom
              ?.chairs?[
                  int.parse(
                        element.chairId
                                ?.toString() ??
                            '',
                      ) -
                      1]
              .user = null;
        }
      },
    );

    notifyListeners();
  }

  AddChatRoom({
    required Chatroom message,
  }) {
    int onec = 1;

    Currentroom?.chatroom?.add(
      message,
    );

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (onec < 2) {
          print(onec);

          if (controller?.hasClients ??
              false) {
            controller?.animateTo(
              controller
                      ?.position
                      .maxScrollExtent ??
                  0,
              curve: Curves.easeOut,
              duration:
                  const Duration(
                milliseconds: 500,
              ),
            );
          }
        }

        onec++;
      },
    );

    notifyListeners();
  }

  List guesses = [];

  AddGuessGame({
    winnerid,
    guessgamemodel? guess,
  }) {
    guesses.add({
      'winnerid': winnerid,
      'time': DateTime.now(),
      'guess': guess,
    });

    if (guesses.length > 0) {
      Timer.periodic(
        Duration(seconds: 1),
        (timer) {
          for (var i in guesses) {
            if (DateTime.now()
                    .difference(i['time'])
                    .inSeconds >
                3) {
              if (guesses.length > 0) {
                guesses.remove(i);
                notifyListeners();
                break;
              }
            }
          }
        },
      );
    }

    notifyListeners();
  }

  ChangeGuessGame({
    guessgamemodel? Guess,
    winnerid,
  }) {
    Currentroom?.chatroom
        ?.where(
          (element) =>
              element.id == Guess?.id,
        )
        .first
        .Guess = Guess;

    notifyListeners();
  }

  Getmaxchat() {
    int onec = 1;

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (onec < 2) {
          print(onec);
          print('dasdsa');

          if (controller?.hasClients ??
              false) {
            controller?.animateTo(
              controller
                      ?.position
                      .maxScrollExtent ??
                  0,
              curve: Curves.easeOut,
              duration:
                  const Duration(
                milliseconds: 500,
              ),
            );
          }
        }

        onec++;
      },
    );

    notifyListeners();
  }

  Addmessagetocurrentroom({
    message,
  }) {
    int onec = 1;

    Currentroom?.chatroom?.add(
      message,
    );

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (onec < 2) {
          if (controller?.hasClients ??
              false) {
            controller?.animateTo(
              controller
                      ?.position
                      .maxScrollExtent ??
                  0,
              curve: Curves.easeOut,
              duration:
                  const Duration(
                milliseconds: 500,
              ),
            );
          }
        }

        onec++;
      },
    );

    notifyListeners();
  }

  SendMessageChat({
    content,
  }) async {
    await Roomapi()
        .sendmessage(
      Roomid: Currentroom?.id,
      content: content,
    )
        .then(
      (value) {},
    );
  }

  SendMentionChat({
    content,
  }) async {
    await Roomapi()
        .sendMention(
      Reciver_id: Mentionid,
      Roomid: Currentroom?.id,
      content: content,
    )
        .then(
      (value) {},
    );
  }

  LockChairUpdate({
    int? state,
    Chairs? info,
  }) async {
    print('reunasdasdasd');

    await Roomapi()
        .LockChair(
      Chair_id: info?.id,
      Lock: state,
      Roominfo: Currentroom,
    )
        .then(
      (value) {
        if (value == true) {
          ChangeChairLock(
            chairId: info?.chairId,
            State: state,
          );
        }
      },
    );
  }

  Addinsults({
    context,
    type,
    message,
  }) async {
    print('reunasdasdasd');

    await Roomapi()
        .Addinsults(
      context: context,
      message: message,
      type: type,
    )
        .then(
      (value) {
        if (value == true) {
          print('trueeeeeeeeeeee');
        } else {
          print('faaalssssssssss');
        }
      },
    );
  }

  // ============================================================
  // SENT GIFTS
  // ============================================================

  SentGift({
    context,
    giftid,
    Listuser,
    quantity,
    Cost,
  }) async {
    showwaitingtimer();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    await Roomapi()
        .SendGift(
      Cost: Cost,
      context: context,
      Roomid: Currentroom?.id,
      giftid: giftid,
      Listuser: Listuser,
      quantity: quantity,
    )
        .then(
      (value) {
        if (value == true) {
          user.AddKarisma(
            (user.userinfo?.Karisma ??
                    0) +
                Cost as int,
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }
      },
    );

    notifyListeners();
  }

  var Combocost;
  var ComboListuser = [];
  var ComboQuantity;
  var ComboGiftid;

  clearcompo() {
    Combocost = null;
    ComboListuser = [];
    ComboQuantity = null;
    ComboGiftid = null;
  }

  checkcompo() {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      roomcontext,
      listen: false,
    );

    if (Combocost != null &&
        ComboListuser != null &&
        waitingtimer2 &&
        ComboQuantity != null &&
        ComboGiftid != null &&
        ComboListuser.isNotEmpty &&
        Combocost <= user.userinfo?.coins) {
      return true;
    }

    return false;
  }

  SentLuckyGift({
    context,
    giftid,
    Listuser,
    quantity,
    Cost,
  }) async {
    Combocost = Cost;
    ComboListuser = Listuser;
    ComboQuantity = quantity;
    ComboGiftid = giftid;

    print(giftid);
    print(Listuser);
    print(quantity);
    print(Cost);

    showwaitingtimer();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    print(
      '=====================MyCOINS========>${user.userinfo?.coins}==================>',
    );
    print(
      '====================COST=========>$Cost==================>',
    );
    print(
      '====================Quantay=========>$quantity==================>',
    );

    await Roomapi()
        .SentLuckyGift(
      Cost: Cost,
      context: context,
      Roomid: Currentroom?.id,
      giftid: giftid,
      Listuser: Listuser,
      quantity: quantity,
    )
        .then(
      (value) {
        if (value != '') {
          user.AddKarisma(
            (user.userinfo?.Karisma ??
                    0) +
                Cost as int,
          );

          Provider.of<RoomViewmodel>(
            roomcontext,
            listen: false,
          ).ShowLuckyCombo();

          showwaitingtimer2();
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }
      },
    );

    notifyListeners();
  }

  SentCompoLuckyGift({
    context,
  }) async {
    print(Combocost);
    print(ComboListuser);
    print(ComboQuantity);
    print(ComboGiftid);

    showwaitingtimer();

    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    await Roomapi()
        .SentCompoGift(
      Cost: Combocost,
      context: context,
      Roomid: Currentroom?.id,
      giftid: ComboGiftid,
      Listuser: ComboListuser,
      quantity: ComboQuantity,
    )
        .then(
      (value) {
        if (value != '') {
          user.AddKarisma(
            (user.userinfo?.Karisma ??
                    0) +
                Combocost as int,
          );
        } else {
          Dialogs().showtoast(
            getLang(
              context:
                  NavigationService
                      .navigatorKey
                      .currentContext,
              key: "Sorry",
            ),
          );
        }
      },
    );

    notifyListeners();
  }

  SentEmoji({
    context,
    emoji,
  }) async {
    await Roomapi()
        .SendEmoje(
      Emoje: emoji,
      context: context,
      Room_id: Currentroom?.id,
    )
        .then(
      (value) {},
    );

    notifyListeners();
  }

  bool ImageLoading = false;

  SentImageRoom({
    context,
  }) async {
    ImageLoading = true;
    notifyListeners();

    await Roomapi()
        .SentImageRoom(
      image: ChatRoomImage,
      context: context,
      Room_id: Currentroom?.id,
    )
        .then(
      (value) {
        ImageLoading = false;
        notifyListeners();
      },
    );

    notifyListeners();
  }

  Playdice({
    context,
  }) async {
    await Roomapi()
        .Playdice(
      context: context,
      Room_id: Currentroom?.id,
    )
        .then(
      (value) {},
    );

    notifyListeners();
  }

  Playrollet({
    context,
    name,
  }) async {
    await Roomapi()
        .Playrollet(
      Name: name,
      context: context,
      Room_id: Currentroom?.id,
    )
        .then(
      (value) {},
    );

    notifyListeners();
  }

  void showSpinner() {
    showloading = true;
    notifyListeners();
  }

  void showSpinner21() {
    showloading21 = true;
    notifyListeners();
  }

  void showSpinner2() {
    showloading2 = true;
    notifyListeners();
  }

  void showSpinner3() {
    showloading3 = true;
    notifyListeners();
  }

  void hideSpinner7() {
    showloading7 = false;
    notifyListeners();
  }

  void hideSpinner21() {
    showloading21 = false;
    notifyListeners();
  }

  void showSpinner7() {
    showloading7 = true;
    notifyListeners();
  }

  void hiddenSpinner26() {
    showloading26 = false;
    notifyListeners();
  }

  void showSpinner26() {
    showloading26 = true;
    notifyListeners();
  }

  void hiddenSpinner27() {
    showloading27 = false;
    notifyListeners();
  }

  void showSpinner27() {
    showloading27 = true;
    notifyListeners();
  }

  void showSpinner5() {
    showloading5 = true;
    notifyListeners();
  }

  void showSpinner14() {
    showloading14 = true;
    notifyListeners();
  }

  void hideSpinner14() {
    showloading14 = false;
    notifyListeners();
  }

  void showSpinner17() {
    showloading17 = true;
    notifyListeners();
  }

  void hideSpinner17() {
    showloading17 = false;
    notifyListeners();
  }

  void showSpinner18() {
    PasswordRoom.text =
        Currentroom?.password ?? '';
    showloading18 = true;
    notifyListeners();
  }

  void hideSpinner18() {
    showloading18 = false;
    notifyListeners();
  }

  void hideSpinner36() {
    showloading36 = false;
    notifyListeners();
  }

  void changeloading5() {
    showloading5 = !showloading5;
    notifyListeners();
  }

  void changeloading8() {
    showloading8 = !showloading8;
    notifyListeners();
  }

  void changeloading39() {
    showloading39 = !showloading39;
    print(showloading39);
    notifyListeners();
  }

  void changeloading40() {
    showloading40 = !showloading40;
    notifyListeners();
  }

  void hideloading39() {
    showloading39 = false;
    notifyListeners();
  }

  void hideloading40() {
    showloading40 = false;
    notifyListeners();
  }

  void showSpinner6() {
    showloading6 = true;
    notifyListeners();
  }

  void changeloading6() {
    showloading6 = !showloading6;
    notifyListeners();
  }

  void hideSpinner6() {
    showloading6 = false;
    notifyListeners();
  }

  void hideSpinner() {
    print('hide loading');
    showloading = false;
    notifyListeners();
  }

  void hideSpinner2() {
    print('hide loading2');
    showloading2 = false;
    notifyListeners();
  }

  void hideSpinner3() {
    print('hide loading3');
    showloading3 = false;
    notifyListeners();
  }

  void hideSpinner19() {
    showloading19 = false;
    notifyListeners();
  }

  void showSpinner19() {
    showloading19 = true;
    notifyListeners();
  }

  void hideSpinner25() {
    showloading25 = false;
    notifyListeners();
  }

  void showSpinner25() {
    showloading25 = true;
    notifyListeners();
  }

  void hideSpinner24() {
    showloading24 = false;
    ShowItem = null;
    notifyListeners();
  }

  void showSpinner24() {
    showloading24 = true;
    notifyListeners();
  }

  void hideSpinner41() {
    showloading41 = false;
    notifyListeners();
  }

  void hideSpinner42() {
    showloading42 = false;
    notifyListeners();
  }

  void hideSpinner45() {
    showloading45 = false;
    notifyListeners();
  }

  void showSpinner45() {
    showloading45 = true;
    notifyListeners();
  }
}