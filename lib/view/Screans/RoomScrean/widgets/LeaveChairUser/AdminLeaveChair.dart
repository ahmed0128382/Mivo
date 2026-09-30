import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class LeaveAdminChair extends StatelessWidget {
  const LeaveAdminChair({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return  AnimatedPositioned(
        height:Room.showloading8 ? SizeConfig.screenHeight!:0,
        top: 0 ,
        left:0,
        duration: const Duration(milliseconds: 300,),
        curve: Curves.fastOutSlowIn,
        child: Container(height: SizeConfig.screenHeight! ,width: SizeConfig.screenWidth!,color: Colors.black26,child:
        Center(
            child: SingleChildScrollView(
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(onTap: () {
                      Room.changeloading8();

                  },
                    child: Column(crossAxisAlignment:CrossAxisAlignment.center ,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 35,backgroundColor: Colors.blue,child: Icon(Icons.close,size: 35,color: whitecolor),),
                        Text(getLang(context: context,key: "Cancel"),style: style3.copyWith(fontWeight: FontWeight.normal))
                      ],
                    ),
                  ),
                  SizedBox(height: 100,),
                  InkWell(onTap: () {
                   //  Navigator.pop(context);

                       Room.closealltap();
                        Room.LeaveuserChair(context: context);


                  },
                    child: Column(crossAxisAlignment:CrossAxisAlignment.center ,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 35,backgroundColor: Colors.red,child: Icon(Icons.chair,size: 35,color: whitecolor),),
                        Text(getLang(context: context,key: "Leave_Chair"),style:style3.copyWith(fontWeight: FontWeight.normal))
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),


        ));
  }
}
