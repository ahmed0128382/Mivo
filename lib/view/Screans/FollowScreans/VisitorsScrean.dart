import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
class VisitorsScrean extends StatelessWidget {
  const VisitorsScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);
    LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);
    return Scaffold( appBar: AppBar( backgroundColor: Colors.transparent,iconTheme: IconThemeData(color: Colors.black), centerTitle: false,elevation: 0,title: Text(getLang(context: context,key:  "Visitors"),style: style6.copyWith(fontSize: 19,color:Colors.black87),)),
      body: SingleChildScrollView(       physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:List.generate(Follow.visitor.length, (index){
              if(Follow.visitor[index].user?.id==user.userinfo?.id){
                return SizedBox();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () {
                    user.GetShoweduserProfile(Follow.visitor[index].user);
                    navigateTo(context: context,screen: ShowUserProfile());

                  },
                  child: Container(
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: Colors.transparent,radius: 30,backgroundImage: CachedNetworkImageProvider( Follow.visitor[index].user?.image??'')),
                        SizedBox(width: 6,),
                        UserSideInfoWidgets(UserDate: Follow.visitor[index].user,)
                      ],
                    ),
                  ),
                ),
              );
            } ),
          ),
        ),
      )
    );
  }
}
