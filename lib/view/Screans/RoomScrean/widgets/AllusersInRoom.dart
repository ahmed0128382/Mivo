

import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class AlluserInRoom extends StatelessWidget {
  const AlluserInRoom({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel  Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Container(decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )) ,width: SizeConfig.screenWidth!,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text(getLang(context: context, key: "User_Join"),style: style4.copyWith(color: Colors.white),),
              Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,children:List.generate(Room.joinuserRooms.length, (index) => Column(
                children: [
                  if(user.userinfo?.id.toString()!=Room.joinuserRooms[index].user?.id.toString()&&Room.joinuserRooms[index].user?.Hidden==0) Padding(
                    padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: Colors.transparent,radius: 16,backgroundImage: CachedNetworkImageProvider (Room.joinuserRooms[index].user?.image??AppConstants.User_Profile) ),
                        SizedBox(width: 5,),
                        UserSideInfoWidgets(UserDate: Room.joinuserRooms[index].user,TextColor: Colors.white),

                        const Spacer(),
                    if( Room.joinuserRooms[index].user?.id!=Room.Currentroom?.adminId)  if((Room.checkadmin(context: context)||(Room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString())??false))&&!(Room.Currentroom?.supervisorsId?.contains(Room.joinuserRooms[index].user?.id.toString())??false))InkWell(onTap: (){
                        Navigator.pop(context);
                         Room.KickJoinadminuser(user_id:Room.joinuserRooms[index].user?.id??'',context: context );
                        },child: Icon(Icons.exit_to_app,color:Room.joinuserRooms[index].user?.ginder=='0'?Colors.blueAccent:Colors.pinkAccent)),
                        const SizedBox(width: 10),

                           InkWell(onTap:(){
                             Navigator.pop(context);
                             user.GetShoweduserProfile(Room.joinuserRooms[index].user);
                              Navigator.pushNamed(context,AppConstants.ShowUser_Profile);

                           } ,child: const Icon(Icons.person,color: whitecolor2,size: 25,)),


                      ],
                    ),
                  ),
                ],
              )),

              ),
              SizedBox(height: 10,),
            ],
          ),
        )



    );
  }
}
