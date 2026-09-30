import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/Localization.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
class FriendsScrean extends StatelessWidget {
  const FriendsScrean({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    LoginViewmodel user=Provider.of<LoginViewmodel>(context, listen: true);
    return Scaffold( appBar: AppBar( backgroundColor: Colors.transparent,iconTheme: IconThemeData(color: Colors.black), centerTitle: false,elevation: 0,title: Text(getLang(context: context,key: "Friends"),style: style6.copyWith(fontSize: 19,color:Colors.black87),)),


      body: SingleChildScrollView(
        child: Column(children: List.generate(Follow.Friends.length, (index) =>InkWell( onTap:(){


            user.GetShoweduserProfile( Follow.Friends[index]);


          navigateTo(context: context,screen: ShowUserProfile());

        },
          child: Container(child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                CircleAvatar(backgroundColor: Colors.transparent,radius: 30,backgroundImage: CachedNetworkImageProvider(Follow.Friends[index].image??'')),

                 SizedBox(width: 6,),
                UserSideInfoWidgets(UserDate:  Follow.Friends[index]),
                Spacer(),
                InkWell(onTap: (){
                  Follow. RemoveFollow2(context: context,followid:Follow.Friends[index].id );
                },child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(15)),child: Center(child: Text(getLang(context: context, key: "UnFollow") ,style: style6.copyWith(height: 1,color: whitecolor))),height: 25 ,width: 60,))


              ],
            ),
          ) ),
        )),),
      ),
    );
  }
}
