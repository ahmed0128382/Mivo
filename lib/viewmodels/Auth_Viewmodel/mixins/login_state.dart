import 'package:ahlachat/models/Banner.dart';
import 'package:ahlachat/models/LevelsFrame.dart';
import 'package:ahlachat/models/NotificationModel.dart';
import 'package:ahlachat/models/UserGiftsmodel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/models/emoji.dart';
import 'package:ahlachat/models/emojicategory.dart';
import 'package:ahlachat/models/shipping.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import 'package:ahlachat/models/Inboxroom.dart';

/// Shared fields used by all LoginViewmodel feature mixins.
mixin LoginState on ChangeNotifier {
  int menuit = 0;
  int? SelectGuessList;
  int? Guesscoins;
  int? Packageid;

  String CurrentIndex = '5';

  TextEditingController SearchController = TextEditingController();

  final firebaseAuth = FirebaseAuth.instance;

  usermodel? userroominfo;
  usermodel? joinuserprofile;
  usermodel? userProfileData;

  TextEditingController textEditingController = TextEditingController();

  String currentText = "";

  String Flag = '🇪🇬';
  String Code = '+20';
  String Country = 'Egypt';

  String Flag2 = '🇪🇬';
  String? Code2;
  String? Name2;

  var UsernameComp;
  var HistoryComp;

  int ginder = 0;
  int day = 0;
  int year = 0;
  int month = 0;
  int? sendcodestate;

  TextEditingController LoginPhonenumber = TextEditingController();

  TextEditingController LoginID = TextEditingController();

  TextEditingController LoginPassword = TextEditingController();

  bool showloading = false;
  bool showloading2 = false;
  bool showloading3 = false;
  bool showloading4 = false;
  bool showloading5 = false;
  bool showloading6 = false;
  bool showloading7 = false;
  bool showloading8 = false;
  bool showloading9 = false;
  bool showloading10 = false;
  bool showloading11 = false;
  bool showloading12 = false;
  bool showloading13 = false;
  bool showloading14 = false;
  bool showloading15 = false;
  bool showloading16 = false;
  bool showloading31 = false;

  List<usermodel> Searchusers = [];

  TextEditingController Content = TextEditingController();

  TextEditingController Contact = TextEditingController();

  var Googleaccount;
  var Signupimage;
  var Updateimage;
  var Reportimage;
  var Edimage;
  var Comimage;
  var ProfileImage;
  var Avatarlink;
  var name;
  var phone;
  var password;

  bool gender = false;
  bool obscureText = false;

  String? Username;
  String? Password;
  String? PhoneNumber;
  String? Description;
  String? City;
  String? History;
  String? FaceBook;

  List<Bannerss> Banners = [];
  List<emojimodel> emojis = [];
  List<EmojiCategory> emojisCategory = [];

  List Giftcatigoris = [];
  List LuckyGiftcatigoris = [];
  List Roomcatigoris = [];
  List background = [];

  List<shipping> Shipping = [];
  List<LevelFrame> LevelFrames = [];

  usermodel? ShowProfiluser;

  String Selectedday = DateTime.now().day.toString();

  String Selectedmonth = DateTime.now().month.toString();

  String Selectedyear = DateTime.now().year.toString();

  String? Choose = 'Help';
  String? Choose2 = "WhatsApp";

  List<usergifts> UserGift = [];
  List<Notificationmodel> Notifications = [];

  List imoge = [];
  List Luckypackages = [];

  bool value = false;

  usermodel? playerinfo;
  usermodel? userinfo;

  bool Newmessage = false;

  List selectedcolor = [];

  Widget CurrentBage = SizedBox();

  int TargetMin = 0;

  InboxRoomModel? ChatRoom = InboxRoomModel();

  // ---------------------------------------------------------------------------
  // Loading spinners (shared — used by many feature mixins)
  // ---------------------------------------------------------------------------

  void showSpinner() {
    showloading = true;
    notifyListeners();
  }

  void hideSpinner() {
    showloading = false;
    notifyListeners();
  }

  void showSpinner2() {
    showloading2 = true;
    notifyListeners();
  }

  void hideSpinner2() {
    showloading2 = false;
    notifyListeners();
  }

  void showSpinner3() {
    showloading3 = true;
    notifyListeners();
  }

  void hideSpinner3() {
    showloading3 = false;
    notifyListeners();
  }

  void showSpinner4() {
    showloading4 = true;
    notifyListeners();
  }

  void hideSpinner4() {
    showloading4 = false;
    notifyListeners();
  }

  void showSpinner5() {
    showloading5 = true;
    notifyListeners();
  }

  void hideSpinner5() {
    showloading5 = false;
    notifyListeners();
  }

  void showSpinner6() {
    print(' 2');
    showloading6 = true;
    notifyListeners();
  }

  void hideSpinner6() {
    showloading6 = false;
    notifyListeners();
  }

  void showSpinner7() {
    showloading7 = true;
    notifyListeners();
  }

  void hideSpinner7() {
    showloading7 = false;
    notifyListeners();
  }

  void showSpinner8() {
    print(' 8');
    showloading8 = true;
    notifyListeners();
  }

  void hideSpinner8() {
    showloading8 = false;
    notifyListeners();
  }

  void showSpinner9() {
    showloading9 = true;
    notifyListeners();
  }

  void hideSpinner9() {
    showloading9 = false;
    notifyListeners();
  }

  void showSpinner10() {
    print(' 9');
    showloading10 = true;
    notifyListeners();
  }

  void hideSpinner10() {
    showloading10 = false;
    notifyListeners();
  }

  void showSpinner11() {
    showloading11 = true;
    notifyListeners();
  }

  void hideSpinner11() {
    showloading11 = false;
    notifyListeners();
  }

  void showSpinner12() {
    print(' 9');
    showloading12 = true;
    notifyListeners();
  }

  void hideSpinner12() {
    showloading12 = false;
    notifyListeners();
  }

  void showSpinner13() {
    showloading13 = true;
    notifyListeners();
  }

  void hideSpinner13() {
    showloading13 = false;
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

  void showSpinner15() {
    showloading15 = true;
    notifyListeners();
  }

  void hideSpinner15() {
    showloading15 = false;
    notifyListeners();
  }

  void showSpinner16() {
    showloading16 = true;
    notifyListeners();
  }

  void hideSpinner16() {
    showloading16 = false;
    notifyListeners();
  }

  void showSpinner31() {
    showloading31 = true;
    notifyListeners();
  }

  void hideSpinner31() {
    showloading31 = false;
    notifyListeners();
  }

  void toggle() {
    obscureText = !obscureText;
    notifyListeners();
  }

  // Declared here so ImagePickersMixin can call it; implemented in ProfileUpdateMixin.
  dynamic updatephoto({token, photo, context, avatar});

}
