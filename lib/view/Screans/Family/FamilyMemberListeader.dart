import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class FamilyMemberListLeader extends StatelessWidget {
  List<Leaderboardusermodel> ?LeaderList;

  FamilyMemberListLeader({required this.LeaderList});

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    return  CustomScrollView(   physics: BouncingScrollPhysics(),
      slivers: [

        SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
        if((LeaderList?.length??0)>0)   SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(color: Colors.transparent,borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft:Radius.circular(20), )),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children:List.generate((LeaderList?.length)??0 , (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(onTap:(){
                      user.GetShoweduserProfile(LeaderList![index].user);
                      navigateTo(context: context,screen: ShowUserProfile());

                    },
                      child: Container( color: Colors.transparent,child: Row(
                        children: [
                          Container(width: 20,child: Center(child: Text((index+1).toString(),style: TextStyle(color: Colors.white),))),
                          SizedBox(width: 5,),
                          CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: CachedNetworkImageProvider(LeaderList![index].user?.image??''),),
                          SizedBox(width: 5,),
                          UserSideInfoWidgets(UserDate: LeaderList![index].user,TextColor: Colors.white),
                          Spacer(),
                          Row(
                            children: [
                              Text( Helper().k_m_b_generator(int.parse(LeaderList![index].coins??''))  ,style: style7.copyWith(height: 1,fontSize:12,fontWeight: FontWeight.normal,color:  Colors.white)),
                              SizedBox(width: 5,),
                              Image.asset(Images.coins,width: 13),
                            ],
                          ),
                          SizedBox(width: 5,),
                        ],
                      )),
                    ),
                  )),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
