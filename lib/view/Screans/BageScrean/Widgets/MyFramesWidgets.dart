import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';

import '../../../../models/ShopModel.dart';
import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
class Frameitemwidgets  extends StatelessWidget {
  Items ?items;
  String ?create;
  String ?update_at;
  Frameitemwidgets({this.items,this.create,this.update_at});

  @override
  Widget build(BuildContext context) {
     ShopViewmodel Shops=  Provider.of<ShopViewmodel>(context,listen: true);
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(decoration: BoxDecoration(color:whitecolor,borderRadius: BorderRadius.circular( 8 )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              InkWell(onTap: (){
               if(items?.kind==0||items?.kind==2||items?.kind==3){
                 Dialogs().ShowEntery( context: context,svga: items?.svggift);
               }else if(items?.kind==1){
                 Dialogs().ShowFrame(context: context,svga: items?.svggift);
               }

               },child:         FaIcon(FontAwesomeIcons.playCircle,size: 20,color:MainColor),
              ),
               Center(child: CachedNetworkImage ( imageUrl:items?.imagegift??'',height: 100)),
              SizedBox(height: 7,),
              Center(child: Text(items?.name??'',style:style6.copyWith(fontWeight: FontWeight.normal,color: Colors.black.withOpacity(0.8),fontSize: 12) )),
              SizedBox(height: 4,),
              Center(child: Text('For ${(DateTime.parse(create??'').difference(DateTime.now()).inDays==0?1:DateTime.parse(create??'').difference(DateTime.now()).inDays).toString()} Days',style:style5.copyWith( fontSize: 12,color: Colors.black45),)),

             Spacer(),
              user.userinfo?.frameimage==items?.svggift||user.userinfo?.entry==items?.svggift|| user.userinfo?.Enterbubles==items?.imagegift|| user.userinfo?.bubbles==items?.svggift?
              Padding(

                 padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
               child: InkWell(onTap: (){

               if(items?.kind==0){

                   Shops.RemoveEntry(context: context );



               }else if(items?.kind==1){


                   Shops.RemoveFrame(context: context );

               }else if(items?.kind==2){


                 Shops.RemoveEnterbubles(context: context );

               }else if(items?.kind==3){


                 Shops.RemoveProfilebubles(context: context );

               }



             },
               child: Container(
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Center(child:Text(getLang(context: context, key: "Remove"),style: style4.copyWith(fontSize: 12,color: whitecolor),) ),
                 ),
                 decoration: BoxDecoration(color:MainColor,borderRadius: BorderRadius.circular( 5)),
               ),
             ),
           ):

           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
             child: InkWell(onTap: (){

                  if(items?.kind==0){

                      Shops.UserpdateEntry(context: context,Entry:items?.svga );




                  }else if(items?.kind==1){

                      Shops.UserpdateFrame(context: context,Frame:items?.svga );


                  }else if(items?.kind==2){

                    Shops.UserpdateEnterbubles(context: context,Frame:items?.image );


                  }else if(items?.kind==3){

                    Shops.UserpdatepROFILEbubles(context: context,Frame:items?.svga );


                  }



                },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child:Text(getLang(context: context, key: "set"),style: style4.copyWith(fontSize: 12,color: whitecolor),) ),
                    ),
                    decoration: BoxDecoration(color:MainColor,borderRadius: BorderRadius.circular( 5)),
                  ),
                ),
           ),


            ],

          ),
        ),
      ),
    );
  }
}
