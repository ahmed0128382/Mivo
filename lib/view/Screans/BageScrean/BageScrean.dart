
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../util/Localization.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'Widgets/MyFrames.dart';

class BagScrean extends StatelessWidget {
  const BagScrean({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopViewmodel>(context);

    final categories = shop.AllMyItem;

    return Scaffold(
      backgroundColor: const Color(0xFFf6f7f9),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          getLang(context: context, key: 'Bag'),
          style: style2,
        ),
        automaticallyImplyLeading: true,
      ),
      body: categories.isEmpty
          ? Center(
              child: Text(
                getLang(context: context, key: 'NoItems'),
                style: style2.copyWith(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            )
          : DefaultTabController(
              length: categories.length,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      indicator: MaterialIndicator(
                        height: 3,
                        topLeftRadius: 0,
                        topRightRadius: 0,
                        bottomLeftRadius: 5,
                        bottomRightRadius: 5,
                        horizontalPadding: 10,
                        color: MainColor,
                        tabPosition: TabPosition.bottom,
                      ),
                      isScrollable: true,
                      labelStyle: style2.copyWith(fontSize: 15),
                      unselectedLabelColor: Colors.black45,
                      labelColor: MainColor,
                      tabs: categories.map((category) {
                        return Tab(
                          text: category.name ?? '',
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: List.generate(
                        categories.length,
                        (index) => FrameItem(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
