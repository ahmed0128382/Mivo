import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/PostsModel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/view/Screans/Family/CreateFamilyScrean.dart';

import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/CountriesRoom.dart';
import 'package:ahlachat/view/Screans/SplashScrean/InternetConnection.dart';
import 'package:ahlachat/view/widgets/PickFlag.dart';
import 'package:flutter/material.dart';

import '../view/Screans/AddMusicScrean/AddMusicScrean.dart';
import '../view/Screans/AgencyScrean/AgencesScrean.dart';
import '../view/Screans/AgencyScrean/AgencyProfileScrean.dart';
import '../view/Screans/AgencyScrean/SearchForAgency.dart';
import '../view/Screans/Authentication/CompleteSignUp/CompleteSignUp.dart';
import '../view/Screans/Authentication/EnterCodeScrean/EnterCodeScrean.dart';
import '../view/Screans/Authentication/EnterCodeScrean/EnterCodeSignUp.dart';
import '../view/Screans/Authentication/LoginScrean/LoginScrean.dart';
import '../view/Screans/Authentication/LoginScrean/PhoneAuthScrean.dart';
import '../view/Screans/BageScrean/BageScrean.dart';
import '../view/Screans/ChatScrean/ChatScrean.dart';

import '../view/Screans/ExchangeScrean/ExchangeScrean.dart';

import '../view/Screans/FollowScreans/FanScrean.dart';
import '../view/Screans/FollowScreans/FollowingScrean.dart';
import '../view/Screans/FollowScreans/FriendsScrean.dart';
import '../view/Screans/FollowScreans/VisitorsScrean.dart';
import '../view/Screans/FollowedRoomScrean/FollowedRoomScrean.dart';
import '../view/Screans/Layouts/NavBar.dart';
import '../view/Screans/LeaderboardScrean/LeaderboardScrean.dart';
import '../view/Screans/LevelScrean/LevelGifts.dart';
import '../view/Screans/LevelScrean/LevelScrean.dart';
import '../view/Screans/MainScreans/ProfileScrean/ContactUs.dart';
import '../view/Screans/MainScreans/ProfileScrean/EditProfile.dart';

import '../view/Screans/MainScreans/ShopScrean/ShopScrean.dart';
import '../view/Screans/MomentScrean/MomentContent.dart';
import '../view/Screans/NotificationScrean/NotificationScrean.dart';
import '../view/Screans/RechargeScrean/Rechargescrean.dart';
import '../view/Screans/RoomScrean/RoomScrean.dart';
import '../view/Screans/RoomScrean/widgets/ShareRoomScrean.dart';

import '../view/Screans/SearchScrean/SearchScrean.dart';
import '../view/Screans/SplashScrean/SplashScrean.dart';
import '../view/Screans/StartBanner/StartBannerScrean.dart';
import '../view/Screans/UserGifts/UserGifts.dart';



import '../view/Screans/UserProfile/ShowUserProfile.dart';
import '../view/Screans/VipScrean/MyVipScrean.dart';
import '../view/Screans/VipScrean/VipScrean.dart';
import '../view/widgets/ImageView.dart';
Route<dynamic> generateRoute(RouteSettings settings) {
      switch (settings.name) {
        case AppConstants.Splash_Screan:
          return MaterialPageRoute(builder: (_) => const SplashScrean());
        case AppConstants.Login_Screan:
          return MaterialPageRoute(builder: (_) =>const LoginScrean());
        case AppConstants.PhoneAuthScrean:
          return MaterialPageRoute(builder: (_) => const PhoneAuthScrean());

          case AppConstants.Room_Screan:
          return MaterialPageRoute(builder: (_) => const RoomScrean());
        case AppConstants.CountriesRoomScrean:
          return MaterialPageRoute(builder: (_) => const CountriesRoomScrean());
        case AppConstants.Level_Screan:
          return MaterialPageRoute(builder: (_) => const LevelScrean());
        case AppConstants.Vip_Screan:
          return MaterialPageRoute(builder: (_) => const VipScrean());
        case AppConstants. MyVip_Screan:
          return MaterialPageRoute(builder: (_) => MyVipScrean());

        case AppConstants.EnterCodeSignUp_Screan:
          return MaterialPageRoute(builder: (_) => const EnterCodeSignUp());
        case AppConstants.SearchForRooms_Screan:
          return MaterialPageRoute(builder: (_) => SearchScrean());

        case AppConstants.InternetConnection_Screan:
          return MaterialPageRoute(builder: (_) => InternetConnection());
        case AppConstants.ImageView:
          return MaterialPageRoute(builder: (_) => ImageView());

        case AppConstants.CompleteSignUp_Screan:
          return MaterialPageRoute(builder: (_) => const CompleteSignUp());

        case AppConstants.CreateFamily_Screan:
          return MaterialPageRoute(builder: (_) => const CreateFamilyScrean());
        case AppConstants.ShowUser_Profile:
          return MaterialPageRoute(builder: (_) => ShowUserProfile());

        case AppConstants.Edit_Profile:
          return MaterialPageRoute(builder: (_) => const EditProfile());
        case AppConstants.Exchange_Screan:
          return MaterialPageRoute(builder: (_) => const ExchangeScrean());
        case AppConstants.LeaderboardScrean:
          return MaterialPageRoute(builder: (_) => const LeaderboardScrean());


        case AppConstants.Contact_Us:
          return MaterialPageRoute(builder: (_) => ContactUs());
        case AppConstants.Fan_Screan:
          return MaterialPageRoute(builder: (_) => const FanScrean());
        case AppConstants.Visitors_Screan:
          return MaterialPageRoute(builder: (_) => const VisitorsScrean());
        case AppConstants.PickCode_Screan:
          return MaterialPageRoute(builder: (_) => const PickCode());
        case AppConstants.PickCode_Screan2:
          return MaterialPageRoute(builder: (_) => const PickCode2());
          case AppConstants.Following:
          return MaterialPageRoute(builder: (_) => const FollowingScrean());
        case AppConstants.Friends_Screan:
          return MaterialPageRoute(builder: (_) => const FriendsScrean());
        case AppConstants.ShareRoom_Screan:
          return MaterialPageRoute(builder: (_) => const ShareRoomScrean());
        case AppConstants.StartBanner_Screan:
          return MaterialPageRoute(builder: (_) => StartBannerScrean());

        case AppConstants.Buttom_Navigation:
          return MaterialPageRoute(builder: (_) => ButtomNavigation());
        case AppConstants.Chat_Screan:
          return MaterialPageRoute(builder: (_) => ChatScrean(InboxContent: settings.arguments as InboxRoomModel));
        case AppConstants.Level_Gifts:
          return MaterialPageRoute(builder: (_) => const LevelGifts());

        case AppConstants.User_Gifts:
          return MaterialPageRoute(builder: (_) => UserGifts());
        case AppConstants.Notification_Screan:
          return MaterialPageRoute(builder: (_) => NotificationScrean());
        case AppConstants.Agency_Screan:
          return MaterialPageRoute(builder: (_) => AgencesScrean());
        case AppConstants.AgencyProfile_Screan:
          return MaterialPageRoute(builder: (_) => AgencyProfileScrean());


        case AppConstants.Moment_Content:
          return MaterialPageRoute(builder: (_) => Momentcontent(ChoosePost:    settings.arguments as Postes));


        case AppConstants.BageScrean:
          return MaterialPageRoute(builder: (_) => BagScrean());
        case AppConstants.Recharge_Screan:
          return MaterialPageRoute(builder: (_) => RechargeScrean());
        case AppConstants.Shop_Screan:
          return MaterialPageRoute(builder: (_) => ShopScrean());
        case AppConstants.FollowedRoom_Screan:
          return MaterialPageRoute(builder: (_) => const FollowedRoomScrean());

        default:
          return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
      }
    }


