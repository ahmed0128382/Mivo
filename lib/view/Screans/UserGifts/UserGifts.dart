import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'package:provider/provider.dart';
class UserGifts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    ShopViewmodel Shops=  Provider.of<ShopViewmodel>(context,listen: true);
    return Scaffold(appBar: AppBar( automaticallyImplyLeading: true,iconTheme: IconThemeData(color:Colors.black45),title:Text(getLang(context: context, key: "Your_Gifts"),style:TextStyle(color: Colors.black,fontWeight: FontWeight.normal),) ),
        body:Column(
          children: List.generate(user.UserGift.length, (index) =>InkWell(
            onTap: (){
              if(user.UserGift[index].kind=='0'){
                Dialogs().ShowEntery(context:context,svga:user.UserGift[index].urlsvga);
              }else{
                Dialogs().ShowFrame(context:context,svga:user.UserGift[index].urlsvga);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  CachedNetworkImage(
                      imageUrl:user.UserGift[index].image??Images.profilephoto,height: 70,width: 70),
                  const  SizedBox(width: 5,),
                  Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.UserGift[index].tittle??'',style: TextStyle().copyWith(fontWeight: FontWeight.normal,  fontSize: 16)),
                      const      SizedBox(height: 5,),
                      Text(user.UserGift[index].message??'',style: style6.copyWith(fontWeight: FontWeight.normal,height: 1,)),
                    ],
                  ),
                Spacer(),
                Column(crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    user.userinfo?.entry==user.UserGift[index].urlsvga|| user.userinfo?.frameimage==user.UserGift[index].urlsvga?
                    InkWell(onTap: (){

                      if(user.UserGift[index].kind=='0'){
                        Shops.RemoveEntry(context: context );
                      }
                      else if(user.UserGift[index].kind=='1'){
                        Shops.RemoveFrame(context: context );

                      }

                    },
                      child: Container(width: 90,height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: MainColor,),child: Center(child: Text(getLang(context: context, key: "Remove"),style: style1)),),
                    ):InkWell(
                      onTap: (){
                        if(user.UserGift[index].kind=='0'){
                          Shops.UserpdateEntry(context: context,Entry:  user.UserGift[index].svga );
                        }else{
                          Shops.UserpdateFrame(context: context,Frame:user.UserGift[index].svga );
                        }


                      },
                      child: Container(width: 90,height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: MainColor,),child: Center(child: Text('Use',style: style1)),),
                    ),
                    Text('For ${(DateTime.parse(user.UserGift[index].createdAt??'').difference(DateTime.now()).inDays==0?1:DateTime.parse(user.UserGift[index].createdAt??'').difference(DateTime.now()).inDays).toString()} Days',style:style5.copyWith( fontSize: 12,color: Colors.black45),),
                  ],
                ),
                  const  SizedBox(width: 10,),

                ],
              ),
            ),
          )),
        )
    );
  }
}
