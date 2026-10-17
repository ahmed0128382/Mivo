
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Clubhouse-style room participants.
///
/// Participants are obtained from room membership, not chair assignments.
/// The room administrator is identified by adminId.
class RoomParticipants extends StatelessWidget {
  const RoomParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    final room = context.watch<RoomViewmodel>();
    final login = context.watch<LoginViewmodel>();
    final agora = context.watch<AgoraViewmodel>();

    final participants = room.joinuserRooms
        .where((membership) => membership.user != null)
        .toList();

    final adminId = room.Currentroom?.adminId?.toString();

    // Put the host first when the host is in the membership list.
    participants.sort((a, b) {
      final aIsAdmin = a.user?.id.toString() == adminId;
      final bIsAdmin = b.user?.id.toString() == adminId;

      if (aIsAdmin == bIsAdmin) return 0;
      return aIsAdmin ? -1 : 1;
    });

    final currentUserId = login.userinfo?.id?.toString();

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 220),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: participants.isEmpty
          ? const Center(
              child: Text(
                'No participants yet',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people_alt_outlined,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'People in the room',
                        style: style1.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${participants.length}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: participants.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 4,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final member = participants[index].user!;
                      final memberId = member.id?.toString();
                      final isHost = memberId == adminId;
                      final isMe = memberId == currentUserId;

                      // The membership's app user ID must match the Agora UID.
                      final int? agoraUid = int.tryParse(memberId ?? '');
                      final bool isSpeaking = agoraUid != null &&
                          agora.isUserSpeaking(agoraUid);

                      final image = member.image;
                      final name = member.name ?? 'User';

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 62,
                            height: 62,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                // Animated speaking ring.
                                AnimatedContainer(
                                  duration: const Duration(
                                    milliseconds: 220,
                                  ),
                                  curve: Curves.easeOut,
                                  width: isSpeaking ? 60 : 54,
                                  height: isSpeaking ? 60 : 54,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSpeaking
                                          ? const Color(0xFF00F2FE)
                                          : Colors.transparent,
                                      width: isSpeaking ? 3 : 1,
                                    ),
                                    boxShadow: isSpeaking
                                        ? [
                                            BoxShadow(
                                              color: const Color(0xFF00F2FE)
                                                  .withValues(alpha: 0.65),
                                              blurRadius: 13,
                                              spreadRadius: 2,
                                            ),
                                            BoxShadow(
                                              color: const Color(0xFF0072FF)
                                                  .withValues(alpha: 0.35),
                                              blurRadius: 20,
                                              spreadRadius: 3,
                                            ),
                                          ]
                                        : const [],
                                  ),
                                ),

                                // Existing avatar and host border.
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isHost
                                          ? Colors.amber
                                          : Colors.white24,
                                      width: isHost ? 2 : 1,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: image != null && image.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: image,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) =>
                                                _fallbackAvatar(),
                                          )
                                        : _fallbackAvatar(),
                                  ),
                                ),

                                if (isHost)
                                  const Positioned(
                                    right: -1,
                                    bottom: 1,
                                    child: Icon(
                                      Icons.stars_rounded,
                                      color: Colors.amber,
                                      size: 18,
                                    ),
                                  ),

                                if (isMe)
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.teal,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isSpeaking
                                            ? Icons.graphic_eq
                                            : Icons.mic,
                                        size: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            isMe ? 'You' : name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                          if (isHost)
                            const Text(
                              'Host',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 9,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _fallbackAvatar() {
    return Container(
      color: const Color(0xFF252936),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person,
        color: Colors.white70,
        size: 26,
      ),
    );
  }
}
