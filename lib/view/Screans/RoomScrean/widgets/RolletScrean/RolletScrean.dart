import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/WebViewScrean.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class RolletRoom extends StatelessWidget {
  const RolletRoom({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    return AnimatedPositioned(
        height:   Room.showloading41? SizeConfig.screenHeight!/1.5:0,
        left:0,
        bottom: 0.0,
        duration: const Duration(milliseconds: 300,),
        curve: Curves.fastOutSlowIn,
        child:  Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )),height:  SizeConfig.screenHeight!/1.5, width: SizeConfig.screenWidth!,
          child:Column(mainAxisSize: MainAxisSize.min,
            children: [
 InkWell(onTap: (){
   Room.hideSpinner41();
 },child: Container(height: 50,width: SizeConfig.screenWidth,color: Colors.green,)),
            Expanded(child: WebViewRollet(name: getLang( context: context, key: "Terms_Service"), link: 'http://spinner.gigochat.live/',)),

            ],
          )




        ));
  }
}
