import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/Family/FamilyMemberScrean.dart';
import 'package:ahlachat/view/Screans/Family/JoinRequestScrean.dart';
import 'package:ahlachat/view/Screans/Family/MemberFamilyRank.dart';
import 'package:ahlachat/view/Screans/MainScreans/MainScrean/widgets/RoomsContainer.dart';
import 'package:ahlachat/view/Screans/UserProfile/ShowUserProfile.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class FamilyProfileScrean extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Rooms=  Provider.of<RoomViewmodel>(context,listen: true);
    SvgViewmodel svga=  Provider.of<SvgViewmodel>(context,listen: true);
    FamilyViewModel  Family=Provider.of<FamilyViewModel>(context,listen:  true);
    LoginViewmodel user= Provider.of<LoginViewmodel>(context,listen: true);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: Container(child: Center(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(backgroundColor: Colors.transparent,radius: 50,backgroundImage: CachedNetworkImageProvider(Family.CurrentFamily?.image??'')),
                      const SizedBox(height: 10,),
                      Text(Family.CurrentFamily?.name??'' ,style: Namestyle2.copyWith(fontSize: 15),),
                      const SizedBox(height: 5,),
                      InkWell(onTap: () {
                        Family.GetFamilyMembers();
                        navigateTo(context: context,screen: FamilyMemberScrean());
                      },
                        child: Container(decoration: BoxDecoration(color: Colors.white12,borderRadius: BorderRadius.circular(10)),child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person,color: whitecolor,size: 12) ,
                              SizedBox(width: 5,),
                              Text(Family.CurrentFamily?.nubmers?.toString()??'',style: style3.copyWith(fontSize: 10,color: Colors.white),)
                            ],
                          ),
                        ),),
                      ),
                      const SizedBox(height: 5,),
                      if(Family.CurrentFamily?.model!=null)CachedNetworkImage(imageUrl:Family.CurrentFamily?.model??'',height: 20,width: 40, )


                    ],
                  ),
                ),height: 200,width: SizeConfig.screenWidth,decoration:   BoxDecoration(image: DecorationImage(image: ExactAssetImage(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['BackImage']),fit: BoxFit.cover))),),
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0 ).copyWith(top: 0),
                  child: Container(
                    decoration:   BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        gradient:  LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.white,Color(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['Color']).withOpacity(0.8)])
                    ),
                    width: SizeConfig.screenWidth,

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['name'],style: style1),
                          SizedBox(height: 10,),
                          Row(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(onTap: () {
print(Family.Levels.where((element) => element['Level']==(int.parse(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['Level'])+1).toString()));
                              },child:   Image.asset(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['image'],height: 120)) ,
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                           Expanded(child: ProgressLine(percentage:((Family.CurrentFamily?.karisma??0)/(Family.Levels.where((element) => element['Level']==(int.parse(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['Level'])+1).toString()).first['Coins'])).round(),color:Color((Family.Levels.where((element) => element['Level']==(int.parse(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['Level'])+1).toString()).first['Color'])))),
                                          SizedBox(width: 10,),
                                         Image.asset(Family.Levels.where((element) => element['Level']==(int.parse(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['Level'])+1).toString()).first['image'].toString(),height: 40) ,

                                        ],
                                      ),
                                       Text('${getLang(context: context,key: "This_Exp")} : ${Family.CurrentFamily?.karisma}/${Family.Levels.where((element) => element['Level']==(int.parse(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['Level'])+1).toString()).first['Coins'].toString()} ',style: style3.copyWith(fontWeight: FontWeight.bold,fontSize: 12)),
                                      Text('${getLang(context: context,key: "Target_Level")}: ${Family.Levels.where((element) => element['Level']==(int.parse(Family.Levels.where((element) => element['Coins']<=Family.CurrentFamily?.karisma).last['Level'])+1).toString()).first['name'].toString()} ',style: style3.copyWith(fontWeight: FontWeight.bold,fontSize: 12)),


                                    ],
                                  ),
                                ),
                              ),

                              //   Text((Levels.where((element) => element['Level']<=(int.parse(Levels.where((element) => element['Coins']<=100).last['Level'])+1).toString()).last['Level'])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Text(getLang(context: context, key: "Family_Notice"),style: style2.copyWith(fontSize: 15)),
                      const SizedBox(height: 0,),
                      Text(Family.CurrentFamily?.describtion??getLang(context: context, key: "No_Description"),style: style5.copyWith(height: 2,fontSize: 13,color: Colors.black87.withOpacity(0.8))),
                    ],
                  ),
                )),
                SliverToBoxAdapter(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          Text(getLang(context: context,key: "Family_Stars"),style: style2.copyWith(fontSize: 15,height: 1)),
                          const Spacer(),
                          InkWell(onTap: (){

                            navigateTo(context: context,screen: MemberFamilyRank());
                            Family.GetMemberFamilyLeaderboard();
                          },
                            child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                              children:   [
                                Text(getLang(context: context,key: "Ranking"),style:   style2.copyWith(fontSize: 12,color: Colors.black26,height: 1)),
                                const Icon(Icons.navigate_next_outlined,color: Colors.black26,size: 20,)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      SingleChildScrollView(scrollDirection: Axis.horizontal,
                        child: Row(
                            children:List.generate(Family.CurrentFamily?.topStar?.length??0, (index) =>  Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              child:   InkWell(
                                onTap: () {
                                  user.GetShoweduserProfile(Family.CurrentFamily?.topStar![index].user);
                                  navigateTo(context: context,screen: ShowUserProfile());
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(backgroundColor: Colors.transparent,radius: 25,backgroundImage: CachedNetworkImageProvider(Family.CurrentFamily?.topStar![index].user?.image??'')),
                                    Center(child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                      child: Row(
                                        children: [
                                          Image.asset(Images.coins,width: 12,height: 12),
                                          SizedBox(width: 3,),
                                          Text(Helper().k_m_b_generator(int.parse(Family.CurrentFamily?.topStar![index].coins??'0')).toString(),style: style2.copyWith(height: 1, fontSize: 10),),
                                        ],
                                      ),
                                    )),

                                  ],
                                ),
                              ),
                            ))
                        ),
                      )
                    ],
                  ),
                )),
                SliverToBoxAdapter(child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(getLang(context: context,key: "Family_Rooms"),style: style2.copyWith(fontSize: 15)),
                ),),
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio:1.2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing:0),
                  delegate: SliverChildBuilderDelegate( (context, index) {
                    List<RoomModel> RoomsList = Family.CurrentFamily?.rooms??[] ;

                    return  InkWell(onTap: ()
                    {
                      Rooms.EnterRoom(id:RoomsList[index].id,adminId: RoomsList[index].adminId,context: context );


                    },child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: RoomsContainer(Roominfo:RoomsList[index] ,),
                    ));
                  },
                    childCount: Family.CurrentFamily?.rooms?.length??0,
                  ),
                ),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 40))
              ],
            ),
         if(user.userinfo?.MyFamil==null &&Family.CurrentFamily?.userId!=user.userinfo?.id)
            Align(alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 15),
                child: InkWell(onTap: () {
                  print(user.userinfo?.FamilyRequests);
                  if(user.userinfo?.FamilyRequests?.contains(Family.CurrentFamily?.id)==true){
                    Family.CancleJoinRequest(context: context);
                  }else{
                    Family.JoinFamilyRequest(context: context);
                  }


                },child: Container(height: 45,width: SizeConfig.screenWidth,child: Center(child: Text( user.userinfo?.FamilyRequests?.contains(Family.CurrentFamily?.id)==true ?getLang(context: context,key: "Reviewing"):getLang(context: context,key: "Join_Family"),style: style2.copyWith(height: 1),)),decoration: BoxDecoration(color:Color(0xFFf3c98d),borderRadius: BorderRadius.circular(10)),)),
              ),
            ),

       if(user.userinfo?.MyFamil!=null&&user.userinfo?.MyFamil?.id==Family.CurrentFamily?.id)    Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(height: 20,
                child: PopupMenuButton(padding: const EdgeInsets.only(top: 0),  icon:const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                    onSelected: (value) {

if(value=='0'){
  Family.GetFamilyRequests();
  navigateTo(context: context, screen: JoinRequestScrean());
}else if(value=='1'){
  Family.LeaveMyFamily(context: context);
}
else if(value=='2'){
  Family.EditFamilyName.text=Family.CurrentFamily?.name??'';
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('سوف يكلفك تغيير اسم العائله 5000 من الالماس الخاص بك',style: style2.copyWith(fontSize: 20),),
            SizedBox(height: 10,),
            TextFormField(controller: Family.EditFamilyName,),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(onTap: (){
                  if(Family.EditFamilyName.text==Family.CurrentFamily?.name){
                    Dialogs().showtoast('لم تقم بتعديل اسم العائله بعد');
                  }else{
                    Navigator.pop(context);
                    Family.EditFamilyNames();

                   // Navigator.pop(context);
                  }



                },child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10)),child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                  child: Text('تعديل',style: style1.copyWith(fontSize: 15),),
                ))),
                InkWell(onTap: (){

Navigator.pop(context);
                },child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10)),child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                  child: Text('اغلاق',style: style1.copyWith(fontSize: 15),),
                ))),
              ],
            ),

          ],
        ),
      )
  );

}
else if(value=='3'){
  showDialog(
      context: context,
      builder: (_) => AlertDialog(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),

        backgroundColor: Colors.white,
        content: Column(mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('- يمكنك تبديل دخل العائله الي عملات ترجع الي محفظتك مقابل 3% من قيمه الدخل',style: style2.copyWith(fontSize: 15),),
            SizedBox(height: 20,),
            Row(children: [
              Text(' - قيمه الدخل الحالي هي  : ',style: style2.copyWith(fontSize: 15),),
              Text(Family.CurrentFamily?.GlopalKarisma.toString()??'',style: style2.copyWith(fontSize: 15),)
            ],),
            SizedBox(height: 20,),
            Text('- لقد قمت بفك   : '+((Family.CurrentFamily?.karisma??0)-(Family.CurrentFamily?.GlopalKarisma??0)).toString()+'  من الدخل هذا الشهر  ' ,style: style2.copyWith(fontSize: 15),),
            SizedBox(height: 20,),
              Text('ُ - عند التحويل ستحصل علي    : '+((Family.CurrentFamily?.GlopalKarisma??0)*3/100).round().toString()+' ماسه من الدخل هذا الشهر ',style: style2.copyWith(fontSize: 15),),

            SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(onTap: (){
                  if((Family.CurrentFamily?.GlopalKarisma??0)<=0){
                    Dialogs().showtoast('ليس لديك اي دخل لتحويله');
                  }else{
                    Navigator.pop(context);
                    Family.ExchangeFamily(val: ((Family.CurrentFamily?.GlopalKarisma??0)*3/100).round());

                    // Navigator.pop(context);
                  }



                },child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10)),child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                  child: Text('فك الان',style: style1.copyWith(fontSize: 15),),
                ))),
                InkWell(onTap: (){

                  Navigator.pop(context);
                },child: Container(decoration: BoxDecoration(color: MainColor,borderRadius: BorderRadius.circular(10)),child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                  child: Text('اغلاق',style: style1.copyWith(fontSize: 15),),
                ))),
              ],
            ),

          ],
        ),
      )
  );
}
                    },
                    itemBuilder: (BuildContext bc) {
                      return   [
                        if(Family.CurrentFamily?.userId==user.userinfo?.id)     PopupMenuItem(
                          child: Text(getLang(context: context,key: "Join_Requests"),style: style6,),
                          value: '0',
                        ),

                        if(Family.CurrentFamily?.userId!=user.userinfo?.id)     PopupMenuItem(
                          child: Text(getLang(context: context,key: "Leave_Family"),style: style6,),
                          value: '1',
                        ),
                        if(Family.CurrentFamily?.userId==user.userinfo?.id)     PopupMenuItem(
                          child: Text('تعديل اسم العائله',style: style6,),
                          value: '2',
                        ),
                        if(Family.CurrentFamily?.userId==user.userinfo?.id)     PopupMenuItem(
                          child: Text('فك دخل العائله',style: style6,),
                          value: '3',
                        ),
                      ];}),
              ),
            )
          ],
        )
      ),
    );
  }
}
class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = MainColor,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}