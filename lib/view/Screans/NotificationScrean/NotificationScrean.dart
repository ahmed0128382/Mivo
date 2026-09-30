import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'package:provider/provider.dart';
class NotificationScrean extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    ShopViewmodel Shops=  Provider.of<ShopViewmodel>(context,listen: true);
    return Scaffold(appBar: AppBar(centerTitle: true,automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black),title:Text('Notifications',style: style5,) ),
        body:user.showloading15?Center(child: CircularProgressIndicator(),) :
        Column(
          children: List.generate(user.Notifications.length, (index) =>Padding(
            padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
            child: InkWell(onTap:(){
            //  print(user.UserGift[index].svga);
            } ,
              child: Row(
                children: [
                  CachedNetworkImage(
                      imageUrl:user.Notifications[index].image??Images.profilephoto,height: 60,width: 60),
                  const   SizedBox(width: 5,),
                  Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(user.Notifications[index].tittle??'',style: style6.copyWith(fontWeight: FontWeight.bold,fontSize: 12)),
                      ),
                      const   SizedBox(height: 5,),
                      Text(user.Notifications[index].message??'',style: style6.copyWith(fontWeight: FontWeight.normal)),
                    ],
                  ),
                  const Spacer(),
                  Text(Helper().getTimeago(time: user.Notifications[index].updatedAt),style: style6.copyWith(fontSize: 12, color: Colors.black45)),

                ],
              ),
            ),
          )),
        )
    );
  }
}
