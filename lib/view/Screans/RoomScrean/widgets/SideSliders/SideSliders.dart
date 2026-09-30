import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';

import 'package:ahlachat/view/Screans/RoomScrean/widgets/LuckyGifts/LuckyGifts.dart';
import 'package:ahlachat/view/widgets/WebViewScrean.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class SideSliders extends StatelessWidget {
  const SideSliders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);

    var wait=5;
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Room.waitingtimer2? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(width: 30,height: 30,
              child: TimeCircularCountdown(
                unit: CountdownUnit.second,
                shouldDowngradeUnit: false,
                countdownCurrentColor:MainColor,
                countdownTotal:30,
                onUpdated: (unit, remainingTime){
                  //   wait=remainingTime;
                },
                onFinished: () {

                  Room.hidewaitingtimer2();


                },
              ),
            ),
          ):SizedBox(),

          InkWell(onTap: (){

            showModalBottomSheet( barrierColor: Colors.black.withAlpha(1),
                backgroundColor: Colors.transparent, isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(height: 600,child: WebViewRollet(name: getLang( context: context, key: "Terms_Service"), link: 'https://spinner.hakini.live/?token=${user.userinfo?.rememperToken}',));
                });
          },child: Image.asset(Images.Rollet,height: 60, width: 60,)),




          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(onTap: (){

                Room.ChairsRoom.clear();
                Room.UserIds.clear();
                Room.Currentroom?.chairs?.forEach((element) {
                  if(element.userId!=null&& element.user!=null){
                    Room.ChairsRoom.add(element);

                  }
                });
                Room. UserIds.clear();
                gits.GiftList.clear();
                gits.Cost=0;
                showModalBottomSheet(barrierColor:Colors.transparent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
                  context: context,
                  builder: (context) {
                    return const LuckyTabBar();
                  },
                );
             // }

            },child: Image.asset(Images.LuckyPrize,height: 50, width: 50,)),
          ),


        ],
      ),
    );
  }
}
