import 'package:ahlachat/view/Screans/MainScreans/ShopScrean/Widgets/FrameWidgets.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
class FrameShops extends StatelessWidget {
 int   index1=100;


 FrameShops(this.index1);

  @override
  Widget build(BuildContext context) {

    ShopViewmodel Shops=  Provider.of<ShopViewmodel>(context,listen: true);

    return  CustomScrollView(physics: BouncingScrollPhysics() ,
      slivers: <Widget>[

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio:0.65,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return Framewidgets(items: Shops.AllShop[index1].items?[index],);
            },childCount: Shops.AllShop[index1].items?.length,
          ),
        ),


        //SliverList
      ], //<Widget>[]
    );
  }
}
