import 'package:ahlachat/view/widgets/CircleProgress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/player.dart';

import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/SizeConfig.dart';
import '../../../util/app_constants.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import '../../../viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import '../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
class FollowedRoomScrean extends StatelessWidget {
  const FollowedRoomScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);

    return Scaffold(      appBar: AppBar(iconTheme: IconThemeData(color:MainColor),centerTitle: true,elevation: 0,title: Text(getLang(context: context, key: "Followed_Room"),style: style6.copyWith(fontSize: 19,color: MainColor),)),

   body:    !Rooms.showloading46?Center(child: CustomeCircleProgress()) :Padding(
     padding: const EdgeInsets.all(8.0),
     child: Rooms.FollowedRooms.length==0?Text(getLang(context: context, key: "No_results"),style: style6.copyWith(fontSize: 20)):ListView.builder(itemCount: Rooms.FollowedRooms.length,itemBuilder: (context, index) => Padding(
       padding: const EdgeInsets.only(bottom: 5,top: 5),
       child: InkWell(onTap:(){

         Rooms.EnterRoom(context: context,id:  Rooms.FollowedRooms[index].id,adminId:  Rooms.FollowedRooms[index].adminId);
       } ,
         child: Container(width: SizeConfig.screenWidth!,child: Row(
           children: [
             CircleAvatar(backgroundColor: whitecolor,radius: 25,backgroundImage: CachedNetworkImageProvider(Rooms.FollowedRooms[index].image??Images.profilephoto)),
             const  SizedBox(width: 5,),
             Column(crossAxisAlignment: CrossAxisAlignment.start,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text(Rooms.FollowedRooms[index].name??'',style: style5),
                     const SizedBox(width: 5,),
                     if(Rooms.Currentroom?.id==Rooms.FollowedRooms[index].id)    SVGASimpleImage( assetsName: Images.live,)
                   ],
                 ),
                 Center(child:Text('ID : ${Rooms.FollowedRooms[index].RoomID??''}',style: style6.copyWith(color: Colors.black45, fontWeight: FontWeight.w600))),
               ],
             )
           ],
         )),
       ),
     ),),
   ),
    );
  }
}
