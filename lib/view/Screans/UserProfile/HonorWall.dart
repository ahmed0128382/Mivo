import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';

import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowCollectedGift.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/view/Screans/UserProfile/showMoreHonorsScrean.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HonorWallWidget extends StatelessWidget {
  const HonorWallWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
      child: CustomScrollView(      physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text('العلاقات',style: style2.copyWith(fontSize: 14,height: 1)),
                Spacer(),
                InkWell(onTap: () {

                },
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                    children:   [
                      // Text(getLang(context: context,key: "More"),style:   style2.copyWith(fontSize: 14,color: Colors.black26,height: 1)),
                      // Icon(Icons.navigate_next_outlined,color: Colors.black26,size: 20,)
                    ],
                  ),
                )
              ],
            ),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),

          SliverToBoxAdapter(child: Column(children:List.generate(user.userProfileData?.Relations?.length??0, (index) => InkWell(
            onTap: () {
              // if(user.userProfileData?.id==user.userProfileData?.Relations![index].user?.id){
              //   user.GetShoweduserProfile(user.userProfileData?.Relations![index].user);
              //   navigateTo(context: context, screen: ShowUserProfile());
              // }
              // user.GetShoweduserProfile(user.userProfileData?.Relations![index].user);
              // navigateTo(context: context, screen: ShowUserProfile());
            },
            child: Container(width: SizeConfig.screenHeight,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(user.userProfileData?.Relations![index].items?.image??''),fit: BoxFit.fill, ),border: Border.all(color: Colors.grey.withOpacity(0.2)),borderRadius: BorderRadius.circular(10)),child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(mainAxisSize: MainAxisSize.min,
                        children: [
                          FrameRelationsProfile(image:user.userProfileData?.Relations![index].user?.image,Frame: user.userProfileData?.Relations![index].user?.frameimage ),

                          Text(user.userProfileData?.Relations![index].user?.name??'',style: style1.copyWith(height:1,fontSize: 12),),

                        ],
                      ),
                      Column(mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 15,),
                          Text('CP',style: style1.copyWith(fontSize:12,height: 0 ),),
                          Image.asset('assets/image/cp_tray_3.png',height: 50,width: 50,),
                          Text( '${Helper().k_m_b_generator(int.parse(user.userProfileData?.Relations![index].karisma.toString()??'0')).toString()} 🔥'
                              ,style: style1.copyWith(fontSize: 12,height: 1)),

SizedBox(height: 10,),
                          Text(Helper().getdayago( time:  user.userProfileData?.Relations![index].createdAt),style: style1.copyWith(fontSize: 12,height: 1))
                        ],
                      ),
                      Column(mainAxisSize: MainAxisSize.min,
                        children: [
                          FrameRelationsProfile(image: user.userProfileData?.Relations![index].anotheruser?.image,Frame: user.userProfileData?.Relations![index].anotheruser?.frameimage ),
                          Text(user.userProfileData?.Relations![index].anotheruser?.name??'',style: style1.copyWith(height: 1,fontSize: 12),),

                        ],
                      ),
                    ],
                  ),

                ],
              ),

            )),
          ) )),),


          SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text(getLang(context: context,key: "Models"),style: style2.copyWith(fontSize: 14,height: 1)),
                Spacer(),
                InkWell(onTap: () {
navigateTo(context: context, screen: MoreHonorsScrean());
                },
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                    children:   [
                      Text(getLang(context: context,key: "More"),style:   style2.copyWith(fontSize: 14,color: Colors.black26,height: 1)),
                      Icon(Icons.navigate_next_outlined,color: Colors.black26,size: 20,)
                    ],
                  ),
                )
              ],
            ),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio:1.1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),borderRadius: BorderRadius.circular(20)),child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(imageUrl: user.userProfileData?.Models![index].AchiveModel?.image??'', ),
                )) ;
              },childCount:(user.userProfileData?.Models?.length??0)>8?8:user.userProfileData?.Models?.length,
            ),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(vertical:10)),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text(getLang(key:   "gifts",context: context),style: style2.copyWith(fontSize: 14,height: 1)),

              ],
            ),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text(getLang(context: context,key: "She_recived"),style: styleb45.copyWith(fontSize: 13,height: 1)),
                Spacer(),
                InkWell(onTap: () {
                  navigateTo(context: context, screen: CollectedGiftScrean(GiftList: user.userProfileData?.giftscollect??[],));
                },
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                    children:   [
                      Text(getLang(context: context,key: "More"),style:   style2.copyWith(fontSize: 14,color: Colors.black26,height: 1)),
                      Icon(Icons.navigate_next_outlined,color: Colors.black26,size: 20,)
                    ],
                  ),
                )
              ],
            ),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio:1.1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),borderRadius: BorderRadius.circular(20)),child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(imageUrl: user.userProfileData?.giftscollect![index].gift?.image??'', ),
                )) ;
              },childCount:(user.userProfileData?.giftscollect?.length??0)>8?8:user.userProfileData?.giftscollect?.length,
            ),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text(getLang(context: context,key: "She_Send"),style: styleb45.copyWith(fontSize: 13,height: 1)),
                Spacer(),
                InkWell(onTap: () {
                  navigateTo(context: context, screen: CollectedGiftScrean(GiftList: user.userProfileData?.giftssent??[],));
                },
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                    children:   [
                      Text(getLang(context: context,key: "More"),style:   style2.copyWith(fontSize: 14,color: Colors.black26,height: 1)),
                      const Icon(Icons.navigate_next_outlined,color: Colors.black26,size: 20,)
                    ],
                  ),
                )
              ],
            ),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(vertical: 5)),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio:1.1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.2)),borderRadius: BorderRadius.circular(20)),child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(imageUrl: user.userProfileData?.giftssent![index].gift?.image??'', ),
                )) ;
              },childCount:(user.userProfileData?.giftssent?.length??0)>8?8:user.userProfileData?.giftssent?.length,
            ),
          ),
        ],
      ),
    );
  }
}
