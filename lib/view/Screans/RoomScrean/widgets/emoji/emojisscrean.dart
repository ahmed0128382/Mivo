import 'package:ahlachat/util/SizeConfig.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';

class EmojiTabBar extends StatelessWidget {
  const EmojiTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context);

    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: false);

    final categories = user.emojisCategory;

    // Avoid DefaultTabController(length: 0).
    if (categories.isEmpty) {
      return Container(
        height: SizeConfig.screenHeight! / 2.7,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
        ),
        child: const Center(
          child: Text(
            'No emojis available',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    return Container(
      height: SizeConfig.screenHeight! / 2.7,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      child: DefaultTabController(
        length: categories.length,
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Category names are text, not image URLs.
            TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              automaticIndicatorColorAdjustment: true,
              tabs: categories.map((category) {
                final String categoryName =
                    category.name?.trim() ?? '';

                return Tab(
                  text: categoryName.isNotEmpty
                      ? categoryName
                      : 'Emojis',
                );
              }).toList(),
            ),

            Expanded(
              child: TabBarView(
                children: categories.map((category) {
                  final categoryEmojis = category.emoji ?? [];

                  if (categoryEmojis.isEmpty) {
                    return const Center(
                      child: Text(
                        'No emojis in this category',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      itemCount: categoryEmojis.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        final emoji = categoryEmojis[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            final String? emojiPath =
                                emoji.emojiSvga;

                            if (emojiPath == null ||
                                emojiPath.trim().isEmpty) {
                              debugPrint(
                                'EMOJI TAP ERROR: '
                                'missing SVGA/GIF path; '
                                'id=${emoji.id}, '
                                'name=${emoji.emojiName}',
                              );
                              return;
                            }

                            debugPrint(
                              'EMOJI SELECTED: '
                              'id=${emoji.id}, '
                              'name=${emoji.emojiName}, '
                              'path=$emojiPath',
                            );

                            Navigator.pop(context);

                            room.SentEmoji(
                              context: context,
                              emoji: emojiPath,
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: emoji.image ?? '',
                                  height: 50,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                      child: SizedBox(
                                        height: 18,
                                        width: 18,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget:
                                      (context, url, error) {
                                    debugPrint(
                                      'EMOJI IMAGE ERROR: '
                                      'url=$url, error=$error',
                                    );

                                    return const SizedBox(
                                      height: 50,
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.white54,
                                        size: 28,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  emoji.emojiName ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: style4.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
