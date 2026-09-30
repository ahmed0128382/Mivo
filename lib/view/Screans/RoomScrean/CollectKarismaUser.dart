import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
class  UserCollectKarismas extends StatelessWidget {
  const UserCollectKarismas({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RoomViewmodel  Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Container(height: 500,decoration: const BoxDecoration(color: Colors.black,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20) )) ,width: SizeConfig.screenWidth!,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
             Text('المساهمين',style: style1),
              SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: MainAxisAlignment.start,children:List.generate(Room.Collectkarismas.length, (index) =>
                    InkWell(onTap: (
                            () {
                          if(user.userinfo?.id!=Room.Collectkarismas[index].user?.id){
                            Navigator.pop(context);
                            Room.changeloading13();
                            user.GetShoweduserProfile(Room.Collectkarismas[index].user);
                            CheckBlocked=false;
                            Navigator.pushNamed(context,AppConstants.ShowUser_Profile);
                          }

                        }
                    ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20,right: 10,left: 10),
                        child: Row(
                          children: [
                            CircleAvatar(backgroundColor: Colors.transparent,radius: 16,backgroundImage: CachedNetworkImageProvider (Room.Collectkarismas[index].user?.image??AppConstants.User_Profile) ),
                            const SizedBox(width: 5,),
                            UserSideInfoWidgets(UserDate:Room.Collectkarismas[index].user,TextColor: Colors.white,showdescr: 0),
                            const Spacer(),
                            Row(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text( Room.Collectkarismas[index].karisma.toString(),style: style6.copyWith(color: Colors.white,fontSize: 14) ),
                                Image.asset(Images.coins,width: 20,height: 20),
                              ],
                            )


                          ],
                        ),
                      ),
                    )),),
              ),

            ],
          ),
        )



    );
  }
}