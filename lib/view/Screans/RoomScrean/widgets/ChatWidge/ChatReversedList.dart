import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:provider/provider.dart';

import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class ChatReversedList extends StatelessWidget {
  const ChatReversedList({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);

    return Portal(
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  room.cleanMessage();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: 100,
              color: Colors.transparent,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                reverse: true,
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FlutterMentions(
                          key: const ValueKey('room-chat-mentions'),
                          defaultText: room.Message.text,
                          onMentionAdd: (mention) {
                            room.GetMentionid(
                              id: mention['id'],
                              name: mention['display'],
                            );
                          },
                          decoration: InputDecoration(
                            suffixIconColor: Colors.black,
                            border: InputBorder.none,
                            hintText: getLang(
                              context: context,
                              key: 'Send_Message',
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length < 2) {
                              room.ClearMentionid();
                            }

                            room.Message.text = value;
                          },
                          autofocus: true,
                          appendSpaceOnAdd: true,
                          suggestionPosition: SuggestionPosition.Top,
                          maxLines: 5,
                          minLines: 1,
                          trailing: [
                            InkWell(
                              onTap: () {
                                final String message = room.Message.text;

                                if (message.isEmpty) {
                                  return;
                                }

                                // Preserve the existing mention/message API
                                // calls. Do not close the composer here until
                                // the send action has been handled.
                                if (room.Mentionid != null &&
                                    (room.MentionName?.length ?? 0) + 1 <
                                        message.length) {
                                  room.sendMentionChat(
                                    content: message.replaceFirst('@', ''),
                                  );
                                } else {
                                  room.sendMessageChat(
                                    content: message,
                                  );
                                }

                                room.Message.clear();
                                room.ClearMentionid();

                                FocusScope.of(context).unfocus();
                                room.hideSpinner7();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.send_outlined,
                                  color: MainColor,
                                ),
                              ),
                            ),
                          ],
                          mentions: [
                            Mention(
                              trigger: '@',
                              style: const TextStyle(
                                color: Colors.amber,
                              ),
                              data: room.ChairMaps,
                              matchAll: false,
                              markupBuilder: (
                                String trigger,
                                String mention,
                                String value,
                              ) {
                                return value;
                              },
                              suggestionBuilder: (data) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 13,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                          data['full_name'],
                                        ),
                                      ),
                                      Text(
                                        data['display'],
                                        style: style2.copyWith(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ].reversed.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
