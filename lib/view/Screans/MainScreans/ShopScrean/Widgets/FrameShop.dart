import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ahlachat/view/Screans/MainScreans/ShopScrean/Widgets/FrameWidgets.dart';
import '../../../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';

class FrameShops extends StatelessWidget {
  final int index1;

  const  FrameShops([this.index1 = 100]);

  @override
  Widget build(BuildContext context) {
    ShopViewmodel shops = Provider.of<ShopViewmodel>(context, listen: true);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.58, // Increased vertical height ratio to prevent grid overflow
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Framewidgets(
                items: shops.AllShop[index1].items?[index],
              );
            },
            childCount: shops.AllShop[index1].items?.length ?? 0,
          ),
        ),
      ],
    );
  }
}