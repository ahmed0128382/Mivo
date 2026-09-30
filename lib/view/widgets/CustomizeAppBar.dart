import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:provider/provider.dart';


class CustomizeAppbar extends StatelessWidget implements PreferredSizeWidget{

String? tittle;
bool  ? autopop;
CustomizeAppbar({this.tittle,  this.autopop});

  @override
  Widget build(BuildContext context) {


    return Directionality(textDirection: TextDirection.ltr,
      child: AppBar(elevation:0,centerTitle: true,flexibleSpace: Container(
 color: MainColor,
      ),
        title:Text(tittle??"",style: style2.copyWith(color: whitecolor ),),
        automaticallyImplyLeading:  false,
        leading:autopop??false?SizedBox() :InkWell(onTap: ()
        {
          Navigator.pop(context);


          },child: Icon(Icons.arrow_back_ios_sharp,color: whitecolor,)),
      ),
    );
  }


  // TODO: implement preferredSize
  @override
  Size get preferredSize =>   Size.fromHeight(50);
}


class CustomizeChatAppbar extends StatelessWidget implements PreferredSizeWidget{

  String? tittle;
  String? image;
  usermodel?userchat;
 var InBoxid;
  CustomizeChatAppbar({this.tittle,this.image,this.userchat,this.InBoxid});

  @override
  Widget build(BuildContext context) {

    InboxroomViewModel    Inboxrooms= Provider.of<InboxroomViewModel>(context,listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    MomentViewModel   posts=Provider.of<MomentViewModel>(context,listen: true);

    return Directionality(textDirection: TextDirection.ltr,
        child: AppBar(centerTitle: true, backgroundColor: Colors.white,actions: [
            SizedBox(height: 20,
                                          child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                                            Icons.more_vert,
                                            color: Colors.black,
                                          ),
                                              onSelected: (value) {
if(value=='Delete'){
  Inboxrooms.DeleteInboxroom(context: context,inboxid: InBoxid );
}else{
  Inboxrooms.BlockUser(UserId:  user.userProfileData?.id,id:InBoxid );
}

                                                Navigator.pop(context);
// your logic
                                              },
                                              itemBuilder: (BuildContext bc) {
                                                return   [
                                                  PopupMenuItem(
                                                    child: Text(getLang(context: context,key: "Block_User"),style: style6,),
                                                    value: 'Block',
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text(getLang(context: context,key: "Delete_Conv"),style: style6,),
                                                    value: 'Delete',
                                                  ),
                                                ];})),

        ],
        title:InkWell(onTap:(){

          user.GetShoweduserProfile(userchat);
           Navigator.pushNamed(context,'${AppConstants.ShowUser_Profile}');
        } ,
          child: Row(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(backgroundColor: Colors.transparent, backgroundImage: CachedNetworkImageProvider(image??Images.profilephoto),radius: 20),
              const  SizedBox(width: 5,),
              UserSideInfoWidgets(UserDate:userchat ,showdescr: 1,)
            ],
          ),
        ),
        automaticallyImplyLeading: false,
        leading: InkWell(onTap: () {
          Inboxrooms.ExistChatRoom();
          Navigator.pop(context);
        },child: Icon(Icons.arrow_back_ios_sharp,color:Colors.black45,)),
      ),
    );
  }


  // TODO: implement preferredSize
  @override
  Size get preferredSize =>   Size.fromHeight(  SizeConfig.screenHeight!*0.07936);
}
