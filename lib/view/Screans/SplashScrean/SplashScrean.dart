
import 'dart:convert';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/LoginScrean.dart';
import 'package:ahlachat/view/Screans/Layouts/NavBar.dart';
import 'package:ahlachat/view/Screans/StartBanner/StartBannerScrean.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Language_Viewmodel/LanguageViewmodel.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScrean extends StatefulWidget {
  const SplashScrean({Key? key}) : super(key: key);
  @override
  State<SplashScrean> createState() => _SplashScreanState();
}
class _SplashScreanState extends State<SplashScrean> {
  checklanguage()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Lang= prefs.getString('Lang');
    print("language====================================$Lang");
    print('Lang is $Lang');
    setState(() {

    });

  }
  void checkConnectitivy() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile||connectivityResult==ConnectivityResult.wifi) {
      SchedulerBinding.instance?.addPostFrameCallback((_) async{
     await Helper().ids();
     Helper().checkVersion();
     Provider.of<LoginViewmodel>(context,listen: false).checklogin(context);
     Provider.of<LoginViewmodel>(context,listen: false).getAllconstant(context);
      });
    } else{

      Navigator.pushNamed(context, AppConstants.InternetConnection_Screan);
    }


  }


  checklogin(context)async{
    LoginViewmodel   UserState=Provider.of<LoginViewmodel>(context,listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Token=prefs.getString('token');

    if(Token==null){

      UserState.UpdateCurrentPage(LoginScrean());
     // Navigator.pushNamed(context,AppConstants.Login_Screan);
    }else{

      var  datauser=  prefs.getString('UserData');
      var userinfo = jsonDecode(datauser!);
      var user = usermodel.fromJson(userinfo);
      UserState.MyUSERINFO(user);
      UserState.waitingConstDate(context);

      UserId=user.id.toString();
      if(user.StarterBanner!=null){

        UserState.UpdateCurrentPage(StartBannerScrean());
      }else{

        UserState.UpdateCurrentPage(ButtomNavigation());
      }

    }

  }
  @override
  void initState() {
    checklogin(context);
    checkConnectitivy();
    getIPAddress();
    getPublicIP();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    LoginViewmodel   UserState=Provider.of<LoginViewmodel>(context,listen: true);
    return UserState.CurrentBage;
  }
}
