import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Mutemic extends StatelessWidget {
  const Mutemic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AgoraViewmodel agora =
        Provider.of<AgoraViewmodel>(context, listen: true);

    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);

    final LoginViewmodel login =
        Provider.of<LoginViewmodel>(context, listen: true);

    final String currentUserId =
        (login.userinfo?.id ?? '').toString();

    final String hostId =
        (room.Currentroom?.adminId ?? '').toString();

    final bool isHost = room.checkadmin(context: context);

    final bool isModerator = room.Currentroom?.supervisorsId
            ?.contains(currentUserId) ??
        false;

    final bool canModerate = isHost || isModerator;

    final members = room.joinuserRooms.where((membership) {
      final member = membership.user;

      if (member == null) return false;

      final String memberId = (member.id ?? '').toString();

      // Do not list the current user in the moderation targets.
      if (memberId.isEmpty || memberId == currentUserId) {
        return false;
      }

      return true;
    }).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF10131B),
        image: (room.Currentroom?.animateimage ?? '').isNotEmpty
            ? DecorationImage(
                image: CachedNetworkImageProvider(
                  room.Currentroom!.animateimage!,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.65),
                  BlendMode.darken,
                ),
              )
            : null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Panel header.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Expanded(
                    child: Text(
                      'Room moderation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${members.length} members',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              color: Colors.white12,
              height: 18,
            ),

            if (!canModerate)
              const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Only the host and moderators can manage members.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),

            Expanded(
              child: members.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            color: Colors.white38,
                            size: 44,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            getLang(
                              context: context,
                              key: 'User_Join',
                            ),
                            style: style1.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'No other members to manage',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        14,
                        8,
                        14,
                        24,
                      ),
                      itemCount: members.length,
                      separatorBuilder: (_, __) =>
                          const Divider(
                            color: Colors.white10,
                            height: 18,
                          ),
                      itemBuilder: (context, index) {
                        final member = members[index].user!;

                        final String memberId =
                            (member.id ?? '').toString();

                        final bool memberIsHost =
                            memberId == hostId;

                        final bool memberIsModerator = room
                                .Currentroom
                                ?.supervisorsId
                                ?.contains(memberId) ??
                            false;

                        // Do not let moderators target the host or
                        // other moderators through this panel.
                        final bool canManageMember = canModerate &&
                            !memberIsHost &&
                            !memberIsModerator;

                        final bool isMuted =
                            room.Mutedids.contains(member.id);

                        final String image =
                            (member.image ?? '').toString();

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor:
                                    const Color(0xFF252B39),
                                backgroundImage: image.isNotEmpty
                                    ? CachedNetworkImageProvider(image)
                                    : null,
                                child: image.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.white70,
                                      )
                                    : null,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (member.name ?? 'Member').toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (memberIsHost)
                                      const Text(
                                        'Host',
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 11,
                                        ),
                                      )
                                    else if (memberIsModerator)
                                      const Text(
                                        'Moderator',
                                        style: TextStyle(
                                          color: Colors.cyanAccent,
                                          fontSize: 11,
                                        ),
                                      )
                                    else
                                      Text(
                                        isMuted
                                            ? 'Microphone muted'
                                            : 'Room member',
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 11,
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              if (canManageMember) ...[
                                IconButton(
                                  tooltip: isMuted
                                      ? 'Unmute member'
                                      : 'Mute member',
                                  onPressed: () {
                                    room.updatemute(
                                      context: context,
                                      state: isMuted ? 0 : 1,
                                      user_id: member.id,
                                    );

                                    agora.mutebyuid(
                                      uid: member.id,
                                      context: context,
                                    );
                                  },
                                  icon: Icon(
                                    isMuted
                                        ? Icons.mic_off_outlined
                                        : Icons.mic_none_outlined,
                                    color: isMuted
                                        ? Colors.redAccent
                                        : Colors.white,
                                    size: 22,
                                  ),
                                ),

                                IconButton(
                                  tooltip: 'Remove member',
                                  onPressed: () {
                                    Dialogs().showdialog(
                                      context: context,
                                      tittle: '',
                                      content: getLang(
                                        context: context,
                                        key: 'Sure_Ban',
                                      ),
                                      buttontext: getLang(
                                        context: context,
                                        key: 'Yes',
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        room.Evictionuser(
                                          Userid: member.id,
                                          context: context,
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.person_remove_alt_1_outlined,
                                    color: Colors.redAccent,
                                    size: 22,
                                  ),
                                ),
                              ] else
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Icon(
                                    Icons.shield_outlined,
                                    color: Colors.white30,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
