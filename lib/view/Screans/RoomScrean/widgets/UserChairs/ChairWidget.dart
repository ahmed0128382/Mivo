import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/SendGift.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Legacy filename/class name retained for existing imports.
///
/// The index now refers to room.joinuserRooms, not a chair position.
class Chairwidget extends StatelessWidget {
  final int index;

  const Chairwidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);
    final LoginViewmodel login =
        Provider.of<LoginViewmodel>(context, listen: true);
    final GiftsViewModel gifts =
        Provider.of<GiftsViewModel>(context, listen: true);
    final AgoraViewmodel agora =
        Provider.of<AgoraViewmodel>(context, listen: true);

    if (index < 0 || index >= room.joinuserRooms.length) {
      return const SizedBox.shrink();
    }

    final dynamic membership = room.joinuserRooms[index];
    final dynamic participant = membership.user;

    if (participant == null) {
      return const SizedBox.shrink();
    }

    final String participantId = (participant.id ?? '').toString();
    final String currentUserId =
        (login.userinfo?.id ?? '').toString();
    final String hostId =
        (room.Currentroom?.adminId ?? '').toString();

    final bool isHost = participantId == hostId;
    final bool isCurrentUser = participantId == currentUserId;
    final bool isModerator = room.Currentroom?.supervisorsId
            ?.contains(participantId) ??
        false;
    final bool currentUserIsModerator =
        room.Currentroom?.supervisorsId?.contains(currentUserId) ??
            false;

    final bool canModerate =
        room.checkadmin(context: context) || currentUserIsModerator;
    final bool canManageModerators =
        room.checkadmin(context: context);

    final int? participantNumericId =
        int.tryParse(participantId);

    final bool isMuted =
        room.Mutedids.contains(participant.id);

    final bool isSpeaking = participantNumericId != null &&
        agora.isUserSpeaking(participantNumericId) &&
        !isMuted;

    final bool canModerateThisParticipant =
        !isCurrentUser &&
        !isHost &&
        !(currentUserIsModerator && isModerator);

    return PopupMenuButton<int>(
      color: const Color(0xFF171A24),
      padding: EdgeInsets.zero,
      tooltip: participant.name?.toString() ?? 'Participant',
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF303747)),
      ),
      onSelected: (value) async {
        switch (value) {
          case 0:
            login.GetShoweduserProfile(participant);
            CheckBlocked = false;
            Navigator.pushNamed(
              context,
              AppConstants.ShowUser_Profile,
            );
            break;

          case 1:
            gifts.GiftList.clear();
            gifts.giftprice = 0;
            room.UserIds.clear();
            room.AddUserIds(id: participant.id);
            gifts.Cost = 0;

            showModalBottomSheet(
              context: context,
              barrierColor: Colors.black54,
              backgroundColor: const Color(0xFF11141D),
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
              ),
              builder: (_) => const NestedTabBar(),
            );
            break;

          case 2:
            if (!canModerateThisParticipant || !canModerate) {
              return;
            }

            await room.updatemute(
              context: context,
              state: isMuted ? 0 : 1,
              user_id: participant.id,
            );

            agora.mutebyuid(
              uid: participant.id,
              context: context,
            );
            break;

          case 3:
            if (!canManageModerators ||
                isHost ||
                isCurrentUser) {
              return;
            }

            if (isModerator) {
              await room.RemovesupervisorsRoom(
                context: context,
                userid: participant.id,
              );
            } else {
              await room.AddsupervisorsRoom(
                context: context,
                userid: participantId,
              );
            }
            break;

          case 4:
            if (!canModerateThisParticipant || !canModerate) {
              return;
            }

            Navigator.pop(context);
            room.Evictionuser(
              Userid: participant.id,
              context: context,
            );
            break;
        }
      },
      itemBuilder: (context) => [
        _menuItem(
          value: 0,
          icon: Icons.person_outline,
          title: getLang(context: context, key: 'Profile'),
        ),
        if (!isCurrentUser)
          _menuItem(
            value: 1,
            icon: Icons.card_giftcard,
            title: getLang(context: context, key: 'Send_Gifts'),
          ),
        if (canModerateThisParticipant && canModerate)
          _menuItem(
            value: 2,
            icon: isMuted ? Icons.mic_off : Icons.mic_none,
            title: getLang(
              context: context,
              key: isMuted ? 'unmute' : 'mute',
            ),
          ),
        if (canManageModerators &&
            !isHost &&
            !isCurrentUser)
          _menuItem(
            value: 3,
            icon: Icons.shield_outlined,
            title: getLang(
              context: context,
              key: isModerator ? 'Remove_Admin' : 'Add_Admin',
            ),
          ),
        if (canModerateThisParticipant && canModerate)
          _menuItem(
            value: 4,
            icon: Icons.person_remove_outlined,
            title: getLang(context: context, key: 'Room_kick'),
          ),
      ],
      child: SizedBox(
        width: 76,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (isSpeaking)
                  AvatarGlow(
                    glowColor: Colors.tealAccent,
                    glowRadiusFactor: 1.2,
                    glowCount: 2,
                    duration: const Duration(milliseconds: 1000),
                    repeat: true,
                    animate: true,
                    child: const SizedBox(
                      width: 58,
                      height: 58,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isHost
                          ? Colors.amber
                          : isSpeaking
                              ? Colors.tealAccent
                              : const Color(0xFF394254),
                      width: isHost || isSpeaking ? 2 : 1,
                    ),
                  ),
                  child: ClipOval(
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: UserFrame(
                        image: isCurrentUser
                            ? login.userinfo?.image
                            : participant.image,
                        Frame: isCurrentUser
                            ? login.userinfo?.frameimage
                            : participant.frameimage,
                      ),
                    ),
                  ),
                ),
                if (isHost)
                  const Positioned(
                    top: -4,
                    right: -4,
                    child: Icon(
                      Icons.workspace_premium,
                      color: Colors.amber,
                      size: 17,
                    ),
                  ),
                if (isMuted)
                  Positioned(
                    bottom: -2,
                    right: -3,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A2E3A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic_off,
                        color: Colors.white70,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              (isCurrentUser
                      ? login.userinfo?.name
                      : participant.name)
                  ?.toString() ??
                  'Member',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Namestyle.copyWith(
                fontSize: 10,
                height: 1.1,
                color: Colors.white,
              ),
            ),
            if (isHost || isModerator)
              Text(
                isHost ? 'Host' : 'Moderator',
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<int> _menuItem({
    required int value,
    required IconData icon,
    required String title,
  }) {
    return PopupMenuItem<int>(
      value: value,
      height: 40,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}