import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
class InviteToChair extends StatelessWidget {
  const InviteToChair({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel  Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Container(decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )),height: SizeConfig.screenHeight!,width: SizeConfig.screenWidth!,
        child:SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text(getLang(context: context,key: "Tag_Member"),style: style4.copyWith(color: Colors.white),),
              SizedBox(height: 20,),
              Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,children:List.generate(Room.joinuserRooms.length, (index) =>  Column(
                children: [
                  if(user.userinfo?.id.toString()!=Room.joinuserRooms[index].user?.id.toString()&&!Room.InvitedChair.contains(Room.joinuserRooms[index].user?.id.toString())) Padding(
                    padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
                    child: Row(
                      children: [
                        InkWell(onTap: () {
                          user.GetShoweduserProfile(Room.joinuserRooms[index].user);
                          navigateTo(context: context,screen: ShowUserProfile());

                        },
                          child: Row(
                            children: [
                              CircleAvatar(backgroundColor: Colors.transparent,radius: 16,backgroundImage: CachedNetworkImageProvider (Room.joinuserRooms[index].user?.image??AppConstants.User_Profile) ),
                              SizedBox(width: 5,),
                              UserSideInfoWidgets(UserDate:Room.joinuserRooms[index].user ,TextColor: Colors.white,)
                            ],
                          ),
                        ),


                        const Spacer(),
                        InkWell(onTap: (){      Room.SentInviteChairRoom(context: context,user_id: Room.joinuserRooms[index].user?.id);},child: Icon(Icons.add_link_outlined,color:Colors.white,size: 25,)),
                        const SizedBox(width: 10,),

                      ],
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
