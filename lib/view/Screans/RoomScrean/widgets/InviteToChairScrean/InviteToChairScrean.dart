import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Legacy filename retained so old imports continue to resolve.
///
/// Chair invitations have been removed. Use the existing room invitation
/// flow to invite people to a room, not to a seat.
class InviteToChair extends StatelessWidget {
  const InviteToChair({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);
    final LoginViewmodel login =
        Provider.of<LoginViewmodel>(context, listen: true);

    final String currentUserId =
        (login.userinfo?.id ?? '').toString();

    final members = room.joinuserRooms.where((membership) {
      final String id =
          (membership.user?.id ?? '').toString();
      return id.isNotEmpty && id != currentUserId;
    }).toList();

    return Container(
      height: SizeConfig.screenHeight! * 0.65,
      width: SizeConfig.screenWidth!,
      decoration: const BoxDecoration(
        color: Color(0xFF11141D),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 12, 14),
            child: Row(
              children: [
                const Icon(
                  Icons.group_add_outlined,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    getLang(context: context, key: 'Tag_Member'),
                    style: style4.copyWith(color: Colors.white),
                  ),
                ),
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
          const Divider(height: 1, color: Colors.white12),
          Expanded(
            child: members.isEmpty
                ? const Center(
                    child: Text(
                      'No other members are available.',
                      style: TextStyle(color: Colors.white60),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    itemCount: members.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white10),
                    itemBuilder: (context, index) {
                      final dynamic member = members[index].user;

                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.white10,
                            backgroundImage:
                                (member?.image != null &&
                                        member.image.toString().isNotEmpty)
                                    ? CachedNetworkImageProvider(
                                        member.image.toString(),
                                      )
                                    : null,
                            child: (member?.image == null ||
                                    member.image.toString().isEmpty)
                                ? const Icon(
                                    Icons.person_outline,
                                    color: Colors.white70,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: UserSideInfoWidgets(
                              UserDate: member,
                              TextColor: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.group_outlined,
                            color: Colors.white38,
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check, color: Colors.white70),
                label: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}