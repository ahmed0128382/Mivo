import 'package:ahlachat/util/Localization.dart';
import 'package:intl/intl.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Levels_ViewModel/Level_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class ModelsScrean extends StatelessWidget {
  const ModelsScrean({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LevelViewModel  Level=Provider.of<LevelViewModel>(context,listen:  true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    return Container(decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/image/VipBackground.png'),fit: BoxFit.cover)),
      child: DefaultTabController(length: 2,
        child: Scaffold( backgroundColor: Colors.transparent, appBar: AppBar(iconTheme: IconThemeData(color: Colors.white),backgroundColor: Colors.transparent,title:   Text(getLang(context: context,key: "Models"),style: style1,),automaticallyImplyLeading: true ),

          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child:   Container(color: Colors.transparent,
                child: TabBar(    indicator: MaterialIndicator(
                  height: 3,
                  topLeftRadius: 0,
                  topRightRadius: 0,
                  bottomLeftRadius: 5,horizontalPadding: 25,
                  bottomRightRadius: 5,color:Color(0xFFeae2be),
                  tabPosition: TabPosition.bottom,
                ),
                  isScrollable: false,
                  labelStyle: style5.copyWith(fontSize: 15) ,
                  unselectedLabelColor: Colors.white24,
                  labelColor:Color(0xFFeae2be),
                  onTap: (val) {},
                    tabs:   [
                      Tab(
                        text: getLang(context: context,key: "Models"),
                      ),
                      Tab(
                        text: getLang(key: "Achivement",context: context),
                      ),

                    ]
                ),
              ),),
SliverPadding(padding: EdgeInsets.symmetric(vertical: 4)),
              SliverFillRemaining(hasScrollBody: true,
               child: TabBarView(
                 children: [
                   GridView.builder(  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 3,
                   childAspectRatio:0.7,
                   mainAxisSpacing: 10,
                   crossAxisSpacing: 10),itemBuilder: (BuildContext ctx, index){
                     return  InkWell(onTap: () {
                       showDialog(context: context,builder: (context) {
                         return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
                           child: Column(mainAxisSize: MainAxisSize.min,
                             children: [
                               Text( Level.Models![index].name?? '',style: style6.copyWith(fontSize: 12,fontWeight: FontWeight.bold),),
                               SizedBox(height: 10,),
                               CachedNetworkImage(imageUrl: Level.Models![index].image??'',height: 120),
                               Image.asset(Images.abg,width: 130),
                               Text(Level.Models![index].description??'',style: style6.copyWith(fontSize: 12,fontWeight: FontWeight.bold),),

                             ],
                           ),
                         ),actions: [
                           InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(  getLang(context: context, key: "OK") ,style: style1.copyWith(fontSize: 13),)),width: 80,height: 33,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: MainColor)))
                         ],);
                       },);

                     },
                         child:Container(

                           child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               CachedNetworkImage(imageUrl: Level.Models![index].blackimage??'',height: 120),
                               Text( Level.Models![index].name?? '',style: style3.copyWith(fontSize: 16)),
                             ],
                           ),
                         )
                     );
                   },itemCount:Level.Models?.length  ),

                   GridView.builder(  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                       crossAxisCount: 3,
                       childAspectRatio:0.7,
                       mainAxisSpacing: 10,
                       crossAxisSpacing: 10),itemBuilder: (BuildContext ctx, index){
                     return  InkWell(onTap: () {
                       showDialog(context: context,builder: (context) {
                         return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
                           child: Column(mainAxisSize: MainAxisSize.min,
                             children: [
                               Text( user.userinfo?.Models![index].AchiveModel?.name?? '',style: style6.copyWith(fontSize: 12,fontWeight: FontWeight.bold),),
                               SizedBox(height: 10,),
                               CachedNetworkImage(imageUrl:user.userinfo?.Models![index].AchiveModel?.image??'',height: 120),
                               Image.asset(Images.abg,width: 130),
                               Text(user.userinfo?.Models![index].AchiveModel?.description??'',style: style6.copyWith(fontSize: 12,fontWeight: FontWeight.bold),),

                             ],
                           ),
                         ),actions: [
                           InkWell(onTap:()=>Navigator.pop(context),child: Container(child: Center(child:  Text(  getLang(context: context, key: "OK") ,style: style1.copyWith(fontSize: 13),)),width: 80,height: 33,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: MainColor)))
                         ],);
                       },);
                     },
                         child:Container(

                           child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               CachedNetworkImage(imageUrl: user.userinfo?.Models![index].AchiveModel?.image??'',height: 120),
                               Text( "${DateFormat('dd-MMM-yyy').format(DateTime.parse(user.userinfo?.Models![index].createdAt??'' ))}",
                                 style: style3.copyWith(fontSize: 12,color: Colors.white),)
                             ],
                           ),
                         )
                     );
                   },itemCount:user.userinfo?.Models?.length  ),
                 ],
               ),
             )
            ],
          ),
        ),
      ),
    );
  }
}
