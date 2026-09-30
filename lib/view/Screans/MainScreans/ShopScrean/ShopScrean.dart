import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:flutter/material.dart';

import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/ShopScrean/Widgets/FrameShop.dart';

import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';

import 'package:ahlachat/viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'package:provider/provider.dart';

import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class ShopScrean extends StatelessWidget {
List Pays=[];

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);

    ShopViewmodel Shop=  Provider.of<ShopViewmodel>(context,listen: true);

    return   DefaultTabController(
      length:Shop.AllShop.length,
      initialIndex: 0,
      child: Scaffold(backgroundColor:Color(0xFFf6f7f9),
        appBar: AppBar(iconTheme: IconThemeData(color: Colors.black),backgroundColor: Colors.white,title:   Text(getLang(key: "Shop",context: context),style: style2,),automaticallyImplyLeading: true ),

        body: Column(
            children: [

              Container(color: Colors.white,width: SizeConfig.screenWidth,
                child: TabBar(  isScrollable:true,  indicator: MaterialIndicator(
                  height: 3,
                  topLeftRadius: 0,
                  topRightRadius: 0,
                  bottomLeftRadius: 5,horizontalPadding: 10,
                  bottomRightRadius: 5,color:MainColor,
                  tabPosition: TabPosition.bottom,
                ),

                  labelStyle: style2.copyWith(fontSize: 15) ,
                  unselectedLabelColor: Colors.black45,

                  labelColor:MainColor,
                  onTap: (val) {},

                  tabs:List.generate(Shop.AllShop.length, (index) => Tab(
                    text:Shop.AllShop[index].name,
                  ),)  ,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children:List.generate(Shop.AllShop.length, (index) =>FrameShops( index),)
                ),
              ),

            ]
        ),
      ),
    );
  }
}