import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class SearchScrean extends StatefulWidget {
  const SearchScrean({Key? key}) : super(key: key);

  @override
  State<SearchScrean> createState() => _SearchScreanState();
}

class _SearchScreanState extends State<SearchScrean> {
  final TextEditingController UserSearchController =
      TextEditingController();

  final TextEditingController RoomSearchController =
      TextEditingController();

  @override
  void dispose() {
    UserSearchController.dispose();
    RoomSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel Rooms = Provider.of<RoomViewmodel>(
      context,
      listen: true,
    );

    final LoginViewmodel user = Provider.of<LoginViewmodel>(
      context,
      listen: true,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search',
          style: style4.copyWith(
            height: 1,
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: false,

              indicator: MaterialIndicator(
                height: 3,
                topLeftRadius: 0,
                topRightRadius: 0,
                bottomLeftRadius: 5,
                bottomRightRadius: 5,

                // The previous value (25) combined with the
                // indicatorPadding could make the indicator
                // larger than the tab itself.
                horizontalPadding: 8,

                tabPosition: TabPosition.bottom,
              ),

              labelStyle: style2.copyWith(
                fontSize: 13,
              ),
              unselectedLabelColor: Colors.black45,
              labelColor: Colors.black,

              tabs: [
                Tab(
                  text: getLang(
                    context: context,
                    key: "Search_User",
                  ),
                ),
                Tab(
                  text: getLang(
                    context: context,
                    key: "Search_room",
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBarView(
                  children: [
                    TextFormField(
                      controller: UserSearchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onEditingComplete: () {
                        if (UserSearchController.text.isNotEmpty) {
                          user.SearchGetusers(
                            context: context,
                            text: UserSearchController.text,
                          );
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon:
                            UserSearchController.text.isEmpty
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () {
                                      UserSearchController.clear();
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      color: Colors.black45,
                                      size: 22,
                                    ),
                                  ),
                        prefixIcon: const Icon(
                          Icons.search_outlined,
                          color: Colors.black45,
                          size: 22,
                        ),
                        hintText: "User ID or Nickname",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                        border: InputBorder.none,
                      ),
                    ),

                    TextFormField(
                      controller: RoomSearchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onEditingComplete: () {
                        if (RoomSearchController.text.isNotEmpty) {
                          Rooms.SearchGetRoom(
                            context: context,
                            text: RoomSearchController.text,
                          );
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon:
                            RoomSearchController.text.isEmpty
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () {
                                      RoomSearchController.clear();
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                      color: Colors.black45,
                                      size: 22,
                                    ),
                                  ),
                        prefixIcon: const Icon(
                          Icons.search_outlined,
                          color: Colors.black45,
                          size: 22,
                        ),
                        hintText: "Search By ID or name",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                        border: InputBorder.none,
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