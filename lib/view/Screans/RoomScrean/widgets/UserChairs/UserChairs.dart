import 'package:ahlachat/util/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/ChairWidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/UserChairs/chairLockwidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class UserChair extends StatelessWidget {
  const UserChair({super.key});

  
  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    final chairs = room.Currentroom?.chairs;
    final int chairCount = chairs?.length ?? 0;
    final String currentUserId = UserId?.toString() ?? '';

    if (kDebugMode) {
      final assignedChairs = <String>[];

      for (var i = 0; i < chairCount; i++) {
        final chair = chairs![i];
        final chairUserId = chair.userId?.toString() ?? '';

        if (chairUserId.isNotEmpty) {
          assignedChairs.add(
            'index=$i dbId=${chair.id} '
            'chairId=${chair.chairId} user=$chairUserId',
          );
        }
      }

      final ownChair = chairs?.indexWhere(
        (chair) =>
            chair.userId?.toString() == currentUserId &&
            currentUserId.isNotEmpty,
      ) ?? -1;

      debugPrint(
        '[CHAIR_UI] room=${room.Currentroom?.id} '
        'me=$currentUserId total=$chairCount '
        'myChairIndex=$ownChair '
        'assignments=${assignedChairs.take(12).join('; ')}',
      );
    }

    // Preserve the existing layout: this widget displays the first 8 seats.
    final int visible = chairCount < 8 ? chairCount : 8;

    if (visible == 0) {
      return const SizedBox.shrink();
    }


    return GridView.count(
      padding: const EdgeInsets.only(top: 0),
      shrinkWrap: true,
      cacheExtent: 15.6,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.98,
      crossAxisSpacing: 0.0,
      mainAxisSpacing: 0.0,
      children: List.generate(visible, (index) {
        final chair = chairs![index];
        final String? userId = chair.userId;
        final bool occupied = userId != null && userId.isNotEmpty;

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (occupied)
                Align(
                  alignment: Alignment.center,
                  child: Chairwidget(index: index),
                ),
              if (!occupied)
                Align(
                  alignment: Alignment.center,
                  child: ChairLockwidget(index: index),
                ),
              if (occupied)
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 50),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white54,
                        radius: 10,
                        child: Icon(
                          chair.mute == 0
                              ? Icons.mic
                              : Icons.mic_off_outlined,
                          color: whitecolor,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              if (occupied &&
                  user.imoge.any(
                    (element) =>
                        element['uid'] == int.tryParse(userId) ,
                  ))
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.transparent,
                    child: CachedNetworkImage(
                      imageUrl: user.imoge
                          .where(
                            (element) =>
                                element['uid'] == int.tryParse(userId),
                          )
                          .first['imoge'],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
