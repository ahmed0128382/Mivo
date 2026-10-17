
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlluserInRoom extends StatelessWidget {
  const AlluserInRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);

    final LoginViewmodel login =
        Provider.of<LoginViewmodel>(context, listen: true);

    final String currentUserId =
        (login.userinfo?.id ?? '').toString();

    final String hostId =
        (room.Currentroom?.adminId ?? '').toString();

    final bool canModerate = room.checkadmin(context: context) ||
        (room.Currentroom?.supervisorsId
                ?.contains(currentUserId) ??
            false);

    final members = room.joinuserRooms.where((membership) {
      final member = membership.user;

      if (member == null) return false;

      final String memberId = (member.id ?? '').toString();

      // Hide the current user from this management list.
      if (memberId.isEmpty || memberId == currentUserId) {
        return false;
      }

      // Preserve the existing hidden-user behavior.
      if (member.Hidden != 0) return false;

      return true;
    }).toList();

    return Container(
      width: SizeConfig.screenWidth ?? double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF10131B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  const Icon(
                    Icons.people_alt_outlined,
                    color: Colors.white70,
                    size: 21,
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      getLang(context: context, key: 'User_Join'),
                      style: style4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${members.length}',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 18),
            Flexible(
              child: members.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 36,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: Colors.white38,
                            size: 42,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'No other members in the room yet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
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

                        final bool isHost =
                            memberId == hostId;

                        final bool isSupervisor = room
                                .Currentroom
                                ?.supervisorsId
                                ?.contains(memberId) ??
                            false;

                        // Moderators cannot remove the host or another
                        // supervisor. The host retains room moderation.
                        final bool canKick = canModerate &&
                            !isHost &&
                            !isSupervisor;

                        return Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor:
                                  const Color(0xFF252B39),
                              backgroundImage:
                                  (member.image ?? '').isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          member.image!,
                                        )
                                      : null,
                              child: (member.image ?? '').isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white70,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  UserSideInfoWidgets(
                                    UserDate: member,
                                    TextColor: Colors.white,
                                  ),
                                  if (isHost)
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 3),
                                      child: Text(
                                        'Host',
                                        style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 11,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  else if (isSupervisor)
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(top: 3),
                                      child: Text(
                                        'Moderator',
                                        style: TextStyle(
                                          color: Colors.cyanAccent,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'View profile',
                              onPressed: () {
                                Navigator.pop(context);
                                login.GetShoweduserProfile(member);
                                CheckBlocked = false;
                                Navigator.pushNamed(
                                  context,
                                  AppConstants.ShowUser_Profile,
                                );
                              },
                              icon: const Icon(
                                Icons.person_outline,
                                color: Colors.white70,
                              ),
                            ),
                            if (canKick)
                              IconButton(
                                tooltip: 'Remove from room',
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

                                      // Use the existing membership-based
                                      // removal method, not the old
                                      // chair/admin-seat API.
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
                                ),
                              ),
                          ],
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
