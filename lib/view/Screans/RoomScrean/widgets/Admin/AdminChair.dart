
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Admin/AdminKarisma.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/RoomUserProfile.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminChair extends StatelessWidget {
  const AdminChair({super.key});

  @override
  Widget build(BuildContext context) {
    final room = Provider.of<RoomViewmodel>(context);
    final login = Provider.of<LoginViewmodel>(context);
    final agora = Provider.of<AgoraViewmodel>(context);

    final currentRoom = room.Currentroom;
    final host = currentRoom?.admin;

    if (currentRoom == null || host == null) {
      return const SizedBox.shrink();
    }

    final hostId = currentRoom.adminId?.toString() ?? '';
    final currentUserId = login.userinfo?.id?.toString() ?? '';
    final isCurrentUserHost =
        hostId.isNotEmpty && hostId == currentUserId;

    final isHostMuted = room.Mutedids.contains(hostId);
    final isHostSpeaking = int.tryParse(hostId) != null &&
        agora.isUserSpeaking(int.tryParse(hostId)!) &&
        !isHostMuted;

    return Center(
      child: SizedBox(
        width: 100,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (hostId.isEmpty) return;

            login.userinfoRoom(context: context, id: hostId);
            login.getuserroominfo(user: host);

            if (isCurrentUserHost) {
              GlopalbottomSheet(
                context: context,
                Screan: const MyProfileInRoom(),
              );
            } else {
              GlopalbottomSheet(
                context: context,
                Screan: const RoomUserProfile(),
              );
            }
          },
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isHostSpeaking)
                         AvatarGlow(
                          glowColor: Colors.tealAccent,
                          glowRadiusFactor: 1.2,
                          glowCount: 2,
                          duration: Duration(milliseconds: 1000),
                          repeat: true,
                          animate: true,
                          child: SizedBox(width: 76, height: 76),
                        ),
                      PhotoFrame(
                        image: isCurrentUserHost
                            ? login.userinfo?.image
                            : host.image,
                        Frame: isCurrentUserHost
                            ? login.userinfo?.frameimage
                            : host.frameimage,
                      ),
                      if (hostId.isNotEmpty &&
                          login.imoge.any(
                            (element) =>
                                element['uid'] ==
                                int.tryParse(hostId),
                          ))
                        Positioned(
                          bottom: 0,
                          child: SizedBox(
                            width: 58,
                            height: 58,
                            child: CachedNetworkImage(
                              imageUrl: login.imoge.firstWhere(
                                (element) =>
                                    element['uid'] ==
                                    int.tryParse(hostId),
                              )['imoge'],
                              errorWidget: (_, __, ___) =>
                                  const SizedBox.shrink(),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Helper().CutName(host.name ?? ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Namestyle.copyWith(
                      fontSize: 12,
                      height: 1.1,
                      color: whitecolor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const AdminKarisma(),
                ],
              ),
              if (hostId.isNotEmpty)
                Positioned(
                  bottom: 37,
                  left: 2,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.white54,
                    child: Icon(
                      isHostMuted ? Icons.mic_off_outlined : Icons.mic,
                      color: whitecolor,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
