import 'dart:convert';

import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/view/Screans/RoomScrean/CollectKarismaUser.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/RoomUserProfile.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/SendGift.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class Chairwidget extends StatelessWidget {
  final int index;

  const Chairwidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room = Provider.of<RoomViewmodel>(
      context,
      listen: true,
    );

    final LoginViewmodel user = Provider.of<LoginViewmodel>(
      context,
      listen: true,
    );

    final GiftsViewModel gifts = Provider.of<GiftsViewModel>(
      context,
      listen: true,
    );

    final AgoraViewmodel agora = Provider.of<AgoraViewmodel>(
      context,
      listen: true,
    );

    final chair = room.Currentroom?.chairs?[index];

    final int chairUserId = int.tryParse(
          chair?.userId?.toString() ?? '0',
        ) ??
        0;

    final bool isSpeaking = chairUserId != 0 &&
        agora.isUserSpeaking(chairUserId) &&
        chair?.mute == 0;

    return PopupMenuButton(
      color: Colors.black,
      padding: EdgeInsets.zero,
      iconSize: 100,

      itemBuilder: (BuildContext bc) {
        return [
          _buildPopupMenuItem(
            title: getLang(
              context: context,
              key: "Profile",
            ),
            iconData: Icons.person,
            val: 0,
          ),

          _buildPopupMenuItem(
            title: getLang(
              context: context,
              key: "Send_Gifts",
            ),
            iconData: Icons.wallet_giftcard,
            val: 1,
          ),

          if (room.checkadmin(context: context) ||
              (
                room.Currentroom?.supervisorsId?.contains(
                      user.userinfo?.id.toString(),
                    ) ??
                    false
              ) &&
                  !(
                    room.Currentroom?.supervisorsId?.contains(
                          room.Currentroom?.chairs?[index].user?.id.toString(),
                        ) ??
                        false
                  ))
            _buildPopupMenuItem(
              title: chair?.mute == 0
                  ? getLang(
                      context: context,
                      key: "mute",
                    )
                  : getLang(
                      context: context,
                      key: "unmute",
                    ),
              iconData: chair?.mute == 0
                  ? Icons.mic_none
                  : Icons.mic_off_outlined,
              val: 2,
            ),

          if (room.checkadmin(context: context))
            _buildPopupMenuItem(
              title: room.Currentroom?.supervisorsId?.contains(
                        chair?.user?.id.toString(),
                      ) ??
                      false
                  ? getLang(
                      key: "Remove_Admin",
                      context: context,
                    )
                  : getLang(
                      key: "Add_Admin",
                      context: context,
                    ),
              iconData: Icons.star,
              val: 5,
            ),

          if (room.checkadmin(context: context) ||
              chair?.userId == user.userinfo?.id.toString())
            _buildPopupMenuItem(
              title: getLang(
                key: "Leave_Chair",
                context: context,
              ),
              iconData: Icons.chair_outlined,
              val: 3,
            ),

          if (room.checkadmin(context: context) ||
              (
                room.Currentroom?.supervisorsId?.contains(
                      user.userinfo?.id.toString(),
                    ) ??
                    false
              ) &&
                  !(
                    room.Currentroom?.supervisorsId?.contains(
                          chair?.user?.id.toString(),
                        ) ??
                        false
                  ))
            _buildPopupMenuItem(
              title: getLang(
                key: "Room_kick",
                context: context,
              ),
              iconData: Icons.output_outlined,
              val: 4,
            ),
        ];
      },

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),

      onSelected: (value) {
        if (value == 0) {
          room.Chairids = chair?.chairId;
          room.ChairIndes = index;
          room.useridchair = chair?.user?.id;

          user.userinfoRoom(
            context: context,
            id: chair?.user?.id,
          );

          user.getuserroominfo(
            user: chair?.user,
          );

          GlopalbottomSheet(
            context: context,
            Screan: const RoomUserProfile(),
          );
        }

        // SEND GIFT
        else if (value == 1) {
          gifts.GiftList.clear();
          gifts.giftprice = 0;

          room.ChairsRoom.clear();
          room.UserIds.clear();

          room.AddUserIds(
            id: chair?.user?.id,
          );

          room.ChairsRoom.clear();

          room.Currentroom?.chairs?.forEach(
            (element) {
              if (element.userId != null &&
                  element.userId.toString() !=
                      user.userinfo?.id.toString() &&
                  element.user != null) {
                room.ChairsRoom.add(element);
              }
            },
          );

          gifts.Cost = 0;

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
              return const NestedTabBar();
            },
          );
        }

        // MUTE / UNMUTE
        else if (value == 2) {
          if (chair?.mute == 0) {
            room.updatemute(
              context: context,
              state: 1,
              user_id: chair?.user?.id,
            );
          } else {
            room.updatemute(
              context: context,
              state: 0,
              user_id: chair?.user?.id,
            );
          }

          agora.mutebyuid(
            uid: chair?.user?.id,
            context: context,
          );
        }

        // LEAVE CHAIR
        else if (value == 3) {
          room.ChairIndes = index;
          room.Chairids = chair?.chairId;
          room.useridchair = chair?.user?.id;

          room.LeaveuserChair(
            context: context,
          );
        }

        // KICK
        else if (value == 4) {
          room.Evictionuser(
            Userid: chair?.user?.id,
            context: context,
          );
        }

        // ADMIN
        else if (value == 5) {
          if (room.Currentroom?.supervisorsId?.contains(
                chair?.user?.id.toString(),
              ) ??
              false) {
            room.RemovesupervisorsRoom(
              context: context,
              userid: chair?.user?.id,
            ).toString();
          } else {
            room.AddsupervisorsRoom(
              context: context,
              userid: chair?.user?.id.toString(),
            );
          }
        }
      },

      icon: Stack(
        alignment: Alignment.center,
        children: [
          // ============================================================
          // AGORA SPEAKING INDICATOR
          // ============================================================
          if (isSpeaking)
            Positioned(
              top: 0,
              child: AvatarGlow(
                glowColor: Colors.tealAccent,
                glowRadiusFactor: 1.2,
                glowCount: 2,
                duration: const Duration(
                  milliseconds: 1000,
                ),
                repeat: true,
                animate: true,
                child: const SizedBox(
                  width: 70,
                  height: 70,
                ),
              ),
            ),

          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserFrame(
                image: chair?.userId.toString() ==
                        user.userinfo?.id.toString()
                    ? user.userinfo?.image
                    : chair?.user?.image,
                Frame: chair?.userId.toString() ==
                        user.userinfo?.id.toString()
                    ? user.userinfo?.frameimage
                    : chair?.user?.frameimage,
              ),

              SizedBox(
                width: 50,
                child: Center(
                  child: Text(
                    jsonDecode(
                      jsonEncode(
                        chair?.user?.name ?? '',
                      ),
                    ),
                    style: Namestyle.copyWith(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 9,
                      height: 1,
                      color: whitecolor,
                    ),
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  GlopalbottomSheet(
                    context: context,
                    Screan: const UserCollectKarismas(),
                  );

                  room.GetCollectKarisma(
                    context: context,
                    userid: chair?.userId,
                    chairid: chair?.id,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Helper().k_m_b_generator(
                          chair?.Karisma,
                        ),
                        style: style2.copyWith(
                          fontSize: 10,
                          height: 1,
                          color: whitecolor,
                        ),
                      ),

                      const SizedBox(
                        width: 3,
                      ),

                      const FaIcon(
                        FontAwesomeIcons.heartCircleCheck,
                        size: 8,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

PopupMenuItem _buildPopupMenuItem({
  String? title,
  IconData? iconData,
  int? val,
}) {
  return PopupMenuItem(
    value: val,
    height: 30,
    padding: EdgeInsets.zero,
    child: Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        Icon(
          iconData,
          color: Colors.white,
          size: 14,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          title ?? '',
          style: style5.copyWith(
            color: Colors.white,
            height: 1,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}
