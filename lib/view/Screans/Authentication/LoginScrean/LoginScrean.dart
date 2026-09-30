
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/Authentication/IDloginScrean/IDloginScrean.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:provider/provider.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'Widgets/GoogleSigninButton.dart';
import 'Widgets/PhoneSignin.dart';
import 'Widgets/Termsanscondition.dart';
class LoginScrean extends StatefulWidget {
  const LoginScrean({Key? key}) : super(key: key);
  @override
  State<LoginScrean> createState() => _LoginScreanState();
}

class _LoginScreanState extends State<LoginScrean> {

  // @override
  // void initState() {
  //
  //   SchedulerBinding.instance?.addPostFrameCallback((_) {
  //     initPlatformState();
  //   });
  //       }
  //
  // Future<void> initPlatformState() async {
  //   bool jailbroken;
  //   bool developerMode;
  //
  //   try {
  //     jailbroken = await FlutterJailbreakDetection.jailbroken;
  //     developerMode = await FlutterJailbreakDetection.developerMode;
  //   } on PlatformException {
  //     jailbroken = true;
  //     developerMode = true;
  //   }
  //
  //
  //   if(jailbroken){
  //     Dialogs().showtoast('You use Root');
  //     SystemNavigator.pop();
  //   }
  //   // if(developerMode){
  //   //   Dialogs().showtoast('Please Close developerMode');
  //   //   SystemNavigator.pop();
  //   // }
  // }

  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false) ;
    return WillPopScope(onWillPop: () async{
      return false;
    },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: LinearGradient(  begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.05, 0.5, ],colors: [
                Color(0xFF1878f3).withOpacity(0.5),Colors.white
          ])),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),

                Padding(
                  padding:   EdgeInsets.all(SizeConfig.TenSize!*3),
                  child: Image.asset(Images.logo ),
                ),



              SizedBox(height: SizeConfig.TenSize!*10,),
                const GoogleSignin(),
                HSized20,
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(onTap: () {
                      user.LoginPassword.clear();
                      user.LoginID.clear();
                      navigateTo(context: context, screen: IDloginScrean());

                    },child: Image.asset(Images.ID,height:  SizeConfig.TenSize!*5.5)),
                    SizedBox(width:  SizeConfig.TenSize!*5.5,),
                    InkWell(onTap: () {
                      Navigator.pushNamed(context, AppConstants.PhoneAuthScrean);

                    },child: Image.asset(Images.Phone,height:  SizeConfig.TenSize!*5.5)),
                  ],
                ),
                SizedBox(height:  SizeConfig.TenSize!,),
                const Termesandcondition(),
                SizedBox(height:  SizeConfig.TenSize!*2,)

              ],
            ),
        ),
      ),
    );
  }
}

