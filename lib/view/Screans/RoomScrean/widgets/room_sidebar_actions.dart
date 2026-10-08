import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/MusicPlayer.dart';

class RoomSidebarActions extends StatelessWidget {
  const RoomSidebarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (user.Newmessage)
            InkWell(
              onTap: () {
                Provider.of<InboxroomViewModel>(context, listen: false).GetInboxroom(context: context);
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: false,
                  barrierColor: Colors.black.withAlpha(1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return MessageScrean();
                  },
                );
                user.changeNewmessage(false);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: ExactAssetImage('assets/image/ezgif.com-crop.gif'),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                barrierColor: Colors.transparent,
                backgroundColor: Colors.black,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                context: context,
                builder: (context) {
                  return const MusicPlayerRoom();
                },
              );
            },
            child: Image.asset('assets/image/ic_music_empty.png', height: 40),
          ),
        ],
      ),
    );
  }
}