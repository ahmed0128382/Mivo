import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Family/FamilyProfileScrean.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';
class FamilyRankWidget extends StatelessWidget {

  List<LeaderboardFamilymodel>? FamilyList;

  FamilyRankWidget({this.FamilyList});

  @override
  Widget build(BuildContext context) {
   FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);

    return    CustomScrollView(slivers: [
      SliverToBoxAdapter(child:Container(color: Colors.transparent,child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [

          Expanded(child:InkWell(onTap: (){
    if ( (FamilyList?.length??0) >2){
      Family.GetFamily(Val: FamilyList?[2].Family);
      navigateTo(context: context,screen: FamilyProfileScrean());
    }

          },
            child: Padding(
              padding: const EdgeInsets.only(top: 60,),
              child: Stack(
                children: [
                  Container(height: 180,decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Images.rank1),fit: BoxFit.cover)),),
                  if ((FamilyList?.length??0) >2)   Align(alignment: Alignment.topCenter,
                    child: Container(width: 100,
                      child: Column( mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LeaderboardFrame(image: FamilyList?[2].Family?.image,Frame: Images.framerank2,),
                          Text(Helper().CutName5(name:FamilyList?[2].Family?.name??'') ,style: Namestyle2.copyWith(fontSize: 13),),

                          Container(child: Center(child: Text('${Helper().k_m_b_generator(int.parse(FamilyList?[2].coins??'0')).toString()} 🔥',style: style1.copyWith(height: 1,fontSize: 10),)),height: 20,width: 60,decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),color: Colors.black45,border: Border.all(width:1,color: Colors.yellowAccent)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

              ),
            ),
          )),
          SizedBox(width: 5,),
          Expanded(child: InkWell(onTap: (){
            if ( (FamilyList?.length??0) >0 ){
              Family.GetFamily(Val: FamilyList?[0].Family);
              navigateTo(context: context,screen: FamilyProfileScrean());
            }


          },
            child: Padding(
              padding: const EdgeInsets.only(top: 30,),
              child: Stack(
                children: [
                  Container(height: 180,decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Images.rank2),fit: BoxFit.cover)),),
                  if ( (FamilyList?.length??0) >0 )  Align(alignment: Alignment.topCenter,
                    child: Container(width: 100,
                      child: Column( mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LeaderboardFrame(image:FamilyList?[0].Family?.image,Frame: Images.framerank1,),
                          Text(Helper().CutName5(name:FamilyList?[0].Family?.name??'') ,style: Namestyle2.copyWith(fontSize: 13),),

                          Container(child: Center(child: Text('${Helper().k_m_b_generator(int.parse(FamilyList![0].coins??'0')).toString()} 🔥',style: style1.copyWith(height: 1,fontSize: 10),)),height: 20,width: 60,decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),color: Colors.black45,border: Border.all(width:1,color: Colors.yellowAccent)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

              ),
            ),
          )),
          SizedBox(width: 5,),
          Expanded(child: InkWell(onTap: (){
            if ( (FamilyList?.length??0) >1){
              Family.GetFamily(Val: FamilyList?[1].Family);
              navigateTo(context: context,screen: FamilyProfileScrean());
            }


          },
            child: Padding(
              padding: const EdgeInsets.only(top: 60,),
              child: Stack(
                children: [
                  Container(height: 180,decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage(Images.rank3),fit: BoxFit.cover)),),
                  if ( (FamilyList?.length??0) >1 )  Align(alignment: Alignment.topCenter,
                    child: Container(width: 100,
                      child: Column( mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LeaderboardFrame(image:FamilyList?[1].Family?.image,Frame: Images.framerank3,),
                          Text( Helper().CutName5(name:FamilyList?[1].Family?.name??''),style: Namestyle2.copyWith(fontSize: 13),),

                          Container(child: Center(child: Text( '${Helper().k_m_b_generator(int.parse(FamilyList?[1].coins??'0')).toString()} 🔥',style: style1.copyWith(height: 1,fontSize: 10),)),height: 20,width: 60,decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),color: Colors.black45,border: Border.all(width:1,color: Colors.yellowAccent)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

              ),
            ),
          )),
        ]),
      ),) ,),
      SliverToBoxAdapter(child:Column(
        children:List.generate((FamilyList?.skip(3).length)??0 , (index){
          LeaderboardFamilymodel? dailysupporter= FamilyList?.skip(3).toList()[index];
          return   Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(onTap: (){
              Family.GetFamily(Val: dailysupporter?.Family);
              navigateTo(context: context,screen: FamilyProfileScrean());
            },
              child: Container(height: 60,width: SizeConfig.screenWidth, child: Row(mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width : 15,),
                  Text((index+4).toString(),style: style1.copyWith(color:Color(0xFFFFD700),fontSize: 26,height: 1 ),),
                  const SizedBox(width : 20,),
                  ClipPath(
                    clipper:HexagonalClipper(reverse: true),
                    child: Container(height: 50,width: 50,decoration: BoxDecoration(image: DecorationImage(image: CachedNetworkImageProvider(
                        dailysupporter?.Family?.image??''),fit: BoxFit.cover), ),
                    ),
                  ),
                  const SizedBox(width : 15,),
                  Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Helper().CutName(dailysupporter?.Family?.name??''),style: Namestyle2.copyWith( height: 1,fontSize: 13 ) ),
                      const SizedBox(height: 10,),
                      Text(Helper().CutName(dailysupporter?.Family?.describtion??'')??getLang(context: context, key: "No_Description"),style: style1.copyWith( height: 1,fontSize: 13, ),),
                    ],
                  ),
                  Spacer(),
                  Container(child: Center(child: Text('${Helper().k_m_b_generator(int.parse(dailysupporter?.coins??'0')).toString()} 🔥',style: style1.copyWith(height: 1, fontSize: 13),)),height: 30,width: 60,decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),color: Colors.black45,border: Border.all(width:1,color: Colors.yellowAccent)),
                  ),
                  const SizedBox(width : 15,),
                ],
              )),
            ),
          );
        }),
      )    )
    ],);
  }
}
