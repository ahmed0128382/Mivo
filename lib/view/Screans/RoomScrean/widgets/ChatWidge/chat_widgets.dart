
import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/view/Screans/RolletUserScrean/RolletUserScrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GuessWidgets/GuessWidgets.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/emoji/emojisscrean.dart';
import 'package:ahlachat/view/widgets/WebViewScrean.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GiftBox/GiftBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatWidgets extends StatelessWidget {
  const ChatWidgets({super.key});

  /// Get actual room participants from RoomViewmodel.
  ///
  /// RoomViewmodel.joinuserRooms is populated from the room-members API.
  /// Do not use chair occupancy to determine membership.
  List<dynamic> _getRoomMembers(RoomViewmodel room) {
    return List<dynamic>.from(room.joinuserRooms);
  }

  String _memberId(dynamic membership) {
    return membership.user?.id?.toString() ?? '';
  }

  String _memberName(dynamic membership) {
    return membership.user?.name?.toString() ?? '';
  }

  String _memberImage(dynamic membership) {
    return membership.user?.image?.toString() ?? '';
  }

  bool _isRoomMember({
    required List<dynamic> members,
    required String currentUserId,
  }) {
    if (currentUserId.isEmpty) return false;

    return members.any(
      (membership) => _memberId(membership) == currentUserId,
    );
  }

  void _openAudioAndMessagesSheet({
    required BuildContext context,
    required RoomViewmodel room,
    required LoginViewmodel user,
    required AgoraViewmodel agora,
  }) {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(sheetContext);

                  if (!agora.disableAudio) {
                    agora.closeroomvoice();
                  } else {
                    agora.enableroomvoice();
                  }
                },
                child: Image.asset(
                  agora.disableAudio
                      ? 'assets/image/ic_hk_tool_mute_off.png'
                      : 'assets/image/ic_music_no_mute_voice.png',
                  height: 40,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(sheetContext);

                  Provider.of<InboxroomViewModel>(
                    context,
                    listen: false,
                  ).GetInboxroom(context: context);

                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.white,
                    isScrollControlled: false,
                    barrierColor: Colors.black.withAlpha(1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    builder: (_) => MessageScrean(),
                  );

                  user.changeNewmessage(false);
                },
                child: Image.asset(
                  'assets/image/icons8-messages-200.png',
                  height: 50,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openEmojiSheet(
    BuildContext context,
    LoginViewmodel user,
  ) {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (_) => const EmojiTabBar(),
    );
  }

  void _openEntertainmentSheet({
    required BuildContext context,
    required RoomViewmodel room,
    required LoginViewmodel user,
    required List<dynamic> members,
  }) {
    showModalBottomSheet<void>(
      context: context,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'القسم الترفيهي',
                  style: style1,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Fruits game.
                    InkWell(
                      onTap: () {
                        Navigator.pop(sheetContext);

                        showModalBottomSheet<void>(
                          context: context,
                          barrierColor: Colors.black.withAlpha(1),
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => SizedBox(
                            height: 600,
                            child: WebViewRollet(
                              name: getLang(
                                context: context,
                                key: 'Terms_Service',
                              ),
                              link:
                                  'http://game.worldchat.online/?token=${user.userinfo?.rememperToken}',
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        Images.fruits,
                        height: 60,
                        width: 60,
                        fit: BoxFit.fill,
                      ),
                    ),

                    // Dice game.
                    InkWell(
                      onTap: () {
                        Navigator.pop(sheetContext);
                        room.Playdice(context: context);
                      },
                      child: Image.asset(
                        Images.dice,
                        height: 60,
                        width: 60,
                        fit: BoxFit.fill,
                      ),
                    ),

                    // Roulette: use room members, not chairs.
                    InkWell(
                      onTap: () {
                        Navigator.pop(sheetContext);

                        room.Rolletchoice.clear();

                        final eligibleMembers = members
                            .where(
                              (membership) =>
                                  _memberId(membership).isNotEmpty &&
                                  _memberName(membership).isNotEmpty,
                            )
                            .toList();

                        showModalBottomSheet<void>(
                          context: context,
                          barrierColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          builder: (rouletteContext) {
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                    image: DecorationImage(
                                      image: ExactAssetImage(
                                        Images.VipBackground,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  width: SizeConfig.screenWidth,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount:
                                              eligibleMembers.length,
                                          itemBuilder: (context, index) {
                                            final membership =
                                                eligibleMembers[index];
                                            final name =
                                                _memberName(membership);
                                            final selected =
                                                room.Rolletchoice.contains(
                                              name,
                                            );

                                            return Padding(
                                              padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                horizontal: 20,
                                              ).copyWith(top: 10),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (selected) {
                                                      room.RemoveRolletchoice(
                                                        name,
                                                      );
                                                    } else {
                                                      room.AddRolletchoice(
                                                        name,
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration:
                                                      BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    horizontal: 20,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        name,
                                                        style: style1
                                                            .copyWith(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Icon(
                                                        selected
                                                            ? Icons
                                                                .check_box
                                                            : Icons
                                                                .check_box_outline_blank_outlined,
                                                        color:
                                                            Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            if (room.Rolletchoice.length >=
                                                2) {
                                              Navigator.pop(
                                                rouletteContext,
                                              );

                                              showModalBottomSheet<void>(
                                                context: context,
                                                barrierColor:
                                                    Colors.transparent,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius
                                                          .vertical(
                                                    top: Radius.circular(
                                                      30,
                                                    ),
                                                  ),
                                                ),
                                                builder: (_) =>
                                                    const RolletFullscrean(),
                                              );
                                            } else {
                                              Dialogs().showtoast(
                                                'عدد الاشخاص يجب ان يكون 2 او اكثر',
                                              );
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            width:
                                                SizeConfig.screenWidth,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                10,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              getLang(
                                                context: context,
                                                key: 'Start',
                                              ),
                                              style: style2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        Images.Rolletuser,
                        height: 60,
                        width: 60,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Guessing game.
                    InkWell(
                      onTap: () {
                        Navigator.pop(sheetContext);

                        user.SelectGuess(val: null);
                        user.SelectGuesscoins(val: null);

                        showModalBottomSheet<void>(
                          context: context,
                          barrierColor: Colors.transparent,
                          backgroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          builder: (_) => GuessWidgets(),
                        );
                      },
                      child: Image.asset(
                        Images.guessing,
                        height: 60,
                        width: 60,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Toggles the local microphone and synchronizes the mute state.
  ///
  /// checkmute() is not defined in RoomViewmodel, so this uses the
  /// existing AgoraViewmodel.muted state instead.
  void _toggleMicrophone({
    required BuildContext context,
    required RoomViewmodel room,
    required AgoraViewmodel agora,
  }) {
    if (agora.muted == true) {
      agora.UnMute();

      room.updatemute(
        context: context,
        state: 0,
        user_id: UserId,
      );
    } else {
      room.updatemute(
        context: context,
        state: 1,
        user_id: UserId,
      );

      agora.Mute();
    }
  }

  @override
  Widget build(BuildContext context) {
    final room = Provider.of<RoomViewmodel>(context);
    final user = Provider.of<LoginViewmodel>(context);
    final agora = Provider.of<AgoraViewmodel>(context);

    // This is the membership list on RoomViewmodel, populated by
    // GetJoinUsers. It is not RoomModel.joinuserRooms.
    final members = _getRoomMembers(room);

    final currentUserId = user.userinfo?.id?.toString() ?? '';

    final isMember = _isRoomMember(
      members: members,
      currentUserId: currentUserId,
    );

    final canUseRoomControls =
        isMember || room.checkadmin(context: context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Container(
        width: SizeConfig.screenWidth!,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Room audio and messages.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                onTap: () => _openAudioAndMessagesSheet(
                  context: context,
                  room: room,
                  user: user,
                  agora: agora,
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    agora.disableAudio
                        ? 'assets/image/ic_hk_tool_mute_off.png'
                        : 'assets/image/ic_music_no_mute_voice.png',
                    height: 27,
                  ),
                ),
              ),
            ),

            // Say hi, mention, emoji and entertainment controls.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: GestureDetector(
                onTap: () {
                  room.ChairMaps.clear();
                  room.ClearMentionid();

                  for (final membership in members) {
                    final memberId = _memberId(membership);

                    if (memberId.isEmpty ||
                        memberId == currentUserId) {
                      continue;
                    }

                    room.ChairMaps.add({
                      'id': memberId,
                      'display': _memberName(membership),
                      'full_name': _memberImage(membership),
                    });
                  }

                  room.showSpinner7();
                },
                child: Container(
                  height: 37,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: whitecolor4,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Text(
                        getLang(
                          context: context,
                          key: 'Say_hi',
                        ),
                        style: style6.copyWith(
                          fontSize: 13,
                          height: 1,
                          color: whitecolor2,
                        ),
                      ),
                      const SizedBox(width: 20),
                      if (canUseRoomControls)
                        InkWell(
                          onTap: () => _openEmojiSheet(
                            context,
                            user,
                          ),
                          child: Image.asset(
                            Images.imoje,
                            width: 22,
                            height: 22,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 10),
                      if (canUseRoomControls)
                        InkWell(
                          onTap: () => _openEntertainmentSheet(
                            context: context,
                            room: room,
                            user: user,
                            members: members,
                          ),
                          child: Image.asset(
                            Images.entertainment,
                            width: 23,
                            height: 23,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Microphone control.
            if (canUseRoomControls)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () => _toggleMicrophone(
                    context: context,
                    room: room,
                    agora: agora,
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      agora.muted
                          ? 'assets/image/ic_multi_live_mute_on.png'
                          : 'assets/image/ic_multi_live_mute_nor.png',
                      height: 30,
                    ),
                  ),
                ),
              ),

            const GiftBox(),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
