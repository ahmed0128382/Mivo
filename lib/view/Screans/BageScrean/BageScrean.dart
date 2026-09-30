
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../util/Localization.dart';
import '../../../util/SizeConfig.dart';
import '../../../util/app_constants.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'Widgets/MyFrames.dart';
class BagScrean extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: true);
    ShopViewmodel Shop=  Provider.of<ShopViewmodel>(context,listen: true);
    return  DefaultTabController(
      length: Shop.AllMyItem.length,
      initialIndex: 0,
      child: Scaffold(backgroundColor:Color(0xFFf6f7f9),
        appBar: AppBar(iconTheme: IconThemeData(color: Colors.black),backgroundColor: Colors.white,title:   Text(getLang( context: context, key: "Bag"),style: style2,),automaticallyImplyLeading: true ),

        body: Container(
          child: Column(
            children: [
              Container(color: Colors.white,
                child: TabBar(    indicator: MaterialIndicator(
                  height: 3,
                  topLeftRadius: 0,
                  topRightRadius: 0,

                  bottomLeftRadius: 5,horizontalPadding: 10,
                  bottomRightRadius: 5,color:MainColor,
                  tabPosition: TabPosition.bottom,
                ),
                    isScrollable: true,
                  labelStyle: style2.copyWith(fontSize: 15) ,
                  unselectedLabelColor: Colors.black45,
                    labelColor:MainColor,
                    onTap: (val) {},

                  tabs:List.generate(Shop.AllMyItem.length, (index) => Tab(
                    text:Shop.AllMyItem[index].name,  ),) ,
                ),
              ),
              Expanded(
                child: TabBarView(
                    children:List.generate(Shop.AllMyItem.length, (index) =>FrameItem( index),)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}