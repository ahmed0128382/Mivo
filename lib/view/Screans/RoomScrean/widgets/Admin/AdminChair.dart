import 'package:ahlachat/view/Screans/RoomScrean/CollectKarismaUser.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/LeaveChairUser/LeaveChairUser.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Admin/AdminKarisma.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/InviteToChairScrean/InviteToChairScrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/RoomUserProfile.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class AdminChair extends StatelessWidget {
  const AdminChair({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(context,listen: true);

    return   Row(mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Room.Currentroom?.chairs?[8].adminleaved==1||Room.Currentroom?.chairs?[8].user==null?Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Image.asset(Images.Chairs, height: 50,width: 50),
        ):  Container( width:70  ,
          child: InkWell(onTap: (){

            if(user.userinfo?.id.toString()==Room.Currentroom?.adminId.toString()){
              user.userinfoRoom(context: context,id:Room.Currentroom?.chairs?[8].user?.id);
              user.getuserroominfo(user: Room.Currentroom?.chairs?[8].user);
              GlopalbottomSheet(context: context,Screan:const MyProfileInRoom() );

            }
            if(user.userinfo?.id.toString()!=Room.Currentroom?.adminId.toString()&&Room.Currentroom?.chairs?[8].user!=null){
              user.userinfoRoom(context: context,id:Room.Currentroom?.chairs?[8].user?.id);
              user.getuserroominfo(user: Room.Currentroom?.chairs?[8].user);
              GlopalbottomSheet(context: context,Screan: const RoomUserProfile());
            }

          },
            child: Stack( alignment: Alignment.center,children: [
              if(Agora.speakerids.any((element) =>element['uid']==int.parse(Room.Currentroom?.chairs?[8].userId??'0') )&&Room.Currentroom?.chairs?[8].mute==0  )    Positioned(top: 0,
                child: AvatarGlow(
                  glowColor: Colors.tealAccent,
                  glowRadiusFactor: 1.2,glowCount: 2,
                  duration: Duration(milliseconds: 1000),
                  repeat: true,
                  animate: true,
                  child:SizedBox(),
                ),
              ),
              Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  PhotoFrame(image:Room.checkadmin(context: context)?user.userinfo?.image:Room.Currentroom?.chairs?[8].user?.image,Frame:Room.checkadmin(context: context)?user.userinfo?.frameimage:Room.Currentroom?.chairs?[8].user?.frameimage),
                  InkWell(onTap: () {
                    GlopalbottomSheet(context: context,Screan: UserCollectKarismas());

                    Room.GetCollectKarisma(context: context,userid:Room.Currentroom?.chairs?[8].userId ,chairid: Room.Currentroom?.chairs?[8].id);
                  },child: Column(mainAxisSize: MainAxisSize.min,
                    children: [
                     Text(Helper().CutName(Room.Currentroom?.admin?.name??''),style: Namestyle.copyWith(overflow: TextOverflow.ellipsis,fontSize: 12,height: 1,color: whitecolor)),
                    const AdminKarisma()
                    ],
                  )),

                ],
              ),
              Room.Currentroom?.chairs?[8].userId==null? const SizedBox():Align(alignment: Alignment.bottomLeft,child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(20), color: Colors.transparent),child: CircleAvatar(radius: 10,backgroundColor:  Colors. white54, child: Icon(Room.Currentroom?.chairs?[8].mute==0?Icons.mic:Icons.mic_off_outlined,color: whitecolor,size: 15,)))),
              if(user.imoge.any((element) =>element['uid']==int.parse(Room.Currentroom?.chairs?[8].userId??'0') ) )
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(height: 60,width: 60,color: Colors.transparent,child: CachedNetworkImage(imageUrl:  user.imoge.where((element) => element['uid']==int.parse(Room.Currentroom?.chairs?[8].userId??'0')).first['imoge']),),
                )
            ]),
          ),
        ),
   if(Room.Currentroom?.SecondKing==1) Room.Currentroom?.chairs?[9].user==null?
   InkWell(onTap: (){
    if(Room.checkadmin(context: context)||(Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false)){       Room.InvitedChair.clear();
       Room.UserIds.clear();
       Room.Currentroom?.chairs?.forEach((element) {
         if(element.userId!=null&&element.userId.toString()!=user.userinfo?.id.toString()&&element.user!=null){
           Room.InvitedChair.add(element.user?.id.toString()??'');
         }
       });

       InviteChairId=Room.Currentroom?.chairs?[9].chairId??'';

       showModalBottomSheet(barrierColor:Colors.transparent,context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )), builder: (BuildContext context) {

         return   const InviteToChair();
       });

       Room.GetUserJoin(context: context);
     }

     },child: Image.asset(Images.k3, height: 70,width: 70)  )  :
             Container(color: Colors.transparent,width:70,
               child: Stack(alignment:  Alignment.centerLeft ,children: [

                 Align(alignment: Alignment.center,
                   child: InkWell(onTap: (){
                     if(Room.JoinChairLoding){
                       Dialogs().showtoast(getLang(context: context,key: "wait"));
                     }else{
                       if(user.userinfo?.id.toString()==Room.Currentroom?.chairs?[9].user?.id.toString()){

                         user.userinfoRoom(context: context,id:Room.Currentroom?.chairs?[9].user?.id);
                         user.getuserroominfo(user: Room.Currentroom?.chairs?[9].user);
                         GlopalbottomSheet(context: context,Screan:const LeaveChairUser() );

                       }
                       if((Room.Currentroom?.adminId.toString()==user.userinfo?.id.toString()&&Room.Currentroom?.chairs?[9].user!=null)){
                         Room.Chairids=Room.Currentroom?.chairs?[9].chairId;
                         Room.useridchair=Room.Currentroom?.chairs?[9].user?.id ;
                         Room.ChairIndes=9;
                         user.userinfoRoom(context: context,id:Room.Currentroom?.chairs?[9].user?.id );
                         user.getuserroominfo(user: Room.Currentroom?.chairs?[9].user);
                         GlopalbottomSheet(context: context,Screan: const RoomUserProfile());
                       }else if(Room.Currentroom?.chairs?[9].Lock==1){
                         Dialogs().showtoast(getLang(context: context,key: "Chair_lock"));
                       }
                       else if(Room.Currentroom?.adminId.toString()==user.userinfo?.id.toString()){
                         Dialogs().showtoast(getLang(context: context,key: "Canmove_admin"));
                       }
                       else{
                         if( !JoinChairs&&Room.Currentroom?.chairs?[9].userId==null){

                           Room.JoinChair(index: 9,context: context,chairid:Room.Currentroom?.chairs?[9].chairId );
                         }
                         else{

                           if(Room.Currentroom?.chairs?[9].userId.toString()==user.userinfo?.id.toString()){


                             Room.Chairid=Room.Currentroom?.chairs?[9].chairId??'0';
                             Room.Chairidex=9;
                             user.userinfoRoom(context: context,id:user.userinfo?.id.toString());
                             user.getuserroominfo(user: user.userinfo);
                             Room.showSpinner5();
                           }else if(Room.Currentroom?.chairs?[9].userId==null&&JoinChairs){
                             Dialogs().showtoast(getLang(context: context,key: "Cant_move"));
                           } else{

                             user.userinfoRoom(context: context,id:Room.Currentroom?.chairs?[9].user?.id );

                             user.getuserroominfo(user: Room.Currentroom?.chairs?[9].user);

                             GlopalbottomSheet(context: context,Screan: const RoomUserProfile());
                           }
                         }
                       }
                     }

                   },
                     child: Stack(alignment: Alignment.centerLeft,children: [
                       Column(mainAxisSize: MainAxisSize.min,
                         children: [
                           PhotoFrame(image:Room.Currentroom?.chairs?[9].user?.image,Frame:Room.Currentroom?.chairs?[9].user?.frameimage),
                           InkWell(onTap: () {
                             GlopalbottomSheet(context: context,Screan: UserCollectKarismas());

                             Room.GetCollectKarisma(context: context,userid:Room.Currentroom?.chairs?[9].userId,chairid: Room.Currentroom?.chairs?[9].id );
                           },
                             child: Column(
                               children: [
                                 Text(Helper().CutName(Room.Currentroom?.chairs?[9].user?.name??''),style: Namestyle.copyWith(overflow: TextOverflow.ellipsis,fontSize: 12,color: whitecolor)),
                                 Row(
                                   mainAxisSize: MainAxisSize.min,
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Text(Helper().k_m_b_generator(Room.Currentroom?.chairs?[9].Karisma) ,style: style2.copyWith(fontSize:7,color: whitecolor)),
                                     const   SizedBox(width: 3,),
                                     const FaIcon(FontAwesomeIcons.heartCircleCheck,size:8,color: Colors.red),
                                   ],
                                 ),
                               ],
                             ),
                           ),

                         ],
                       ),

                       Room.Currentroom?.chairs?[9].userId==null? const SizedBox():Align(alignment: Alignment.bottomLeft,child: Container(decoration: BoxDecoration( borderRadius: BorderRadius.circular(20), color: Colors.transparent),child: CircleAvatar(radius: 10,backgroundColor:  Colors. white54, child: Icon(Room.Currentroom?.chairs?[9].mute==0?Icons.mic:Icons.mic_off_outlined,color: whitecolor,size: 15,)))),

                       if(user.imoge.any((element) =>element['uid']==int.parse(Room.Currentroom?.chairs?[9].userId??'0') ) )
                         Padding(
                           padding: const EdgeInsets.only(bottom: 30),
                           child: Container(height: 60,width: 60,color: Colors.transparent,child: CachedNetworkImage(imageUrl:  user.imoge.where((element) => element['uid']==int.parse(Room.Currentroom?.chairs?[9].userId??'0')).first['imoge']),),
                         )
                     ]),
                   ),
                 ),

               ],
               ),
             ),

      ],
    );
  }
}
