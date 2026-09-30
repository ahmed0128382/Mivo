import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class AllBlockeduserInRoom extends StatelessWidget {
  const AllBlockeduserInRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Container(decoration: BoxDecoration( color: Colors.black,borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10) )),height: SizeConfig.screenHeight!,width: SizeConfig.screenWidth!,
        child:SingleChildScrollView(
          child:Column(
            children: [
              SizedBox(height: 20,),
              Text(getLang(context: context,key: "Banned_members"),style: style1.copyWith(fontSize: 14)),

              SizedBox(height: 20,),
               Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,children:List.generate(Room.BlockeduserRooms.length, (index) => Column(
                children: [
                  if(user.userinfo?.id.toString()!=Room.BlockeduserRooms[index].user?.id.toString()) Padding(
                    padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
                    child: InkWell(onTap:(){
                   Navigator.pop(context);
                      user.userroominfo=Room.BlockeduserRooms[index].user;

                    },
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              user.GetShoweduserProfile(Room.BlockeduserRooms[index].user);
                              navigateTo(context: context, screen: ShowUserProfile());
                            },
                            child: Row(
                              children: [
                                CircleAvatar(backgroundColor: Colors.transparent,radius: 25,  backgroundImage: CachedNetworkImageProvider(  Room.BlockeduserRooms[index].user?.image??'')),
                                SizedBox(width: 10,),
                                UserSideInfoWidgets(UserDate:Room.BlockeduserRooms[index].user,TextColor: Colors.white,)
                              ],
                            ),
                          ),
                          const Spacer(),
 InkWell(onTap: (){
Dialogs().showdialog(context: context, tittle: 'sad', content:'هل انت متأكد من ازاله الحظر عن${Room.BlockeduserRooms[index].user?.name??''}', buttontext: getLang(context: context, key: "Yes"), onTap: (){
  Navigator.pop(context);

Room.unkickuserRoom(context: context,kickid:Room.BlockeduserRooms[index].id );
});

                           },child: Icon(Icons.clear,color:  Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
              ),
            ],
          ),
        )



    );
  }
}
