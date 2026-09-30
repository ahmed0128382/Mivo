
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';

import 'package:ahlachat/util/SizeConfig.dart';

import 'package:ahlachat/util/styles.dart';


import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class InBoxRoom extends StatelessWidget {
  const InBoxRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    return Container(decoration: BoxDecoration(color: whitecolor,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )),height: SizeConfig.screenHeight!/2,width: SizeConfig.screenWidth!,
        child:Column(
          children: [
            InkWell(onTap: (){
            Navigator.pop(context);
            },child: Container(width: SizeConfig.screenWidth!,child: Container(decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(Room.Currentroom?.animateimage??''),fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: InkWell(onTap: (){
                      Navigator.pop(context);
                      },child: Icon(Icons.cancel,size: 30,color:  whitecolor,)),
                    ),
                    Text(getLang(context: context, key: "Chat_List"),style: style2.copyWith(color: whitecolor),),

                  ],
                ),
              ),
            ) ,decoration: BoxDecoration(color: Colors.grey.shade300,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )),)),
            Expanded(child: MessageScrean(kind: 0,)),
          ],
        ),




    );
  }
}
