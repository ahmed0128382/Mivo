import 'package:flutter/material.dart';

import '../models/Language/Localization.dart';
import '../models/StartBannerModel.dart';

String? Token;
String? UserId;
var UserIP;
var EnterImage;
var ImojeSUserId;
var Entername;
bool CheckBlocked=false;
String ?UserBlockedId;
const double  ScreanHight=0;
const double  ScreanWidth=0;
bool JoinChairs = false;
int? Joinid;
String version='';
String AppLink='';
String Appversion='';
var bayBanners;
var notifitoken;
var ExchangeCoins;
String? Gmail;
var countryname = 'مصر';
var phonecode = '+20';
var thiss;
List JoinIds=[];
String SelectedRoomCategory='Hot';
List payamounts = [];
List SharedRoomIds = [];
String InviteChairId='';
String  ?deviceId='';
const int LEVELAMOUNT=100000;
String? verificationid;

List <String> insult=[
  'زبي',
  'كس',
  'امك',
  'خول',
  'نيك',
  'اختك',
  'عرص',
  'احا',
  'ass',
  'fuck',
  'dick',
];


class AppConstants {
  static const String APP_NAME = 'World Chat';
  static const String FirstMessage = 'Hi';
  static const String BASE_URL = 'https://theprochat.com//';
  static const String Image_URL ="https://theprochat.com/images/";
  static const String Socket_port = 'worldchat.online';
  static const String Splash_Screan = '/';
  static const String FamilyProfile_Screan='/FamilyProfile_Screan';
  static const String AllFamily_Screan='/AllFamily_Screan';
  static const String PickCode_Screan='/PickCode_Screan';
  static const String PickCode_Screan2='/PickCode_Screan2';

  static const String CountriesRoomScrean='/CountriesRoomScrean';
  static const String AllCountriesScrean='/AllCountriesScrean';
  static const String CreateFamily_Screan='/CreateFamily_Screan';
  static const String FamilyMembers_Screan='/FamilyMembers_Screan';
  static const String JoinRequest_Screan='/JoinRequest_Screan';

  static const String Chatnotifi = 'assets/audios/notification.mp3';
  static const String Room_Screan = '/Room_Screan';
  static const String Level_Screan = '/Level_Screan';
  static const String Login_Screan = '/Login_Screan';
  static const String SignUp_Screan = '/SignUp_Screan';
  static const String OTP_Screan = '/OTP_Screan';
  static const String Vip_Screan='/Vip_Screan';
  static const String ImageView='/ImageView'; 
  static const String  InternetConnection_Screan='InternetConnection_Screan';
  static const String MainPage_Screan = '/MainPage_Screan';
  static const String PinCodeVerification_Screen ='/PinCodeVerification_Screen';
  static const String SearchForRooms_Screan ='/SearchForRooms_Screan';
  static const String SearchUsers_Screan = '/SearchUsers_Screan';
  static const String Notification_Screan = '/Notification_Screan';
  static const String Agency_Screan = '/Agency_Screan';

  static const String AddMusic_Screan = '/AddMusic_Screan';
  static const String SearchAgency_Screan = '/SearchAgency_Screan';
  static const String Visitors_Screan = '/Visitors_Screan';
  static const String CompleteSignUp_Screan = '/CompleteSignUp_Screan';
  static const String EnterCodeSignUp_Screan = '/EnterCodeSignUp_Screan';
  static const String Recharge_Screan = '/Recharge_Screan';
  static const String Edit_Profile = '/Edit_Profile';
  static const String MyVip_Screan = '/MyVip_Screan';
  static const String FollowedRoom_Screan = '/FollowedRoom_Screan';

  static const String Exchange_Screan = '/Exchange_Screan';
  static const String Shop_Screan = '/Shop_Screan';
  static const String StartBanner_Screan = '/StartBanner_Screan';
  static const String AgencyProfile_Screan = '/AgencyProfile_Screan';
  static const String User_Gifts = '/User_Gifts';
  static const String Level_Gifts = '/Level_Gifts';
  static const String OTPForget_Password = '/OTPForget_Password';
  static const String User_Profile = '/User_Profile';
  static const String ProfileuserMoment_Content = '/ProfileuserMoment_Content';
  static const String Exchangecoins_Screan = '/Exchangecoins_Screan';
  static const String Buttom_Navigation = '/Buttom_Navigation';
  static const String Fan_Screan = '/Fan_Screan';
  static const String Friends_Screan = '/Friends_Screan';
  static const String ShareRoom_Screan = '/ShareRoom_Screan';
  static const String FollowingProfile_Screan ='/FollowingProfile_Screan';
  static const String FanProfile_Screan ='/FanProfile_Screan';
  static const String ShowUser_Profile ='/ShowUser_Profile';
  static const String ChatUser_Profile ='/ChatUser_Profile';
  static const String Following = '/Following';
  static const String Chat_Screan = '/Chat_Screan';
  static const String Moment_Content = '/Moment_Content';
  static const String Contact_Us = '/Contact_Us';
  static const String MyMomentcontent = '/MyMomentcontent';
  static const String BageScrean = '/BageScrean';
  static const String PhoneAuthScrean = '/PhoneAuth_Screan';
  static const String EnterCodeScrean = '/EnterCode_Screan';
  static const String LeaderboardScrean = 'Leaderboard_Screan';
  static List<LanguageModel> languages = [
    LanguageModel(countryCode: 'US', languageCode: 'en'),
    LanguageModel(countryCode: 'SA', languageCode: 'ar'),
  ];
}
class ChecklevelModel {
  String image;
  Color colors;
  ChecklevelModel({required this.image, required this.colors});
}
ChecklevelModel checkLevelimage({context,required int karisma}){
  if(karisma>=1&&karisma<=9  ) {
    return  ChecklevelModel(image: 'assets/image/level1-10.png',colors:Colors.orange);
  }else if(karisma>=10&&karisma<=19  ) {
    return  ChecklevelModel(image: 'assets/image/level10-20.png',colors:Color(0xFF8C98A8) );
  }else if( karisma>=20&&karisma<=29  ) {
    return  ChecklevelModel(image: 'assets/image/level20-30.png',colors:Color(0xFF8C98A8) );

  }else if(karisma>=30&&karisma<=39  ) {
    return  ChecklevelModel(image: 'assets/image/level30-40.png',colors:Color(0xFF8C98A8) );

  }else if(karisma>=40&&karisma<=49  ) {
    return  ChecklevelModel(image: 'assets/image/level40-50.png',colors:Color(0xFF8C98A8) );

  }else if(karisma>=50&&karisma<=59  ) {
    return  ChecklevelModel(image: 'assets/image/level50-60.png',colors:Color(0xFF8C98A8) );

  }else if(karisma>=60&&karisma<=69  ) {
    return  ChecklevelModel(image: 'assets/image/level60-70.png',colors:Color(0xFF8C98A8) );

  }else if(karisma>=70&&karisma<=79  ) {
    return  ChecklevelModel(image: 'assets/image/level70-80.png',colors:Color(0xFF8C98A8) );

  }else if( karisma>=80&&karisma<=89  ) {
    return  ChecklevelModel(image: 'assets/image/level80-90.png',colors:Color(0xFF8C98A8) );

  }else if( karisma>=90&&karisma<=99  ) {
    return  ChecklevelModel(image: 'assets/image/level90-100.png',colors:Color(0xFF8C98A8) );

  }else if( karisma>=100&&karisma<=109  ) {
    return  ChecklevelModel(image: 'assets/image/ic_user_level_200to219.png',colors:Color(0xFF8C98A8) );

   }else if( karisma>=110&&karisma<=119  ) {
return  ChecklevelModel(image: 'assets/image/ic_user_level_220to239.png',colors:Color(0xFF8C98A8) );

}else if( karisma>=120&&karisma<=129  ) {
    return  ChecklevelModel(image: 'assets/image/ic_user_level_240to259.png',colors:Color(0xFF8C98A8) );

  }else if( karisma>=260&&karisma<=279  ) {
    return  ChecklevelModel(image: 'assets/image/ic_user_level_260to279.png',colors:Color(0xFF8C98A8) );

  }else if( karisma>=280 ) {
    return  ChecklevelModel(image: 'assets/image/ic_user_level_280to300.png',colors:Color(0xFF8C98A8) );

  }else{
    return  ChecklevelModel(image: 'assets/image/ic_user_level_1to19.png',colors:Color(0xFF8C98A8) );

  }

}
