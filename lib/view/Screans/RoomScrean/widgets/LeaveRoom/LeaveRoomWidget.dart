
import 'package:flutter/material.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class LeaveRoomWidget extends StatelessWidget {
  const LeaveRoomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final svga = Provider.of<SvgViewmodel>(context, listen: false);

    final room = Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    final roomPlay = Provider.of<RoomPlayViewModel>(
      context,
      listen: false,
    );

    return Container(
      color: Colors.black45,
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      roomPlay.changeIsRoomstate(false);
                      svga.dispose();

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          Images.SaveRoom,
                          width: 80,
                          height: 80,
                        ),
                        Text(
                          getLang(
                            context: context,
                            key: 'Minimize',
                          ),
                          style: style3.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      // Start the operation while this context is still active.
                      // Leaveroom captures its dependencies before awaiting.
                      final leaveFuture = room.Leaveroom(
                        context: context,
                      );

                      roomPlay.changeHasRoomstate(false);
                      roomPlay.changeIsRoomstate(false);
                      JoinChairs = false;

                      svga.dispose();

                      // Preserve the existing navigation behavior.
                      Navigator.pop(context);
                      Navigator.pop(context);

                      // Observe any unexpected error without using this
                      // widget's context after its routes have been popped.
                      leaveFuture.catchError((Object error, StackTrace stack) {
                        debugPrint(
                          '[ROOM_LEAVE_WIDGET] Unexpected leave error: $error',
                        );
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/image/ic_audio_room_exit.png',
                          width: 80,
                          height: 80,
                        ),
                        Text(
                          getLang(
                            context: context,
                            key: 'Leave',
                          ),
                          style: style3.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
