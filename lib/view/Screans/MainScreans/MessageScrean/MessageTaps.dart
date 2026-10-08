import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/view/Screans/SearchScrean/SearchScrean.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class MessageTaps extends StatefulWidget {
  const MessageTaps({Key? key}) : super(key: key);

  @override
  State<MessageTaps> createState() => _MessageTapsState();
}

class _MessageTapsState extends State<MessageTaps>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 1,
      initialIndex: 0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openSearch() {
    final room = Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    room.SearchController.clear();
    room.SearchRooms.clear();

    navigateTo(
      context: context,
      screen: SearchScrean(),
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

                // There is only one tab.
                // Do not make the TabBar horizontally scrollable.
                isScrollable: false,

                indicator: MaterialIndicator(
                  height: 5,
                  topLeftRadius: 0,
                  topRightRadius: 0,
                  bottomLeftRadius: 5,
                  bottomRightRadius: 5,

                  // Keep this safely below half of the tab width.
                  horizontalPadding: 8,

                  tabPosition: TabPosition.bottom,
                ),

                labelStyle: style2,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black45,

                tabs: [
                  Tab(
                    text: getLang(
                      context: context,
                      key: "Messages",
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              icon: Image.asset(
                Images.SearchIcon,
                height: 25,
              ),
              onPressed: _openSearch,
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TabBarView(
          controller: _tabController,
          children: [
            MessageScrean(),
          ],
        ),
      ),
    );
  }
}