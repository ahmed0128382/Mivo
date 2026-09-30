

import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/RechargeScrean/Rechargescrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/LuckyBagswidget/LuckyBagswidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/chairLockwidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/dimensions.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';


class NestedTabBar extends StatelessWidget  {
  const NestedTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GiftsViewModel gits = Provider.of<GiftsViewModel>(context, listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return   Container(width: SizeConfig.screenWidth!,height: SizeConfig.screenHeight!/1.7,decoration: BoxDecoration( borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),color: Colors.black),
      child: Column(
        children: [
          const SizedBox(height : 10,),
       Container(width: SizeConfig.screenWidth!,decoration: const BoxDecoration( color: Colors.black,),height:50 ,child: Row(
      children: [


         SizedBox(width: 10,),
        InkWell(onTap: (){
          Room.ChairsRoom.forEach((element) {
            Room.AddUserIds(id: element.user?.id );
          });
        }, child: Container(decoration: BoxDecoration(color: Colors.white24,borderRadius: BorderRadius.circular(20)),child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6) ,
          child: Text(getLang(context: context,key:   "Select_All"),style: style1.copyWith(height: 1,fontSize: 12)),
        ),)),
        Expanded(
          child: Container(decoration: BoxDecoration(color: Colors.transparent,),
            child: ListView.builder(itemCount:Room.ChairsRoom.length ,scrollDirection: Axis.horizontal,itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child:Room.ChairsRoom[index].user?.id==null?SizedBox():InkWell(onTap: (){

                if(Room.UserIds.contains(Room.ChairsRoom[index].user?.id)){
                  Room.RemoveUserIds(id: Room.ChairsRoom[index].user?.id);

                }else{
                  Room.AddUserIds(id: Room.ChairsRoom[index].user?.id);

                }
              },child: CircleAvatar(backgroundColor:Room.UserIds.contains(Room.ChairsRoom[index].user?.id)? Room.ChairsRoom[index].user?.ginder=='0'?Colors.lightBlue:Colors.pink :Colors.transparent,radius: 18,child: CircleAvatar(backgroundColor: Colors.transparent,radius: 16,  backgroundImage: CachedNetworkImageProvider(  Room.ChairsRoom[index].user?.image??'')))),
            ),),
          ),
        ),
        InkWell(onTap: (){
          Navigator.pop(context);
        }, child: Icon(Icons.clear,color: whitecolor2,)),
        SizedBox(width: 10,),
      ])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
            child: Container(color: Colors.white24,width: SizeConfig.screenWidth,height: 1),
          ),

          DefaultTabController(length: user.Giftcatigoris.length,
            child: Expanded(
              child: Container(color:Colors.black,
                child: Column(
                  children: [
                    TabBar(

                        indicatorColor:Colors.white,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white54,
                        isScrollable: true,automaticIndicatorColorAdjustment: true,
                        tabs: List.generate(user.Giftcatigoris.length, (index) =>   Tab(
                          child: Text(user.Giftcatigoris[index]['name'],style: TextStyle(fontSize: 13)),
                        ),)
                    ),
                    Flexible (
                      child: TabBarView(children:
                      List.generate(user.Giftcatigoris.length, (index) =>
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:4,
                                childAspectRatio:0.8,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5),
                            itemCount:user.Giftcatigoris[index]['gifts'].length ,
                            itemBuilder: (BuildContext ctx, indexx) {
                              return InkWell(onTap: (){
                                print(user.Giftcatigoris[index]['vip']);
                                print(user.Giftcatigoris[index]['vip'].runtimeType);
if(user.Giftcatigoris[index]['gifts'][indexx]['luckypackage']==1){
  Navigator.pop(context);
  user.Packageid=null;
  showDialog(context: context,builder: (context) {

    return AlertDialog(backgroundColor: whitecolor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),content:Container(
      child: LuckyBagswidget(),
    ),);
  },);


}else{
  if(user.Giftcatigoris[index]['vip']==1&&user.userinfo?.MyVip==null){
    Dialogs().showtoast('يجب ان تحصل علي vip اولا');
  }else{
    gits.GiftList.clear();
    gits.GiftKind=user.Giftcatigoris[index]['lucky'];
    gits.addtogiftlist(value: user.Giftcatigoris[index]['gifts'][indexx],costs:(int.parse(gits.SentValue.toString())*user.Giftcatigoris[index]['gifts'][indexx]['price']) .toInt()*Room.UserIds.length);

  }

  }


                              },
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color:!gits.GiftList.contains(user.Giftcatigoris[ index]['gifts'][indexx])?Colors.transparent: MainColor.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(15)),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(imageUrl:   AppConstants.Image_URL+user.Giftcatigoris[ index]['gifts'][indexx]['image'] ,height: 70,),
                                          Text(user.Giftcatigoris[index]['gifts'][indexx]['name']??'',style: style4.copyWith(fontSize: 10,color: Colors.white)),
                                          if(user.Giftcatigoris[index]['gifts'][indexx]['price']!=0)   Row(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text( user.Giftcatigoris[index]['gifts'][indexx]['price'].toString() ,style: style4.copyWith(fontSize: 10,color: Colors.white60)),
                                              SizedBox(width: 5,),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Image.asset(Images.coins,height: 10,width: 10,),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                 if(user.Giftcatigoris[index]['gifts'][indexx]['price']>=1000)   Positioned(child: Icon(Icons.star,color: Colors.orange,size: 15,))
                                  ],
                                )
                              );
                            }),
                      ),
                      )
                      ),
                    ),
                    Container(width: SizeConfig.screenWidth!,
                      decoration: BoxDecoration( color: Colors.transparent ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15 ),
                        child: Row( children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(onTap: (){

                                  if(gits.GiftList.isEmpty){
                                    Dialogs().showtoast(getLang(context: context,key: "NoGiftSelected"));

                                  }else if(Room.UserIds.isEmpty){
                                    Dialogs().showtoast(getLang(context: context,key: "NouserSelected"));

                                  }else{
                                    if((user.userinfo?.coins??0) < gits.Cost){
                                      navigateTo(context: context, screen: RechargeScrean());
                                      Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));

                                    }else{


print(gits.GiftKind.toString());
                                      if(gits.GiftKind==1){

                                        Room.SentLuckyGift(Cost:gits.Cost ,Listuser: Room.UserIds,context: context,giftid: gits.GiftList.first['id'],quantity:gits.SentValue.toString());

                                      }else{
                                        Room.SentGift(Cost:gits.Cost ,Listuser: Room.UserIds,context: context,giftid: gits.GiftList.first['id'],quantity:gits.SentValue.toString());

                                      } Navigator.pop(context);

                                    }

                                  }
                                },child: Container(width: 60,height: 35, decoration: BoxDecoration( color: Colors.white,borderRadius: BorderRadius.only(bottomRight:       Radius.circular(10),topRight: Radius.circular(10) )),
                                    child: Center(child: Text(getLang(context: context,key: "Send") ,style: style1.copyWith(height: 1,color: Color(0xFF221316),fontSize: 13) )))),
                                Container(width: 60,height: 35,
                                    decoration: BoxDecoration( color: Colors.white,  borderRadius: BorderRadius.only(topLeft:   Radius.circular(10),bottomLeft: Radius.circular(10) )),

                                  child: PopupMenuButton(
                                    offset: Offset(0, 0),
                                    onSelected: (s){

                                      gits.changeSentValue(s.toString());


                                      gits.Cost=gits.giftprice*int.parse(s.toString())*Room.UserIds.length  ;


                                    },child: Container( width: 50, color: Colors.transparent,child: Center(child: Text(gits.SentValue.toString(),style: style1.copyWith(height: 1,color:  Color(0xFF221316)),))),
                                    onCanceled: (){
                                      print('d');
                                    },
                                    itemBuilder: (_) => <PopupMenuEntry>[
                                      PopupMenuItem(value:'1',
                                          child:Text( '1',style: style6,)),
                                      PopupMenuItem(value:'5' ,
                                          child:Text('5',style: style6,)),
                                      PopupMenuItem(value:'10',
                                          child:Text('10',style: style6,)),
                                      PopupMenuItem(value:'20',child:Text('20',style: style6,)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Column(mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Text( '${getLang(key: "Cost",context: context)}: ${gits.Cost}',style: style6.copyWith(height: 1,color: whitecolor,fontSize: 15)),
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(user.userinfo?.coins.toString()??'0',style: style6.copyWith(height: 1,color: whitecolor,fontSize: 15)),
                                  ),
                                  Image.asset(Images.coins,width: 15,height: 15),
                                ],
                              ),

                            ],
                          ),
                          const         SizedBox(width: 10,)
                        ]),
                      ),),

                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
 