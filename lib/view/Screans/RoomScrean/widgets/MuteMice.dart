

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/ChairModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/AllBlockedUser.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/InviteToChairScrean/InviteToChairScrean.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class Mutemic extends StatefulWidget  {
  const Mutemic({Key? key}) : super(key: key);
  @override
  _MutemicState createState() => _MutemicState();
}
class _MutemicState extends State<Mutemic>   {
  List<Chairs>rooms=[];
  @override
  void initState() {
    if(mounted){
       RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: false);
      LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
      rooms.clear();
      Room.Currentroom?.chairs?.forEach((element) {
        if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null&&element.userId.toString()!=Room.Currentroom?.adminId.toString()){
          rooms.add(element);
        }
      });
      setState((){});
     }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: true);
    RoomViewmodel  Room =  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Container(decoration: BoxDecoration(color: Colors.transparent,image: DecorationImage(image: CachedNetworkImageProvider(Room.Currentroom?.animateimage??''),fit: BoxFit.cover)),
     child: Column(
      children: [
        const     SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              InkWell(onTap: (){
                Navigator.pop(context);
              },child: Icon(Icons.cancel_outlined,color: whitecolor)),
              const Spacer(),

              const    SizedBox(width: 10,),

            ],
          ),
        ),
        const  SizedBox(height: 10,),
        Container(width: SizeConfig.screenWidth!,
          child:GridView.count(childAspectRatio :1.0,shrinkWrap: true ,cacheExtent: 16.6,physics: NeverScrollableScrollPhysics(),
            crossAxisCount:4,
            crossAxisSpacing:0.8,
            mainAxisSpacing:1,
            children: List.generate(8, (index) {
              return  Align(alignment: Alignment.center,child:InkWell(
                onTap: (){
                  if(Room.Currentroom?.chairs?[index].Lock==0){

                    Room.LockChairUpdate(state: 1, info: Room.Currentroom?.chairs?[index]);
                  }else{
                    Room.LockChairUpdate(state: 0,  info: Room.Currentroom?.chairs?[index]);
                  }
                },
                child: Column(
                  children: [
                 Image.asset(Room.Currentroom?.chairs?[index].Lock==0?Images.Chairs:Images.LockChairs,height: 50,width: 40 ),
                    const       SizedBox(height: 10,),
                 Row(mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Room.Currentroom?.chairs?[index].user!=null?const SizedBox() :Row(
                       children: [
                         Icon(Room.Currentroom?.chairs?[index].Lock==0?Icons.lock_outline_sharp:Icons.lock_open_outlined,color: whitecolor,size: 20,),
                         if(Room.Currentroom?.chairs?[index].Lock==0&&Room.Currentroom?.chairs?[index].userId==null)  SizedBox(width: 10,),
                     if(Room.Currentroom?.chairs?[index].Lock==0&&Room.Currentroom?.chairs?[index].userId==null) InkWell(onTap: (){
                       Navigator.pop(context);
                      Room.InvitedChair.clear();
                       Room.UserIds.clear();
                       Room.Currentroom?.chairs?.forEach((element) {
                         if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null){
                            Room.InvitedChair.add(element.user?.id.toString()??'');

                         }
                       });

                       InviteChairId=Room.Currentroom?.chairs?[index].chairId??'';

                       showModalBottomSheet(barrierColor:Colors.transparent,context: context, shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )), builder: (BuildContext context) {

                         return   InviteToChair();
                       });

                       Room.GetUserJoin(context: context);
                     },child: Icon(Icons.chair,color: whitecolor ,size: 20,)),

                       ],
                     ),
                     Room.Currentroom?.chairs?[index].userId!=null? Icon(Icons.person_outline,color: whitecolor ,size: 30,):SizedBox()
                   ],)

                  ],),));}
            ),), ),
        Expanded(
          child:rooms.length==0?Center(child: Text(getLang(context: context, key: "No_Users_Chair"), style: style1,)):
          ListView.builder(itemCount:rooms.length ,scrollDirection: Axis.vertical,itemBuilder: (context, index) =>
          rooms[index].user?.name==null? const SizedBox():
          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: Row(
                  children: [
                    if(!(Room.Currentroom?.supervisorsId?.contains(rooms[index].user?.id.toString())??false))     InkWell(onTap: (){
                      if(Room.Mutedids.contains(rooms[index].user?.id)){
                        Room.updatemute(context: context,state: 0,user_id: rooms[index].user?.id);
                      }else{
                        Room.updatemute(context: context,state: 1,user_id: rooms[index].user?.id);
                      }
                      Agora.mutebyuid(uid: rooms[index].user?.id,context: context);
                    },child: Icon(Room.Mutedids.contains(rooms[index].user?.id)?Icons.mic_off_outlined:Icons.mic_none,color: whitecolor,size: 19,)),
                    const  SizedBox(width: 20,),
               if(!(Room.Currentroom?.supervisorsId?.contains(rooms[index].user?.id.toString())??false))     InkWell(onTap: (){
                      Dialogs().showdialog(context: context, tittle: '',content: getLang(key: "Sure_Ban",context: context), buttontext: getLang(context: context, key: "Yes"), onTap: (){
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Room.Evictionuser(Userid:rooms[index].user?.id,context: context);
                      });
                    },child: Icon(Icons.exit_to_app,color: whitecolor,size: 19,)),
                    const Spacer(),
   Row(
                      children: [
                        Column(mainAxisAlignment:  MainAxisAlignment.end,
                          crossAxisAlignment:  CrossAxisAlignment.end,
                          children: [
                            Text(rooms[index].user?.name??"",style: style6.copyWith(color: whitecolor2),),


                          ],
                        ),
                        const SizedBox(width: 10,),
                        CircleAvatar(backgroundColor: Colors.transparent,radius: 17,backgroundImage: CachedNetworkImageProvider(rooms[index].user?.image??'')),

                      ],
                    ),
                  ],
                ),
              ),),
        ),
      ],
    ), );
  }
}
