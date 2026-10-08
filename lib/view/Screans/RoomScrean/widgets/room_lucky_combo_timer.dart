import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class RoomLuckyComboTimer extends StatelessWidget {
  final RoomViewmodel room;
  final VoidCallback onStateChanged;

  const RoomLuckyComboTimer({
    super.key,
    required this.room,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);

    if (!room.showcombo) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {
          if (room.Combocost < (user.userinfo?.coins ?? 0)) {
            room.SentCompoLuckyGift(context: context);
            room.Timercontroller.restart();
            onStateChanged();
          } else {
            Dialogs().showtoast(getLang(context: context, key: "Not_Enough"));
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('assets/image/combo2.png', width: 100),
            Positioned(
              bottom: 5,
              child: Countdown(
                controller: room.Timercontroller,
                seconds: 5,
                build: (_, double time) => Text(
                  time.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                interval: const Duration(milliseconds: 100),
                onFinished: () {
                  room.HideLuckyCombo();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}