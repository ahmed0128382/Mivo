import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class GlobalLuckyBanner extends StatelessWidget {
  const GlobalLuckyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final GiftsViewModel glopalGift = Provider.of<GiftsViewModel>(context, listen: true);
    final RoomViewmodel room = Provider.of<RoomViewmodel>(context, listen: false);

    return AnimatedPositioned(
      width: glopalGift.GlobalLuckystate ? 500 : 0,
      height: 100.0,
      top: 50.0,
      duration: const Duration(seconds: 2),
      curve: Curves.easeIn,
      onEnd: () {
        if (glopalGift.GlobalLuckystate) {
          Provider.of<GiftsViewModel>(context, listen: false).HiddeGlobalLucky();
        }
      },
      child: InkWell(
        onTap: () {
          if (glopalGift.GlopelLuckyRoomid == room.Currentroom?.id.toString()) {
            // Already in room
          } else {
            room.EnterRoom2(context: context, id: glopalGift.GlopelLuckyRoomid);
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('assets/image/d6.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 20,
                        backgroundImage: CachedNetworkImageProvider(
                          glopalGift.SenderLucky?.image ?? Images.userphoto,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            glopalGift.SenderLucky?.name ?? '',
                            style: Namestyle2.copyWith(fontSize: 12),
                          ),
                          Text(
                            " ضرب كيس حظ في ${glopalGift.GlopelLuckyRoomname}",
                            style: style1.copyWith(fontSize: 12),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Image.asset(Images.LuckyPrize, height: 70),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}