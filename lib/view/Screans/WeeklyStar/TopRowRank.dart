
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRowRankWidget extends StatelessWidget {
  Leaderboardusermodel? Leader;
  String image;

  TopRowRankWidget({required this.Leader,required this.image});

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return        Expanded(child: Padding(
      padding: const EdgeInsets.only(top: 0),
      child: InkWell(onTap:() {
        if(Leader?.user?.id!=user.userinfo?.id){
          user.GetShoweduserProfile(Leader?.user);
          navigateTo(context: context,screen: ShowUserProfile());
        }


      },
        child: Column(mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20),
             child: Stack(alignment: Alignment.center,children: [
               CircleAvatar(backgroundColor: Colors.transparent,radius:30,backgroundImage: CachedNetworkImageProvider(Leader?.user?.image??''),),
             //  Image.asset('assets/image/ic_gameranking_1.png'),
               Image.asset(image ,height: 75,)
             ],),
           ),

           SizedBox(height: 2,),
           Text(Helper().CutName(Leader?.user?.name??''),style: style7.copyWith(fontWeight: FontWeight.normal,fontSize: 10)),
           SizedBox(height: 2,),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 0),
             child: Row(mainAxisSize: MainAxisSize.min,
               children: [
                 Text( Helper().k_m_b_generator(int.parse(Leader?.coins??''))  ,style: style7.copyWith(height: 1,fontSize:10)),
                 SizedBox(width: 5,),
                 Image.asset(Images.coins,width: 10),
               ],
             ),
           ),

         ],
            ),
      ),
    ));
  }
}
