

import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/dimensions.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/RoomUserProfile.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/CircleProgress.dart';


class SupervisorsTabBar extends StatelessWidget  {
  const SupervisorsTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return      Container(width: SizeConfig.screenWidth!,height:  SizeConfig.screenHeight,
      decoration: BoxDecoration( color: Colors.black,borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25), )),
      child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          Text(getLang(context: context,key: "Admins"),style: style1),
          SizedBox(height: 20,),
             Expanded(
            child: ListView.builder(itemCount:Room.Currentroom?.supervisor?.length ,scrollDirection: Axis.vertical,itemBuilder: (context, index){
              if(user.checkuserkind(context: context,id:Room.Currentroom?.supervisor?[index].user?.id )){
                return SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child:Room.Currentroom?.supervisor?[index].user?.id==null?SizedBox():InkWell(onTap: (){

                },child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        user.GetShoweduserProfile(Room.Currentroom?.supervisor?[index].user);
                        navigateTo(context: context, screen: ShowUserProfile());
                      },
                      child: Row(
                        children: [
                          CircleAvatar(backgroundColor: Colors.transparent,radius: 25,  backgroundImage: CachedNetworkImageProvider(  Room.Currentroom?.supervisor?[index].user?.image??'')),
                      SizedBox(width: 10,),
                          UserSideInfoWidgets(UserDate: Room.Currentroom?.supervisor?[index].user,TextColor: Colors.white,)
                        ],
                      ),
                    ),


                    Spacer(),
                    InkWell(onTap: (){
                      Dialogs().showdialog(context: context, tittle: 'tittle', content: getLang(context: context,key: "Removesupervisors"), buttontext: getLang(context: context, key: "Yes"), onTap:() {
                        Navigator.pop(context);

                        Room.RemovesupervisorsRoom(context: context,userid:  Room.Currentroom?.supervisor?[index].user?.id );
                      });
                    },child: Icon(Icons.clear,color: Colors.white,size: 25,)),

                    SizedBox(width: 10,),
                  ],
                )),
              );
            }
                ,),
          ),
        ],
      ),
    );
  }
}
