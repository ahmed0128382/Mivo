
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/view/Screans/Layouts/widgets/AddPost.dart';
import 'package:ahlachat/view/Screans/MainScreans/Explore/FollowingMoment.dart';
import 'package:ahlachat/view/Screans/MainScreans/Explore/RecommendedMoments.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../../util/images.dart';
import '../../../../../util/styles.dart';

class ExploreTaps extends StatefulWidget {
  const ExploreTaps({Key? key}) : super(key: key);

  @override
  State<ExploreTaps> createState() => _ExploreTapsState();
}

class _ExploreTapsState extends State<ExploreTaps>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      initialIndex: _selectedIndex,
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    final newIndex = _tabController.index;

    if (_selectedIndex != newIndex && mounted) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _openAddPost() {
    GlopalbottomSheet(
      context: context,
      Screan: AddPostScrean(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,

        title: Row(
          children: [
            Expanded(
              child: TabBar(
                controller: _tabController,

                // There are only two tabs.
                // Give both tabs equal available space.
                isScrollable: false,

                indicator: MaterialIndicator(
                  height: 5,
                  topLeftRadius: 0,
                  topRightRadius: 0,
                  bottomLeftRadius: 5,
                  bottomRightRadius: 5,
                  horizontalPadding: 15,
                  tabPosition: TabPosition.bottom,
                ),

                labelStyle: style2,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black45,

                tabs: [
                  Tab(
                    text: getLang(
                      context: context,
                      key: "Recommended",
                    ),
                  ),
                  Tab(
                    text: getLang(
                      context: context,
                      key: "Following",
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Image.asset(
                Images.AddMoment,
                height: 25,
              ),
              onPressed: _openAddPost,
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TabBarView(
          controller: _tabController,
          children: const [
            RecommendedMoments(),
            FollowingMoments(),
          ],
        ),
      ),
    );
  }
}
