import 'dart:io';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/Layouts/widgets/DragableWidget.dart';
import 'package:ahlachat/view/Screans/MainScreans/Explore/ExoploreTaps.dart';
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageTaps.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:ahlachat/viewmodels/Wallet_ViewModel/Wallet_ViewModel.dart';
import 'package:badges/badges.dart' as badges;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels/pusher_channels.dart';
import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/app_constants.dart';
import '../../../util/images.dart';
import '../../../util/notification.dart';
import '../../../viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import '../../../viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import '../../../viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
import '../../../viewmodels/Music_Viewmodel/MusicViewmodel.dart';
import '../../../viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import '../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import '../../../viewmodels/Socket_ViewModel/GlopelSocketModelView.dart';
import '../../../viewmodels/Socket_ViewModel/SocketUserModelView.dart';
import '../MainScreans/MainScrean/widgets/Taps.dart';
import '../MainScreans/ProfileScrean/ProfileScrean.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';


class ButtomNavigation extends StatefulWidget {
  @override
  _ButtomNavigationState createState() => _ButtomNavigationState();
}
class _ButtomNavigationState extends State<ButtomNavigation> with   WidgetsBindingObserver{
  int _selectedIndex = 0;
  void isVpnActive() async {
    bool isVpnActive;

    List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false, type: InternetAddressType.any);

    interfaces.isNotEmpty
        ? isVpnActive = interfaces.any((interface) =>
        interface.name.contains("tun")
        // ||
        // interface.name.contains("ppp") ||
        // interface.name.contains("pptp")
    )
        : isVpnActive = false;


    if(isVpnActive == true){
 //    exit(0);
      Dialogs().showtoast('is VpnActive');
      SystemNavigator.pop();

    }else{

    }


  }
  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {

      for (var addr in interface.addresses) {

        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name} ${addr.isMulticast}');
      }
    }
  }

  static  final List<Widget> _widgetOptions = <Widget>[
    MainScrean(),
      ExploreTaps(),
    MessageTaps(),

   ProfileScrean(),
  ];
  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;

    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }


    if(jailbroken){
      Dialogs().showtoast('You use Root');
      SystemNavigator.pop();
    }
    // if(developerMode){
    //   Dialogs().showtoast('Please Close developerMode');
    //   SystemNavigator.pop();
    // }
  }

  checkforupdates(){

    InAppUpdate.checkForUpdate().then((updateInfo) {

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    SchedulerBinding.instance?.addPostFrameCallback((_) {

      checkforupdates();
      Helper().RequestPermissions();

      LocalNotificationService().intialize();
        Provider.of<SocketuserViewmodel>(context,listen: false).ConnectuserScocket(context);

          //Provider.of<MusicViewModel>(context,listen: false).Initsong();
           Provider.of<WalletViewmodel>(context,listen: false).FeatchOffers();
           Provider.of<GlopelViewmodel>(context,listen: false).ConnectGlopalScocket(context);

     Provider.of<RoomViewmodel>(context,listen: false).GetRoom(context: context);
      Provider.of<RoomViewmodel>(context,listen: false).GetFixedRoom(context: context);
      Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
        initPlatformState();
    // isVpnActive();
    // Trusted();

        if(results.contains(ConnectivityResult.none)){

            Navigator.pushNamed(context, AppConstants.InternetConnection_Screan);


        }

      });

    initpusher();

    });
    super.initState();
  }
  final pusher = Pusher(key: '4e68aedca5c74610deac',cluster: 'mt1');

  initpusher()async{

    try {

      await pusher.connect();
      final channel = pusher.subscribe(UserId.toString());
      channel.bind('event', (event) {

      });

    } catch (e) {


    }
  }
 int Checkonce=0;
  int Checkonce2=0;
  int Checkonce3=0;
  void _onItemTapped(int index) {
print(index);
    setState(() {
      _selectedIndex = index;
      if(index==2&&Checkonce==0){
        Checkonce=1;
        Provider.of<InboxroomViewModel>(context,listen: false).GetInboxroom(context: context);
      }else if(index==1&&Checkonce2==0){
        Checkonce2=1;
        Provider.of<MomentViewModel>(context,listen: false).GetPostes(context: context);
        Provider.of<MomentViewModel>(context,listen: false).GetFollowPostes(context: context);
        // Provider.of<InboxroomViewModel>(context,listen: false).GetInboxroom(context: context);
      }else if(index==2&&Checkonce3==0){
        Checkonce3=1;
        Provider.of<InboxroomViewModel>(context,listen: false).GetInboxroom(context: context);
      }

    });
  }
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);

    super.dispose();
  }

  void messageReceived(String msg){
    setState(() {
     var message=msg;
     print(message);
    });

  }
  @override
  DateTime? currentBackPressTime;
  bool onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime??DateTime.now()) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Dialogs().showtoast(getLang( context: context, key: "Tap_Exit"));
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    RoomPlayViewModel  RoomPlay =Provider.of<RoomPlayViewModel>(context, listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    MomentViewModel   posts=Provider.of<MomentViewModel>(context,listen: true);
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
     return WillPopScope(
      onWillPop: () async{
       if(Rooms.showloading6 ) {
         Rooms.hideSpinner6();
       }else if(user.showloading6) {
          user.clearreport();
          user.hideSpinner6();
        }else if(user.showloading5){
          user.hideSpinner5();
        } else if(user.showloading4){
          user.hideSpinner4();
        }else if(posts.showloading4){
          posts.hidespinner4();
        }else{

        bool backStatus = onWillPop();
        if (backStatus) {
          SystemNavigator.pop();
        }

    }
        return  false ;
      },
      child: Scaffold(
        body:  Stack(children: [

          Image.asset(Images.ChatBack),
          if(_selectedIndex==0) Image.asset(Images.livebackground),
          if(_selectedIndex==2) Image.asset(Images.MessageBackGround),
          if(_selectedIndex==3)Image.asset(Images.ProfileBackGround),
          IndexedStack(
              index: _selectedIndex,
              children:_widgetOptions
          ),
           if(RoomPlay.HasRoom==true) const Align(alignment: Alignment.bottomLeft,child: Padding(
             padding: EdgeInsets.symmetric(vertical: 50,horizontal: 10),
             child: Directionality(textDirection: TextDirection.ltr,child: DragableWidget()),
           )),


        ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed ,

          backgroundColor:Colors.white,
          selectedLabelStyle: const TextStyle( fontSize: 12),

          items:   <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:Image.asset(_selectedIndex==0?Images.homeicon:Images.homeiconun,height:25,width: 25),
              label: getLang( context: context, key: "Home"),
            ),
            BottomNavigationBarItem(
              icon:Image.asset(_selectedIndex==1?Images.explore:Images.exploreno,height:25,width: 25),
              label: getLang( context: context, key: "Explore"),
            ),
            BottomNavigationBarItem(
              icon:Stack(   children: [
                Image.asset(_selectedIndex==2?Images.chatcon:Images.chatconcolor,height:25,width: 25,),
             if( Provider.of<LoginViewmodel>(context, listen:true).userinfo?.MessageNumber!=0&&Provider.of<LoginViewmodel>(context, listen:true).userinfo?.MessageNumber!=null)   Positioned(top: -5,
                  child: badges.Badge(
                    badgeContent: Text(user.userinfo?.MessageNumber.toString()??"0",style: TextStyle(color: Colors.white,fontSize: 10)),


                  ),
                )
              ], ),
              label:getLang( context: context, key: "Messages"),
            ),


            BottomNavigationBarItem(
              icon:Image.asset(_selectedIndex==3? Images.profile:Images.profileun ,height:25,width: 25),
              label: getLang( context: context, key: "me"),
            ),
          ],
          currentIndex: _selectedIndex,
          elevation: 10,
          selectedItemColor: Colors.black87,unselectedItemColor: Colors.black45,
          unselectedLabelStyle:   TextStyle( fontSize: 12),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
