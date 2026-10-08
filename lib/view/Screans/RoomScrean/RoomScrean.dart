import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/global_lucky_banner.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/room_background.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/room_lucky_combo_timer.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/room_sidebar_actions.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/room_win_combo_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

// ViewModels
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

// Existing Widgets
import 'package:ahlachat/view/Screans/EnterRoomanimateWidget/EnterRoomanimateWidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GlopalGoft/GlopalGift.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GuessWidgets/GessRoomWidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Admin/AdminChair.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWidge/ChatReversedList.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWidge/ChatWidgets.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/EntryShow/EntryShow.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GiftShow/GiftShow.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/LeaveChairUser/AdminLeaveChair.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/SentGift/SentGift.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/UserChairs.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWedget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Headwidget.dart';

class RoomScrean extends StatefulWidget {
  const RoomScrean({super.key});

  @override
  State<RoomScrean> createState() => _RoomScreanState();
}

class _RoomScreanState extends State<RoomScrean> with TickerProviderStateMixin, WidgetsBindingObserver {
  @override
  void initState() {
    thiss = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RoomViewmodel room = Provider.of<RoomViewmodel>(context, listen: true);
    RoomPlayViewModel roomPlay = Provider.of<RoomPlayViewModel>(context, listen: true);
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        if (room.showloading7) {
          room.hideSpinner7();
        } else if (room.showloading5) {
          room.changeloading5();
        } else if (room.showloading39) {
          room.hideloading39();
        } else if (room.showloading40) {
          room.hideloading40();
        } else if (room.showloading38) {
          room.hideSpinner38();
        } else if (room.showloading33) {
          room.hideSpinner33();
        } else if (room.showloading36) {
          room.hideSpinner36();
        } else if (room.showloading7) {
          room.hideSpinner7();
        } else if (room.showloading29) {
          room.hideSpinner29();
        } else if (room.showloading28) {
          room.hideSpinner28();
        } else {
          roomPlay.changeIsRoomstate(false);
          return true;
        }
        room.hideSpinner7();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            RoomBackground(room: room),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 35),
                  const Headwidget(),
                  const AdminChair(),
                  const UserChair(),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        chatRoom(),
                        if (room.checkadmin(context: context) ||
                            (room.Currentroom?.supervisorsId?.contains(user.userinfo?.id.toString()) ?? false))
                          const RoomSidebarActions(),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const ChatWidgets(),
                ],
              ),
            ),
            const EntryShow(),
            const GiftShow(),
            if (room.selected) Positioned(top: 100, child: EnterAnimateWidget()),
            GlopalGiftWidget(),
            const GlobalLuckyBanner(),
            if (room.guesses.isNotEmpty) GeussRoomWidget(),
            const SendGift(),
            if (!room.showloading7) const SizedBox() else const ChatReversedList(),
            RoomWinComboOverlay(room: room),
            RoomLuckyComboTimer(
              room: room,
              onStateChanged: () => setState(() {}),
            ),
            const LeaveAdminChair(),
            if (user.Luckypackages.isNotEmpty)
              InkWell(
                onTap: () {
                  user.AcceptLuckyPackage(
                    Roomid: room.Currentroom?.id,
                    context: context,
                    Luckyid: user.Luckypackages.first['id'],
                  );
                },
                child: SVGASimpleImage(assetsName: 'assets/image/1665252390.svga'),
              ),
          ],
        ),
      ),
    );
  }
}