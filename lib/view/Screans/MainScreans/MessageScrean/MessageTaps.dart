import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/view/Screans/SearchScrean/SearchScrean.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
class MessageTaps extends StatefulWidget {
  const MessageTaps({Key? key}) : super(key: key);

  @override
  State<MessageTaps> createState() => _MessageTapsState();
}

class _MessageTapsState extends State<MessageTaps>with SingleTickerProviderStateMixin{


  int ?viewicon=0;
  late TabController _tabController;
  bool _swipeIsInProgress = false;
  bool _tapIsBeingExecuted = false;
  int _selectedIndex = 0;
  int _prevIndex = 1;


  @override
  void initState() {
    super.initState();


    _tabController = TabController(initialIndex: _selectedIndex, length: 1, vsync: this);
    _tabController.animation?.addListener(() {
      print(_tabController.index);
      if (!_tapIsBeingExecuted &&
          !_swipeIsInProgress &&
          (_tabController.offset >= 0.5 || _tabController.offset <= -0.5)) {
        // detects if a swipe is being executed. limits set to 0.5 and -0.5 to make sure the swipe gesture triggered

        int newIndex = _tabController.offset > 0 ? _tabController.index + 1 : _tabController.index - 1;

        _swipeIsInProgress = true;
        _prevIndex = _selectedIndex;
        setState(() {
          _selectedIndex = newIndex;
          viewicon=newIndex;
        });
        print(_selectedIndex);
        // if(_selectedIndex==1){
        //
        // }

      } else {
        if (!_tapIsBeingExecuted &&
            _swipeIsInProgress &&
            ((_tabController.offset < 0.5 && _tabController.offset > 0) ||
                (_tabController.offset > -0.5 && _tabController.offset < 0))) {
          // detects if a swipe is being reversed. the

          _swipeIsInProgress = false;
          setState(() {
            _selectedIndex = _prevIndex;
          });
        }
      }
    });
    _tabController.addListener(() {
      _swipeIsInProgress = false;
      setState(() {
        _selectedIndex = _tabController.index;
      });
      if (_tapIsBeingExecuted == true) {
        _tapIsBeingExecuted = false;
      } else {
        if (_tabController.indexIsChanging) {
          // this is only true when the tab is changed via tap
          _tapIsBeingExecuted = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: true);

    return DefaultTabController(
      length:1,
      child: Scaffold(backgroundColor: Colors.transparent
          ,appBar: AppBar(backgroundColor: Colors.transparent,titleSpacing: 0,automaticallyImplyLeading: false,
        title:  Builder(
            builder: (context) {
              return Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Expanded(
                    child: TabBar(  indicator: MaterialIndicator(
                      height: 5,
                      topLeftRadius: 0,
                      topRightRadius: 0,
                      bottomLeftRadius: 5,horizontalPadding: 25,
                      bottomRightRadius: 5,
                      tabPosition: TabPosition.bottom,
                    ),
                        isScrollable: true,controller: _tabController,
                        labelStyle: style2,
                        unselectedLabelColor: Colors.black45,
                        labelColor: Colors.black,
                        onTap: (val){

                          viewicon=val;

                          setState(() {

                          });
                        },

                        tabs:    [
                          Tab(
                            text: getLang( context: context, key: "Messages"),
                          ),


                        ]
                    ),
                  ),

                  //   if(viewicon==1)

                    IconButton(
                    icon: Image.asset(Images.SearchIcon,height: 25),
                    onPressed: (){
                      Room.SearchController.clear();
                      Room.SearchRooms.clear();
                      navigateTo(context: context,screen: SearchScrean());

                    },
                  ),
                ],
              );
            }
        ),
      ),
          body:  Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TabBarView(controller: _tabController,children: [
              MessageScrean(),

            ],),
          )
      ),

    );
  }

}
