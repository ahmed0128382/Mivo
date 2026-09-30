
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserRankWidget extends StatelessWidget {
  Leaderboardusermodel? Leader;
  String image;

  UserRankWidget({required this.Leader,required this.image});

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return        Expanded(child: Padding(
      padding: const EdgeInsets.only(top: 0),
      child: InkWell(onTap:() {
        user.GetShoweduserProfile(Leader?.user);
        navigateTo(context: context,screen: ShowUserProfile());

      },
        child: Container(height: 250,color: Colors.transparent,child: Stack(
          alignment: Alignment.center,
          children: [
            Container( width: 150, decoration: BoxDecoration(color: Colors.transparent,image: DecorationImage(image: ExactAssetImage(image),fit: BoxFit.cover)),),
            Positioned(top: 20,child: Column(mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(backgroundColor: Colors.transparent,radius:35,backgroundImage: CachedNetworkImageProvider(Leader?.user?.image??''),),
                SizedBox(height: 8,),
                Text(Helper().CutName(Leader?.user?.name??''),style: style7.copyWith(fontWeight: FontWeight.normal,fontSize: 13)),
                SizedBox(height: 10,),
                Container(decoration: BoxDecoration(color: Colors.white24,borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                    child: Row(
                      children: [
                        Text( Helper().k_m_b_generator(int.parse(Leader?.coins??''))  ,style: style7.copyWith(height: 1,fontSize:12)),
                        SizedBox(width: 5,),
                        Image.asset(Images.coins,width: 13),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ],
        )),
      ),
    ));
  }
}
