import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'MyFramesWidgets.dart';
class FrameItem extends StatelessWidget {
  int   index1=100;


  FrameItem(this.index1);

  @override
  Widget build(BuildContext context) {

    ShopViewmodel Shop=  Provider.of<ShopViewmodel>(context,listen: true);

    return CustomScrollView(
      slivers: <Widget>[

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:0.75, 
              mainAxisSpacing: 0,
              crossAxisSpacing: 0),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return Frameitemwidgets(items: Shop.AllMyItem[index1].sales?[index].item,create:  Shop.AllMyItem[index1].sales?[index].createdAt,update_at:  Shop.AllMyItem[index1].sales?[index].updatedAt);
            },childCount: Shop.AllMyItem[index1].sales?.length,
          ),
        ),


      ], //<Widget>[]
    );
  }
}
