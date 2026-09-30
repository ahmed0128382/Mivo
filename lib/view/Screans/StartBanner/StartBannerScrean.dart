

import 'dart:async';

import 'package:ahlachat/view/Screans/Layouts/NavBar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:provider/provider.dart';
class StartBannerScrean extends StatelessWidget {


  bool Click=false;
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=Provider.of<LoginViewmodel>(context, listen: true);
     return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            InkWell(onTap: (){


              if(user.userinfo?.StarterBanner?.roomId!=null){
                Click=true;
                user.UpdateCurrentPage(ButtomNavigation());
                // Future.delayed(Duration(seconds: 2),(){
                //   Rooms.JoinRoom5(Roomid: user.userinfo?.StarterBanner?.roomId,context: roomcontext );
                // },);
              }


            },
              child: Container(width: SizeConfig.screenWidth!,height: SizeConfig.screenHeight!,
              child: CachedNetworkImage(
                imageUrl: user.userinfo?.StarterBanner?.photo??'' ,fit: BoxFit.fill ,
                placeholder: (context, url) => Image.asset(Images.logo,fit: BoxFit.fill),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),

              ),
            ),
             Opacity(opacity: 0.0,
              child: TimeCircularCountdown(
                unit: CountdownUnit.second,
                shouldDowngradeUnit: false,
                countdownCurrentColor:whitecolor,
                countdownTotal:5,
                onUpdated: (unit, remainingTime){
                  user.UpdateCurrentIndex(remainingTime.toString());
                },
                onFinished: () {
                  if( Click==false){
                    user.UpdateCurrentPage(ButtomNavigation());

                  }

                },
              ),
            ),

            Align(alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25,left: 10,right: 10),
                child: InkWell(onTap: () {
                  user.UpdateCurrentPage(ButtomNavigation());
                },
                  child: Container(width: 70,height: 35,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),border: Border.all(color: Colors.white)),
                    child: Center (child: Text("${user.CurrentIndex} " 'تخطي',style: style1.copyWith(height: 1,fontSize: 12,fontWeight: FontWeight.normal))),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
