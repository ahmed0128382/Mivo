import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/Screans/ChatScrean/chat_screan.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';

class MessageScrean extends StatefulWidget {
  final dynamic kind;

  const MessageScrean({
    Key? key,
    this.kind,
  }) : super(key: key);

  @override
  State<MessageScrean> createState() => _MessageScreanState();
}

class _MessageScreanState extends State<MessageScrean> {
  @override
  Widget build(BuildContext context) {
    final inboxRooms = Provider.of<InboxroomViewModel>(
      context,
      listen: true,
    );

    final user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    // Create a copy instead of sorting the original provider list.
    final List<InboxRoomModel> chats =
        List<InboxRoomModel>.from(inboxRooms.Inboxrooms);

    // Sort newest conversations first.
    chats.sort((a, b) {
      final aDate = a.updatedAt;
      final bDate = b.updatedAt;

      if (aDate == null && bDate == null) {
        return 0;
      }

      if (aDate == null) {
        return 1;
      }

      if (bDate == null) {
        return -1;
      }

      return bDate.compareTo(aDate);
    });

    return RefreshIndicator(
      onRefresh: () async {
        await inboxRooms.GetInboxroom(
          context: context,
        );
      },

      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),

        slivers: [
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),

          SliverToBoxAdapter(
            child: chats.isEmpty
                ? _buildEmptyState(context)
                : Column(
                    children: List.generate(
                      chats.length,
                      (index) {
                        final chat = chats[index];

                        return _buildChatItem(
                          context: context,
                          chat: chat,
                          inboxRooms: inboxRooms,
                          user: user,
                        );
                      },
                    ),
                  ),
          ),

          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem({
    required BuildContext context,
    required InboxRoomModel chat,
    required InboxroomViewModel inboxRooms,
    required LoginViewmodel user,
  }) {
    final bool isSender = user.checkuserkind(
      context: context,
      id: chat.user?.id,
    );

    final String imageUrl = isSender
        ? chat.sender?.image ?? ''
        : chat.user?.image ?? '';

    final String displayName = isSender
        ? Helper().utf8convert(
            chat.sender?.name ?? '',
          )
        : Helper().utf8convert(
            chat.user?.name ?? '',
          );

    final String lastMessage = _getLastMessage(
      context: context,
      chat: chat,
    );

    return InkWell(
      onLongPress: () {
        _showConversationActions(
          context: context,
          chat: chat,
          inboxRooms: inboxRooms,
        );
      },
      onTap: () {
        _openChat(
          context: context,
          chat: chat,
          inboxRooms: inboxRooms,
          user: user,
        );
      },
      child: Container(
        width: SizeConfig.screenWidth,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Row(
            children: [
              _buildAvatar(
                imageUrl: imageUrl,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            displayName,
                            style: Namestyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          Helper().getTimeago(
                            time: chat.updatedAt,
                          ),
                          style: style6.copyWith(
                            fontSize: 10,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (chat.numberUnread != 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ).copyWith(
                              top: 10,
                            ),
                            child: badges.Badge(
                              badgeStyle: badges.BadgeStyle(
                                badgeColor: MainColor,
                              ),
                              child: const Icon(
                                Icons.notifications_active_outlined,
                                size: 19,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar({
    required String imageUrl,
  }) {
    if (imageUrl.isEmpty) {
      return const CircleAvatar(
        radius: 30,
        backgroundColor: Colors.black12,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 30,
        ),
      );
    }

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.transparent,
      backgroundImage: CachedNetworkImageProvider(
        imageUrl,
      ),
    );
  }

  String _getLastMessage({
    required BuildContext context,
    required InboxRoomModel chat,
  }) {
    final messages = chat.message;

    if (messages == null || messages.isEmpty) {
      return '';
    }

    final last = messages.last;

    if (last.status == 1) {
      return getLang(
        context: context,
        key: "IMage",
      );
    }

    if (last.status == 2) {
      return 'Gift🎁';
    }

    return last.message ?? '';
  }

  void _openChat({
    required BuildContext context,
    required InboxRoomModel chat,
    required InboxroomViewModel inboxRooms,
    required LoginViewmodel user,
  }) {
    // Mark the inbox room as read.
    inboxRooms.ReadInboxRoom(
      id: chat.id,
      context: context,
    );

    // Clear the message input.
    inboxRooms.textEditingController.clear();

    // Clear local unread state.
    chat.numberUnread = 0;

    // Update global message/unread state.
    user.RemoveMessage();

    // Open the chat.
    navigateTo(
      context: context,
      screen: ChatScreen(
        inboxContent: chat,
      ),
    );
  }

  void _showConversationActions({
    required BuildContext context,
    required InboxRoomModel chat,
    required InboxroomViewModel inboxRooms,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'World Team',
                style: style2.copyWith(
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 10),

              InkWell(
                onTap: () {
                  Navigator.pop(dialogContext);

                  inboxRooms.DeleteInboxroom(
                    context: context,
                    inboxid: chat.id,
                  );
                },
                child: Text(
                  getLang(
                    context: context,
                    key: "Delete_Conv",
                  ),
                  style: style5.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              InkWell(
                onTap: () {
                  Navigator.pop(dialogContext);

                  inboxRooms.DeleteAndBlockUserInboxroom(
                    context: context,
                    inboxid: chat.id,
                  );
                },
                child: Text(
                  getLang(
                    context: context,
                    key: "Block_User",
                  ),
                  style: style5.copyWith(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 60,
        ),
        child: Center(
          child: Text(
            getLang(
              context: context,
              key: "No_Messages",
            ),
            textAlign: TextAlign.center,
            style: style6.copyWith(
              fontSize: 14,
              color: Colors.black45,
            ),
          ),
        ),
      ),
    );
  }
}