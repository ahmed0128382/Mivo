import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class GlopalGiftWidget extends StatelessWidget {
  const GlopalGiftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GiftsViewModel  GlopalGift= Provider.of<GiftsViewModel>(context, listen: true);
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return   AnimatedPositioned(
      width: Provider.of<GiftsViewModel>(context, listen: false).GlobalGiftstate?500:0  ,
      // width:0.0 ,
      height: 120.0 ,
      top:  100.0,
      duration: const Duration(seconds: 2,),
      curve: Curves. linear,
      onEnd: (){

        if(GlopalGift.GlobalGiftstate){

          Provider.of<GiftsViewModel>(context, listen: false).HiddeGlobalGift();
        }

      },
      child:InkWell(onTap: () {


        if(GlopalGift.GlopelGiftRoomid==Room.Currentroom?.id.toString()){

        }else{
          Room.EnterRoom3( id:GlopalGift.GlopelGiftRoomid ,context: context);
        }


      },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Align(alignment: Alignment.bottomCenter,child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  SizedBox(width: 5,),
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: Colors.transparent,radius:20,backgroundImage: CachedNetworkImageProvider(  GlopalGift.Sender?.image??Images.userphoto),),
                      Column(mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(Helper().CutName3(name: GlopalGift.Sender?.name??""),style: Namestyle.copyWith(color: Colors.white,fontSize: 13 ),),
                          Text(  "${getLang(context: context,key: "Send")} ${GlopalGift.GlopelGift?.name??''}",style: style6.copyWith(color: Colors.white,fontSize: 13 ),),

                          SizedBox(height: 10,)
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 5,),

                  SizedBox(width: 20,),
                  Container(height:  40,width:40,decoration: BoxDecoration(image:DecorationImage(image: CachedNetworkImageProvider( GlopalGift.GlopelGift?.image??Images.userphoto)) ) ,),
                  SizedBox(width: 10,),
                  Image.asset(Helper().CheckQuantaty(quantity:  GlopalGift.GlopelGiftQuantity),height: 40,width: 40,),

                ],
              ),
            ),decoration:BoxDecoration( image: DecorationImage(image: ExactAssetImage('assets/image/o.png'),fit: BoxFit.cover), borderRadius:  BorderRadius.circular(0)), ),
          )),
        ),
      ),
    );
  }
}
