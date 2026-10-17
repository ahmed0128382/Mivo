import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/global_lucky_banner.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/room_background.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/room_lucky_combo_timer.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/room_sidebar_actions.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/room_win_combo_overlay.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

import 'package:ahlachat/view/Screans/EnterRoomanimateWidget/EnterRoomanimateWidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GlopalGoft/GlopalGift.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GuessWidgets/GessRoomWidget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWidge/ChatReversedList.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWidge/chat_widgets.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/EntryShow/EntryShow.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/GiftShow/GiftShow.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/SentGift/SentGift.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ChatWedget.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Headwidget.dart';

class RoomScrean extends StatefulWidget {
  const RoomScrean({super.key});

  @override
  State<RoomScrean> createState() => _RoomScreanState();
}

class _RoomScreanState extends State<RoomScrean>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AgoraViewmodel? _observedAgora;
  bool _handlingAgoraFailure = false;

  @override
  void initState() {
    super.initState();
    thiss = this;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final agora = Provider.of<AgoraViewmodel>(
      context,
      listen: false,
    );

    if (!identical(_observedAgora, agora)) {
      _observedAgora?.removeListener(_onAgoraStateChanged);
      _observedAgora = agora;
      _observedAgora!.addListener(_onAgoraStateChanged);
    }

    // Handle an error that happened before this screen finished mounting.
    _onAgoraStateChanged();
  }

  /// If Agora fails while the room screen is open, dismiss the join spinner.
  ///
  /// The chat composer is independent of Agora audio and must remain open
  /// when an Agora connection error occurs.
  void _onAgoraStateChanged() {
    if (!mounted || _handlingAgoraFailure) return;

    final agora = _observedAgora;
    if (agora == null || agora.connectionError == null) return;

    _handlingAgoraFailure = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _handlingAgoraFailure = false;
        return;
      }

      try {
        final room = Provider.of<RoomViewmodel>(
          context,
          listen: false,
        );

        // Only dismiss the Agora/join spinner.
        // Do not call hideSpinner7(): it controls the chat composer.
        room.hideSpinner3();

        debugPrint(
          '[ROOM][LOADING] Cleared the join spinner after Agora error: '
          '${agora.connectionError}',
        );
      } catch (error, stackTrace) {
        debugPrint('[ROOM][LOADING] Cleanup failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      } finally {
        _handlingAgoraFailure = false;
      }
    });
  }

  @override
  void dispose() {
    _observedAgora?.removeListener(_onAgoraStateChanged);
    _observedAgora = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);

    final RoomPlayViewModel roomPlay =
        Provider.of<RoomPlayViewModel>(context, listen: true);

    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        if (room.showloading7) {
          room.hideSpinner7();
        } else if (room.showloading5) {
          room.changeloading5();
        } else if (room.showloading39) {
          room.hideloading39();
        } else if (room.showloading40) {
          room.hideloading40();
        } else if (room.showloading38) {
          room.hideSpinner38();
        } else if (room.showloading33) {
          room.hideSpinner33();
        } else if (room.showloading36) {
          room.hideSpinner36();
        } else if (room.showloading29) {
          room.hideSpinner29();
        } else if (room.showloading28) {
          room.hideSpinner28();
        } else {
          roomPlay.changeIsRoomstate(false);
          return true;
        }

        room.hideSpinner7();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            RoomBackground(room: room),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 35),
                  const Headwidget(),
                  const RoomParticipantsPanel(),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        chatRoom(),
                        if (room.checkadmin(context: context) ||
                            (room.Currentroom?.supervisorsId?.contains(
                                  user.userinfo?.id.toString(),
                                ) ??
                                false))
                          const RoomSidebarActions(),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
                  const ChatWidgets(),
                ],
              ),
            ),
            const EntryShow(),
            const GiftShow(),
            if (room.selected)
              const Positioned(
                top: 100,
                child: EnterAnimateWidget(),
              ),
            GlopalGiftWidget(),
            const GlobalLuckyBanner(),
            if (room.guesses.isNotEmpty) GeussRoomWidget(),
            const SendGift(),
            if (room.showloading7) const ChatReversedList(),
            RoomWinComboOverlay(room: room),
            RoomLuckyComboTimer(
              room: room,
              onStateChanged: () => setState(() {}),
            ),
            if (user.Luckypackages.isNotEmpty)
              InkWell(
                onTap: () {
                  user.AcceptLuckyPackage(
                    Roomid: room.Currentroom?.id,
                    context: context,
                    Luckyid: user.Luckypackages.first['id'],
                  );
                },
                child: SVGASimpleImage(
                  assetsName: 'assets/image/1665252390.svga',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Participants are rendered only from confirmed room memberships.
/// An administrator who is not a member is not displayed as present.
class RoomParticipantsPanel extends StatelessWidget {
  const RoomParticipantsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final room = Provider.of<RoomViewmodel>(context);
    final login = Provider.of<LoginViewmodel>(context, listen: false);
    final currentRoom = room.Currentroom;

    if (currentRoom == null) {
      return const SizedBox.shrink();
    }

    final String currentUserId =
        (login.userinfo?.id ?? '').toString().trim();

    final String hostId =
        (currentRoom.adminId ?? currentRoom.admin?.id ?? '')
            .toString()
            .trim();

    final List<Map<String, dynamic>> participants = [];
    final Set<String> seenIds = <String>{};

    for (final membership in room.joinuserRooms) {
      final dynamic memberUser = membership.user;

      final String memberId =
          (memberUser?.id ?? membership.userId ?? '')
              .toString()
              .trim();

      if (memberId.isEmpty || !seenIds.add(memberId)) {
        continue;
      }

      // The current user can use their own profile as a fallback if the
      // membership response contains their userId but omits the user object.
      final dynamic resolvedUser =
          memberUser ??
          (memberId == currentUserId ? login.userinfo : null);

      // Do not render a ghost member without a usable user profile.
      if (resolvedUser == null) {
        continue;
      }

      participants.add({
        'id': memberId,
        'user': resolvedUser,
        'isHost': hostId.isNotEmpty && memberId == hostId,
      });
    }

    // Sort actual members so the administrator appears first only when
    // they are present in the membership response.
    participants.sort((a, b) {
      final bool aIsHost = a['isHost'] as bool;
      final bool bIsHost = b['isHost'] as bool;

      if (aIsHost == bIsHost) return 0;
      return aIsHost ? -1 : 1;
    });

    if (participants.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF45D6C5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'In this room',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(width: 7),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${participants.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 166),
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 15,
                  runSpacing: 16,
                  children: participants.map<Widget>((participant) {
                    final dynamic memberUser = participant['user'];
                    final String memberId = participant['id'] as String;
                    final bool isHost = participant['isHost'] as bool;
                    final bool isMe = memberId == currentUserId;

                    return _RoomMemberTile(
                      key: ValueKey('member-$memberId'),
                      userId: memberId,
                      name: isMe
                          ? 'You'
                          : (memberUser.name ?? 'Member').toString(),
                      image: (memberUser.image ?? '').toString(),
                      isHost: isHost,
                      onTap: isMe
                          ? null
                          : () => _openProfile(
                                context,
                                memberUser,
                                memberId,
                              ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openProfile(
    BuildContext context,
    dynamic memberUser,
    String memberId,
  ) {
    final login = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    if (login.userinfo?.id.toString() == memberId) {
      return;
    }

    login.GetShoweduserProfile(memberUser);
    CheckBlocked = false;

    Navigator.pushNamed(
      context,
      AppConstants.ShowUser_Profile,
    );
  }
}

class _RoomMemberTile extends StatelessWidget {
  const _RoomMemberTile({
    super.key,
    required this.userId,
    required this.name,
    required this.image,
    required this.isHost,
    required this.onTap,
  });

  final String userId;
  final String name;
  final String image;
  final bool isHost;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final agora = Provider.of<AgoraViewmodel>(context);

    // Never show a speaking animation from stale state after an Agora
    // connection failure or after leaving the audio channel.
    final int? agoraUid = int.tryParse(userId);
    final bool isSpeaking = agora.isJoined &&
        agora.connectionError == null &&
        agoraUid != null &&
        agora.isUserSpeaking(agoraUid);

    const Color speakingColor = Color(0xFF45D6C5);

    return SizedBox(
      width: 66,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 58,
              height: 58,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    width: isSpeaking ? 56 : 50,
                    height: isSpeaking ? 56 : 50,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSpeaking
                            ? speakingColor
                            : Colors.white.withOpacity(0.14),
                        width: isSpeaking ? 2.5 : 1,
                      ),
                      boxShadow: isSpeaking
                          ? [
                              BoxShadow(
                                color: speakingColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ]
                          : const [],
                    ),
                    child: ClipOval(
                      child: image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: image,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => _avatarFallback(),
                              errorWidget: (_, __, ___) =>
                                  _avatarFallback(),
                            )
                          : _avatarFallback(),
                    ),
                  ),
                  if (isHost)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22242B),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF090B10),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFD479),
                          size: 13,
                        ),
                      ),
                    ),
                  if (isSpeaking)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 19,
                        height: 19,
                        decoration: BoxDecoration(
                          color: speakingColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF090B10),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.graphic_eq_rounded,
                          color: Color(0xFF102321),
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSpeaking
                    ? speakingColor
                    : Colors.white.withOpacity(0.94),
                fontSize: 11,
                fontWeight:
                    isSpeaking ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (isHost) ...[
              const SizedBox(height: 2),
              const Text(
                'Host',
                style: TextStyle(
                  color: Color(0xFFFFD479),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      color: const Color(0xFF202630),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_rounded,
        color: Colors.white60,
        size: 25,
      ),
    );
  }
}
