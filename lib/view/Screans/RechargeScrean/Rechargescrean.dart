
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:flutter/material.dart';

import 'package:ahlachat/models/PayPalPackage.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/WebViewScrean.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Wallet_ViewModel/Wallet_ViewModel.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/store_product_wrapper.dart';

import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class RechargeScrean extends StatelessWidget {
  static final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';


  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    WalletViewmodel   Wallet =Provider.of<WalletViewmodel>(context,listen: true);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true,iconTheme: IconThemeData(color: Colors.black),backgroundColor: whitecolor

          ,centerTitle: true,title: Text(getLang(context: context, key: "Recharge"),style: style6.copyWith(fontSize: 20),)),
   body: Container(
     child: CustomScrollView(physics: NeverScrollableScrollPhysics(),
       slivers: <Widget>[
         SliverToBoxAdapter(
           child: DefaultTabController(
             length: 2,
             child:   Column(
               children: [
                 TabBar(
                   indicatorColor: whitecolor,
                   tabs:[
                     Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text('Google Pay',style: style6.copyWith(fontSize: 16,)),
                         const  SizedBox(width: 10,),
                         Image.asset('assets/image/Google.png.png',height: 20,width: 20,)
                       ],
                     ),

                     ),
                     Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text('PayPal',style: style6.copyWith(fontSize: 16,)),
                         const       SizedBox(width: 10,),
                         Image.asset('assets/image/paypal.png',height: 20,width: 20,)
                       ],
                     ),)

                     //),
                     // Tab(
                     //   text:'Posts',
                     // )
                   ],
                   labelColor: Colors.black,labelStyle:style5.copyWith(fontSize: 12) ,
                   unselectedLabelColor:Colors.black45 ,
                   indicator: MaterialIndicator(
                     height: 5,
                     topLeftRadius: 8,
                     topRightRadius: 8,
                     horizontalPadding: 50,color: MainColor,
                     tabPosition: TabPosition.bottom,
                   ),
                 ),

                 Container(  height: SizeConfig.screenHeight,
                   child: TabBarView(
                       children:[

                         Column(children: List.generate(Wallet.packages.length, (index){
                          StoreProduct Products=  Wallet.packages[index].storeProduct;
                           return Padding(
                             padding: const EdgeInsets.symmetric(vertical: 5),
                             child: InkWell(onTap:(){

                               Wallet.purchasePackage(Backage: Wallet.packages[index],context: context);
                             } ,

                               child: Container(decoration: BoxDecoration(border: Border.all( color: Color(0xFFC0C1C4).withOpacity(0.2)),borderRadius: BorderRadius.circular(10)),child: Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                 child: Row(
                                   children: [
                                     Row(
                                       children: [
                                         Image.asset(Images.coins,width: 17,height: 17),
                                         const          SizedBox(width: 10,),
                                         Text(Products.description+'  ${getLang(context: context,key: "Coins")}'),
                                       ],
                                     ),
                                     Spacer(),
                                     Container(decoration: BoxDecoration(color: Colors.greenAccent,borderRadius: BorderRadius.circular(15)), child: Center(child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                       child: Text(Products.priceString,style: style3.copyWith(fontSize: 12)),
                                     )),),

                                   ],
                                 ),
                               ),),
                             ),
                           );
                         }),),
                         Column(children: List.generate(Wallet.PayPalPackages.length, (index){
                           PayPalPackage Products= Wallet.PayPalPackages[index];
                           return Padding(
                             padding: const EdgeInsets.symmetric(vertical: 5),
                             child: InkWell(onTap:()async{

                              Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewScrean(name: 'Paypal', link: 'https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=devtechnosquad405@gmail.com&item_name=${Products.coins}&custom=${UserId}&amount=${Products.price}&currency_code=USD&return=https://cp.hakini.live&cancel_return=https://cp.hakini.live&notify_url=https://cp.hakini.live/paypal',),));
                            } ,
                               child: Container(decoration: BoxDecoration(border: Border.all( color: Color(0xFFC0C1C4).withOpacity(0.2)),borderRadius: BorderRadius.circular(10)),child: Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                 child: Row(
                                   children: [
                                     Row(
                                       children: [
                                         Image.asset(Images.coins,width: 17,height: 17),
                                         const          SizedBox(width: 10,),
                                         Text(Products.coins.toString()+'   ${getLang(context: context,key: "Coins")}'),
                                       ],
                                     ),
                                     Spacer(),
                                     Container(width: 100,decoration: BoxDecoration(color: Colors.greenAccent,borderRadius: BorderRadius.circular(15)), child: Center(child: Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                       child: Text(Products.price.toString()+"  \$",style: style3.copyWith(fontSize: 12)),
                                     )),),

                                   ],
                                 ),
                               ),),
                             ),
                           );
                         }),),
                      //    Column(children: List.generate(3, (index) => Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 5),
                      //   child: Container(decoration: BoxDecoration(border: Border.all( color: Color(0xFFC0C1C4).withOpacity(0.2)),borderRadius: BorderRadius.circular(10)),child: Padding(
                      //     padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      //     child: Row(
                      //       children: [
                      //         Row(
                      //           children: [
                      //             Image.asset(Images.coins,width: 17,height: 17),
                      //             SizedBox(width: 10,),
                      //             Text('${user.Shipping[index].coins}  coins'),
                      //           ],
                      //         ),
                      //         Spacer(),
                      //         Container(decoration: BoxDecoration(color: Colors.greenAccent,borderRadius: BorderRadius.circular(15)), child: Center(child: Padding(
                      //           padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      //           child: Text('${user.Shipping[index].cost} USD',style: style3.copyWith(fontSize: 12)),
                      //         )),),
                      //
                      //       ],
                      //     ),
                      //   ),),
                      // )),)
                       ]
                   ),
                 ),
               ],
             ),
           ),
         ),


       ],
     ),
   ),
    );
  }
}


