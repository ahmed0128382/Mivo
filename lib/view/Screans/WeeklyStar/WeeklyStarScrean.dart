import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/Screans/WeeklyStar/TopRowRank.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
class WeeklystarScrean extends StatefulWidget {
  const WeeklystarScrean({Key? key}) : super(key: key);

  @override
  State<WeeklystarScrean> createState() => _WeeklystarScreanState();
}

class _WeeklystarScreanState extends State<WeeklystarScrean> {
  int ShowStarState=0;
  updatestate(val){
    setState(() {
      ShowStarState=val;
    });
  }
  //                                    Text('${(DateTime.parse(Vips.MyVips[index].createdAt??'').difference(DateTime.now()).inDays==0?1:DateTime.parse(Vips.MyVips[index].createdAt??'').difference(DateTime.now()).inDays).toString()} Days Reminder',style:style5.copyWith(color: whitecolor,fontSize: 16),),
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return   Scaffold(backgroundColor:  const Color(0xFF0d0d0d),
      appBar: AppBar(backgroundColor:   const Color(0xFF0d0d0d),title:   Text('Weekly Star',style: style1,),centerTitle: true,automaticallyImplyLeading: true,iconTheme: const IconThemeData(color:Colors.white)),
      body: CustomScrollView(physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: Image.asset('assets/image/bg_guild_rank_of_week.JPG'),),
          SliverToBoxAdapter(child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 30,),
              Expanded(child: GestureDetector(onTap: () {
                updatestate(0);
              },child: Image.asset(ShowStarState==0?'assets/image/Supporterweek.png':'assets/image/Supporterblackweek.png'))),
              const SizedBox(width: 30,),
              Expanded(child: GestureDetector(onTap: () {
                updatestate(1);
              },child: Image.asset(ShowStarState==1?'assets/image/supportedweek.png':'assets/image/supportedweekblack.png'))),
              const SizedBox(width: 30,),
            ],
          ),),
          const SliverPadding(padding: const EdgeInsets.symmetric(vertical: 10)),
      if(Room.WeeklyStar!=null)    SliverToBoxAdapter(child: Center(child: Text("${intl.DateFormat('ddMMM  -').format(DateTime.parse(Room.WeeklyStar?.starttime??'' ))}" "${intl.DateFormat('  ddMMM').format(DateTime.parse(Room.WeeklyStar?.endtime??'' ))}" ,style: const TextStyle(color:const Color(0xFFffce63) ),))),
          const SliverPadding(padding: const EdgeInsets.symmetric(vertical: 10)),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height:  20,),
                      Row(
                        children: [
                          const SizedBox(width: 10,),
                          if((Room.WeeklyStar?.gifts?.length??0)>1)    Expanded(child: Column(mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(alignment: Alignment.center,children: [
                                Image.asset('assets/image/weeklystar.png'),
                                CachedNetworkImage(imageUrl: Room.WeeklyStar?.gifts![1].image??'',height: 40,)

                              ],),
                              Text(Room.WeeklyStar?.gifts![1].name??'',style: const TextStyle(fontSize: 10,color: const Color(0xFFffc401)),),
                              Row(mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(Images.coins,height: 10,) ,
                                  const SizedBox(width: 2,),
                                  Text(Room.WeeklyStar?.gifts![1].price.toString()??'',style: const TextStyle(fontSize: 10,color: Colors.white70),),
                                ],
                              )
                            ],
                          )),
                          const SizedBox(width: 20,),
                          if((Room.WeeklyStar?.gifts?.length??0)>0)    Expanded(child: Column(mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(alignment: Alignment.center,children: [
                                Image.asset('assets/image/weeklystar.png'),
                               CachedNetworkImage(imageUrl: Room.WeeklyStar?.gifts![0].image??'',height: 40,)

                              ],),
                                   Text(Room.WeeklyStar?.gifts![0].name??'',style: const TextStyle(fontSize: 10,color: const Color(0xFFffc401)),),
                                 Row(mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(Images.coins,height: 10,) ,
                                  const SizedBox(width: 2,),
                                  Text(Room.WeeklyStar?.gifts![0].price.toString()??'',style: const TextStyle(fontSize: 10,color: Colors.white70),),
                                ],
                              )
                            ],
                          )),
                          const SizedBox(width: 20,),
                          if((Room.WeeklyStar?.gifts?.length??0)>2)    Expanded(child: Column(mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(alignment: Alignment.center,children: [
                                Image.asset('assets/image/weeklystar.png'),
                                CachedNetworkImage(imageUrl: Room.WeeklyStar?.gifts![2].image??'',height: 40,)

                              ],),
                              Text(Room.WeeklyStar?.gifts![2].name??'',style: const TextStyle(fontSize: 10,color: const Color(0xFFffc401)),),
                              Row(mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(Images.coins,height: 10,) ,
                                  const SizedBox(width: 2,),
                                  Text(Room.WeeklyStar?.gifts![2].price.toString()??'',style: const TextStyle(fontSize: 10,color: Colors.white70),),
                                ],
                              )
                            ],
                          )),
                          const SizedBox(width: 10,),
                        ],
                      ),
                      const SizedBox(height:  20,),
                      Image.asset('assets/image/job132-nu-25b.png',width: 130),
                      const SizedBox(height:  20,),
                  if(ShowStarState==0)    Row(children: [
                        if((Room.WeeklyStar?.supporters?.length??0)>2) TopRowRankWidget(image: 'assets/image/ic_contributor_rank_top_three.png',Leader:Room.WeeklyStar?.supporters![2] ),
                         if((Room.WeeklyStar?.supporters?.length??0)>0)TopRowRankWidget( image:'assets/image/ic_contributor_rank_top_one.png' ,Leader:Room.WeeklyStar?.supporters![0]  ),
                        if((Room.WeeklyStar?.supporters?.length??0)>1) TopRowRankWidget(image: 'assets/image/ic_contributor_rank_top_two.png',Leader:Room.WeeklyStar?.supporters![1]  ),
                      ], ),
                      if(ShowStarState==1)
                        Row(children: [
                          if((Room.WeeklyStar?.supporteds?.length??0)>2) TopRowRankWidget(image: 'assets/image/ic_contributor_rank_top_three.png',Leader:Room.WeeklyStar?.supporteds![2] ),
                          if((Room.WeeklyStar?.supporteds?.length??0)>0)TopRowRankWidget( image:'assets/image/ic_contributor_rank_top_one.png' ,Leader:Room.WeeklyStar?.supporteds![0]  ),
                          if((Room.WeeklyStar?.supporteds?.length??0)>1) TopRowRankWidget(image: 'assets/image/ic_contributor_rank_top_two.png',Leader:Room.WeeklyStar?.supporteds![1]  ),
                        ], ),
                        const SizedBox(height:  20,),
                      Image.asset('assets/image/df.png',width: 130),
                      const SizedBox(height:  20,),
                      if(ShowStarState==0)    Column(
                        children: List.generate(Room.WeeklyStar?.supporters?.length??0, (index) =>Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                             onTap: () {
                               if(Room.WeeklyStar?.supporters![index].user?.id!=user.userinfo?.id){
                                 user.GetShoweduserProfile(Room.WeeklyStar?.supporters![index].user);
                                 navigateTo(context: context, screen: ShowUserProfile());
                               }

                             },
                            child: Row(
                              children: [
                                Text((index+1).toString(),style: style1.copyWith(fontSize: 10)),
                                const SizedBox(width: 8),
                                CircleAvatar(backgroundColor: Colors.transparent,radius: 23,backgroundImage: CachedNetworkImageProvider(Room.WeeklyStar?.supporters![index].user?.image??''),),
                                const SizedBox(width: 5),
                                UserSideInfoWidgets(UserDate:Room.WeeklyStar?.supporters![index].user,TextColor: Colors.white70,showdescr: 1,),
                                const Spacer(),
                                Row(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(Room.WeeklyStar?.supporters![index].coins??'' ,style: style7.copyWith(height: 1,fontSize:10)),
                                    const SizedBox(width: 5,),
                                    Image.asset(Images.coins,width: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                      if(ShowStarState==1)    Column(
                        children: List.generate(Room.WeeklyStar?.supporteds?.length??0, (index) =>Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              if(Room.WeeklyStar?.supporteds![index].user?.id!=user.userinfo?.id){
                                user.GetShoweduserProfile(Room.WeeklyStar?.supporteds![index].user);
                                navigateTo(context: context, screen: ShowUserProfile());
                              }

                            },
                            child: Row(
                              children: [
                                Text((index+1).toString(),style: style1.copyWith(fontSize: 10)),
                                const SizedBox(width: 8),
                                CircleAvatar(backgroundColor: Colors.transparent,radius: 23,backgroundImage: CachedNetworkImageProvider(Room.WeeklyStar?.supporteds![index].user?.image??''),),
                                const SizedBox(width: 5),
                                UserSideInfoWidgets(UserDate:Room.WeeklyStar?.supporteds![index].user,TextColor: Colors.white70,showdescr: 1,),
                                const Spacer(),
                                Row(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(Room.WeeklyStar?.supporteds![index].coins??'' ,style: style7.copyWith(height: 1,fontSize:10)),
                                    const SizedBox(width: 5,),
                                    Image.asset(Images.coins,width: 10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                      const SizedBox(height:  20,),
                    ],
                  ),
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),border: Border.all(color: const Color(0xFFffc401).withOpacity(0.3)))),
          ),),
          const SliverPadding(padding: const EdgeInsets.symmetric(vertical: 10)),
            SliverToBoxAdapter(child: Directionality(textDirection: TextDirection.rtl,child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('1. سيكون هناك 3 هدايا مختلفة في كل أسبوع. استلام الهدايا الأسبوعية سيكون لديك فرصة للحصول على ترتيب في القائمة؛\n2. سيحصل أكثر 3 مستلمين للهدية الأسبوعية و اكثر داعمين على مكافآت؛ سيتم إرسال شارة النجم الأسبوعي لهم مع نهايه المسابقه، وسوف تكون الشارة صالحة لمدةأسبوع واحد؛\n3. يتم حساب بيانات قائمة نجوم الهدايا الأسبوعية' ,style: TextStyle(color:Color(0xFFffce63),fontSize: 12 ) ),
          )),)
        ],
      ),
    );
  }
}
