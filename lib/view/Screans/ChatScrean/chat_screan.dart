import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/view/Screans/ChatScrean/Widgets/PickeChatImage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/MessageModel.dart';
import '../../../util/Dialogs.dart';
import '../../../util/Localization.dart';
import '../../../util/helperclass.dart';
import '../../../util/styles.dart';
import '../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import '../../widgets/CustomizeAppBar.dart';
import '../../widgets/ImageView.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  InboxRoomModel? inboxContent;
  int? states;

  ChatScreen({
    super.key,
    this.inboxContent,
    this.states,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Color _attachmentBlue = Color(0xFF64B5F6);
  static const Color _sendBlue = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    final InboxroomViewModel inboxrooms =
        Provider.of<InboxroomViewModel>(context, listen: true);

    if (widget.states == 0) {
      widget.inboxContent = user.ChatRoom;
    }

    final messages =
        widget.inboxContent?.message?.reversed.toList() ?? <Message>[];

    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom > 0;

    return WillPopScope(
      onWillPop: () async {
        inboxrooms.ExistChatRoom();
        return true;
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: const Color(0xFFf6f7f9),
          resizeToAvoidBottomInset: true,
          appBar: CustomizeChatAppbar(
            InBoxid: widget.inboxContent?.id,
            tittle: user.checkuserkind(
              context: context,
              id: widget.inboxContent?.user?.id,
            )
                ? widget.inboxContent?.sender?.name ?? ''
                : widget.inboxContent?.user?.name ?? '',
            image: user.checkuserkind(
              context: context,
              id: widget.inboxContent?.user?.id,
            )
                ? widget.inboxContent?.sender?.image ?? ''
                : widget.inboxContent?.user?.image ?? '',
            userchat: user.checkuserkind(
              context: context,
              id: widget.inboxContent?.user?.id,
            )
                ? widget.inboxContent?.sender
                : widget.inboxContent?.user,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Chat messages
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final Message message = messages[index];

                      final bool isCurrentUser = user.checkuserkind(
                        context: context,
                        id: message.senderId,
                      );

                      final String messageText = message.message ?? '';

                      final String otherUserImage = user.checkuserkind(
                        context: context,
                        id: widget.inboxContent?.user?.id,
                      )
                          ? widget.inboxContent?.sender?.image ?? ''
                          : widget.inboxContent?.user?.image ?? '';

                      // Received message
                      if (!isCurrentUser) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: otherUserImage.isNotEmpty
                                        ? CachedNetworkImageProvider(
                                            otherUserImage,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 5),
                                  _buildMessageContent(
                                    context: context,
                                    message: message,
                                    messageText: messageText,
                                  ),
                                ],
                              ),
                              Text(
                                Helper().getTimeago(
                                  time: message.createdAt,
                                ),
                                style: style5.copyWith(
                                  fontSize: 10,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Sent message
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _buildMessageContent(
                                  context: context,
                                  message: message,
                                  messageText: messageText,
                                ),
                                const SizedBox(width: 6),
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      (user.userinfo?.image ?? '').isNotEmpty
                                          ? CachedNetworkImageProvider(
                                              user.userinfo!.image!,
                                            )
                                          : null,
                                ),
                              ],
                            ),
                            Text(
                              Helper().getTimeago(
                                time: message.createdAt,
                              ),
                              style: style5.copyWith(
                                fontSize: 10,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom message composer
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: isKeyboardVisible ? 8 : 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: whitecolor4,
                        width: 0.5,
                      ),
                    ),
                    color: whitecolor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(width: 10),

                      // Message input
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: secondcolor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: TextField(
                              controller: inboxrooms.textEditingController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 4,
                              textInputAction: TextInputAction.newline,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration.collapsed(
                                hintText: getLang(
                                  context: context,
                                  key: 'Say',
                                ),
                                hintStyle: const TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Attachment menu: images and files
                      IconButton(
                        tooltip: 'Attach image or file',
                        icon: const Icon(
                          Icons.attach_file_rounded,
                          color: _attachmentBlue,
                          size: 27,
                        ),
                        onPressed: _showAttachmentMenu,
                      ),

                      // Send button
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          bottom: 2,
                        ),
                        child: Material(
                          color: _sendBlue,
                          shape: const CircleBorder(),
                          child: IconButton(
                            tooltip: 'Send message',
                            icon: const Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            onPressed: () {
                              final String text = inboxrooms
                                  .textEditingController.text
                                  .trim();

                              if (text.isEmpty) {
                                return;
                              }

                              if (!user.checkuserkind(
                                context: context,
                                id: widget.inboxContent?.sender?.id,
                              )) {
                                inboxrooms.SendMessage(
                                  userinfo: widget.inboxContent?.sender,
                                  context: context,
                                  id: widget.inboxContent?.id,
                                  message: text,
                                );
                              } else {
                                inboxrooms.SendMessage(
                                  userinfo: widget.inboxContent?.user,
                                  context: context,
                                  id: widget.inboxContent?.id,
                                  message: text,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Added bottom padding below the input bar
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Show attachment options
  Future<void> _showAttachmentMenu() async {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: false);

    final InboxroomViewModel inboxrooms =
        Provider.of<InboxroomViewModel>(context, listen: false);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Images option
                _buildAttachmentOption(
                  icon: Icons.photo_rounded,
                  label: 'Images',
                  color: const Color(0xFF2196F3),
                  backgroundColor: const Color(0xFFE3F2FD),
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    final value = await inboxrooms.getChatRoomImage();

                    if (!mounted || !context.mounted) {
                      return;
                    }

                    if (value == true) {
                      await showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        barrierColor: Colors.transparent,
                        backgroundColor: Colors.white54,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        builder: (context) {
                          return PickedImageChat(
                            id: widget.inboxContent?.id,
                            userinfo: !user.checkuserkind(
                              context: context,
                              id: widget.inboxContent?.sender?.id,
                            )
                                ? widget.inboxContent?.sender
                                : widget.inboxContent?.user,
                          );
                        },
                      );
                    }
                  },
                ),

                // Files option
                _buildAttachmentOption(
                  icon: Icons.insert_drive_file_rounded,
                  label: 'Files',
                  color: const Color(0xFF2196F3),
                  backgroundColor: const Color(0xFFE3F2FD),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'File attachments are not connected yet.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 29,
              backgroundColor: backgroundColor,
              child: Icon(
                icon,
                color: color,
                size: 29,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent({
    required BuildContext context,
    required Message message,
    required String messageText,
  }) {
    if (message.status == 0) {
      return InkWell(
        onLongPress: () {
          Clipboard.setData(
            ClipboardData(text: messageText),
          );

          Dialogs().showtoast(
            getLang(
              context: context,
              key: 'Copied',
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 10,
            maxWidth: 200,
          ),
          decoration: BoxDecoration(
            color: MainColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5).copyWith(
              right: 19,
              left: 10,
            ),
            child: Text(
              messageText,
              maxLines: null,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      );
    }

    final String imageUrl = AppConstants.Image_URL + messageText;

    if (message.status == 1) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageView(url: imageUrl),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(imageUrl),
              fit: BoxFit.cover,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }

    // Gift message
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageView(url: imageUrl),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(imageUrl),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            getLang(
              context: context,
              key: 'Send_Gifts',
            ),
            style: TextStyle(
              color: MainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}