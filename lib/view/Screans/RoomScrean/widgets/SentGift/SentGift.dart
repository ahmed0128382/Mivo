import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';

import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:provider/provider.dart';

class SendGift extends StatelessWidget {
  const SendGift({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     GiftsViewModel  gift= Provider.of<GiftsViewModel>(context, listen: true);
    return    AnimatedPositioned(
      width:   Provider.of<GiftsViewModel>(context, listen: true).selected2 ?SizeConfig.screenWidth! :0 ,
      height:  150.0 ,
      top:  280.0,


      duration: const Duration(seconds:2),
      curve: Curves.easeIn,
      onEnd: (){
        Provider.of<GiftsViewModel>(context, listen: false).hidpanner2();
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Align(alignment: Alignment.bottomCenter,child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              SizedBox(width: 5,),
              CircleAvatar(backgroundColor: Colors.transparent,radius:20,backgroundImage: CachedNetworkImageProvider(gift.Imagesender ??Images.userphoto),),
              SizedBox(width: 5,),
              Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${gift.giftsender }"  ,style: style1.copyWith(fontSize: 13,color: whitecolor2)),
                  Text("${getLang(context: context,key: "Sent")} ${gift.giftname}"  ,style: style1.copyWith(fontSize: 13,color:whitecolor2)),
                ],
              ),
              SizedBox(width: 20,),
              CircleAvatar(backgroundColor: Colors.transparent,radius: 20,backgroundImage: CachedNetworkImageProvider(gift.gifimage??Images.profilephoto),),
              SizedBox(width: 10,),
              Image.asset(Helper().CheckQuantaty(quantity: gift.quantitys.toString()),height: 40,width: 40,),

              SizedBox(width: 5,),
            ],
          ),height: 50.0,decoration:BoxDecoration(color: Colors.orange,gradient: gradiant5,borderRadius:  BorderRadius.circular(25)), ),
        )),
      ),
    );
  }
}
