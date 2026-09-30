import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:provider/provider.dart';
class UserEntry extends StatelessWidget {
  const UserEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      width:  Provider.of<GiftsViewModel>(context, listen: true).selected ? 170.0 :0.0 ,
      height: 35.0,
      top:  135.0,
      left: 10.0,
      duration: const Duration(seconds:2),
      curve: Curves.easeIn,
      onEnd: (){
        Provider.of<GiftsViewModel>(context, listen: false).hidpanner();
      },
      child: SingleChildScrollView(scrollDirection:Axis.horizontal ,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 0),
          child:Container( padding: EdgeInsets.all(3),decoration: BoxDecoration(
              image: DecorationImage(image: ExactAssetImage(Images.Entryimage),fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(20)),height: 60.0,width: 160,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[

                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CircleAvatar(backgroundColor: Colors.transparent,radius: 15, backgroundImage: CachedNetworkImageProvider(EnterImage??Images.userphoto),),
                ),
                const SizedBox(width: 5,),
                Text("${Helper().CutName4(name: Entername??'')} ${getLang(context: context,key: "Enter_Room")}  ",style: style1.copyWith(fontSize: 11,color:whitecolor2)),
                const  SizedBox(width: 5,),
              ],
            ),
          )
        ),


      ),
    );
  }
}
