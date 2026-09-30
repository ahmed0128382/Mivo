import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/Levels_ViewModel/Level_ViewModel.dart';
import '../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
class LevelGifts extends StatelessWidget {
  const LevelGifts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LevelViewModel  Level=Provider.of<LevelViewModel>(context,listen:  true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    ShopViewmodel Shops=  Provider.of<ShopViewmodel>(context,listen: true);

    return Scaffold(appBar: AppBar(centerTitle: true,automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black),title:Text(getLang(context: context,key: "LevelGifts"),style: style5,) ),
    body:Level.showloading?Center(child: CircularProgressIndicator(),) :
    Column(
      children: List.generate(Level.LevelGift.length, (index) =>Padding(
        padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
        child: Row(
          children: [
             CachedNetworkImage(
        imageUrl:Level.LevelGift[index].image??Images.profilephoto,height: 60,width: 60),
            const SizedBox(width: 5,),
            Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width:300,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Level.LevelGift[index].tittle??'',style: style6.copyWith(fontWeight: FontWeight.bold,fontSize: 12)),

                if(Level.LevelGift[index].kind==0) user.userinfo?.frameimage==Level.LevelGift[index].svgaurl?
                      InkWell(onTap: (){
                          Dialogs().showdialog2(context: context, tittle: '', content:getLang(context: context,key: "Remove_frame"), buttontext: getLang(context: context, key: "Yes"), onTap:(){
                            Shops.RemoveFrame(context: context );
                            Navigator.pop(context);
                          } );
                      },
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: MainColor,),child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(getLang(context: context, key: "Remove"),style: style1),
                        ),),
                      ):
                      InkWell(
                        onTap: (){

                          Dialogs().showdialog2(context: context, tittle: '', content:getLang(context: context,key: "Set_frame"), buttontext: getLang(context: context, key: "Yes"), onTap:(){

                            Shops.UserpdateFrame(context: context,Frame:Level.LevelGift[index].svga );
                            Navigator.pop(context);
                          } );
                        },
                        child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: MainColor,),child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(getLang(context: context,key: "set"),style: style1),
                        ),),
                      )

                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Container(width: 300,child: Text(Level.LevelGift[index].message??'',style: style6.copyWith(fontWeight: FontWeight.normal))),

              ],
            ),

          ],
        ),
      )),
    )
    );
  }
}
