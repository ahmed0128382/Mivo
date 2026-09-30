import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/FollowScreans/FriendsScrean.dart';
import 'package:ahlachat/view/Screans/MainScreans/ShopScrean/SendtofriendsScrean.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/player.dart';

import '../../../../util/Localization.dart';
import '../../../../util/SizeConfig.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import '../../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import '../../../widgets/PhotoWithFrame.dart';
class ByeItem extends StatefulWidget {
  const ByeItem({Key? key}) : super(key: key);

  @override
  State<ByeItem> createState() => _ByeItemState();
}

class _ByeItemState extends State<ByeItem> {
  List Pays=[];
  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);
    ShopViewmodel Shops=  Provider.of<ShopViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    FollowViewModel Follow=  Provider.of<FollowViewModel>(context,listen: true);

    Pays=[
      {'id':1,'day':1,'price': Room.ShowItem?.price},
      {'id':2,'day':7,'price': (Room.ShowItem?.price??0)*7},
      {'id':3,'day':15,'price':  (Room.ShowItem?.price??0)*15},
      {'id':4,'day':30,'price':  (Room.ShowItem?.price??0)*30},
    ];
    return Container(
      width: SizeConfig.screenWidth!,
      decoration: BoxDecoration(  color: Colors.white,    borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(onTap: (){
              Navigator.pop(context);
            },child: Icon(Icons.clear,color: Colors.black45,)),

            Center(child: CachedNetworkImage(imageUrl:  Room.ShowItem?.imagegift??'',height: 80)),
            const SizedBox(height: 10,),
            Center(child: Text(Room.ShowItem?.name??'',style: style5.copyWith(fontSize: 20,color: Colors.black))),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width : 10,),


                Expanded(flex: 1,child: InkWell(
                  onTap: () {

                    Shops.selectPackage(value: Pays[1]['id'],Dayitem:  Pays[1]['day'],Priceitem:  Pays[1]['price']);
                  },
                  child: Container(child: Center(
                    child: Column(mainAxisAlignment:MainAxisAlignment.center ,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${Pays[1]['day']}',style: style2.copyWith(fontSize: 22,height: 1,)),
                        const SizedBox(height: 10,),
                        Text(getLang(key: "Days",context: context),style: style5.copyWith(fontSize: 15,height: 1,)),
                        const SizedBox(height: 10,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.coins,width: 15,height: 15),
                            const SizedBox(width: 3,),
                            Text('${Pays[1]['price']}',style: style5.copyWith(height: 1,fontSize: 12)),
                          ],
                        ),

                      ],
                    ),
                  ),height: 120,   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,border: Border.all(color:  Shops.SelectedPackage.contains(Pays[1]['id'])? MainColor:Colors.black12))),

                )),
                const SizedBox(width : 10,),
                Expanded(flex: 1,child: InkWell(
                  onTap: () {

                    Shops.selectPackage(value: Pays[2]['id'],Dayitem:  Pays[2]['day'],Priceitem:  Pays[2]['price']);
                  },
                  child: Container(child: Center(
                    child: Column(mainAxisAlignment:MainAxisAlignment.center ,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${Pays[2]['day']}',style: style2.copyWith(fontSize: 22,height: 1,)),
                        const SizedBox(height: 10,),
                        Text(getLang(key: "Days",context: context),style: style5.copyWith(fontSize: 15,height: 1,)),
                        const SizedBox(height: 10,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.coins,width: 15,height: 15),
                            const SizedBox(width: 3,),
                            Text('${Pays[2]['price']}',style: style5.copyWith(height: 1,fontSize: 12)),
                          ],
                        ),

                      ],
                    ),
                  ),height: 120,   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,border: Border.all(color:  Shops.SelectedPackage.contains(Pays[2]['id'])? MainColor:Colors.black12))),
                )),
                const SizedBox(width : 10,),
                Expanded(flex: 1,child: InkWell(
                  onTap: () {
                    Shops.selectPackage(value: Pays[3]['id'],Dayitem:  Pays[3]['day'],Priceitem:  Pays[3]['price']);
                  },
                  child: Container(child: Center(
                    child: Column(mainAxisAlignment:MainAxisAlignment.center ,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${Pays[3]['day']}',style: style2.copyWith(fontSize: 22,height: 1,)),
                        const SizedBox(height: 10,),
                        Text(getLang(key: "Days",context: context),style: style5.copyWith(fontSize: 15,height: 1,)),
                        const SizedBox(height: 10,),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.coins,width: 15,height: 15),
                            const SizedBox(width: 3,),
                            Text('${Pays[3]['price']}',style: style5.copyWith(height: 1,fontSize: 12)),
                          ],
                        ),

                      ],
                    ),
                  ),height: 120,   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) ,border: Border.all(color:  Shops.SelectedPackage.contains(Pays[3]['id'])? MainColor:Colors.black12))),
                )),
                const SizedBox(width : 10,),
              ],
            ),

            SizedBox(height: 20,),

            Row( 
              children: [
                Expanded(flex: 1,
                  child: InkWell(onTap: (){

                    if((Shops.price ??0)< (user.userinfo?.coins??0)){

                      Shops.ByeShop(context: context);
                      Navigator.pop(context);
                    }else{

  Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));

                    }

                  },
                    child: Container(

                      height: 45,
                      child: Center(child:Text(getLang(context: context, key: "Bye"),style: style4.copyWith(fontSize: 15,color: whitecolor),) ),
                      decoration: BoxDecoration(color:MainColor,borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),         SizedBox(width:  20,),
                Expanded(flex: 1,
                  child: InkWell(onTap: (){

                    if((Shops.price ??0)<= (user.userinfo?.coins??0)){
                      Follow.GetFriends(context: context);

                      navigateTo(context: context, screen:  const SendToFriendsScrean());

                    }else{


                      Dialogs().showtoast(getLang(context: context,key: "Not_Enough"));

                    }

                  },
                    child: Container(

                      height: 45,
                      child: Center(child:Text(getLang(context: context, key: "Dedication"),style: style4.copyWith(fontSize: 15,color: whitecolor),) ),
                      decoration: BoxDecoration(color:MainColor,borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),

    );
  }
}
