
import 'package:ahlachat/models/PostsModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/MomentScrean/MomentContent.dart';
import 'package:ahlachat/view/widgets/ImageView.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class UserPostsWidgets extends StatelessWidget {
  const UserPostsWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    final MomentViewModel posts =
        Provider.of<MomentViewModel>(context, listen: true);

    final usermodel? profile = user.userProfileData;

    // Reverse a copy of the existing list.
    // This does not change the list stored in the profile model.
    final List<Postes> reversedPosts =
        List<Postes>.from(profile?.Postuser ?? <Postes>[]).reversed.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(reversedPosts.length, (index) {
        final Postes post = reversedPosts[index];

        final bool isLiked =
            posts.LikedPost.contains(post.id.toString());

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: SizedBox(
            width: SizeConfig.screenWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(
                      context: context,
                      screen: Momentcontent(ChoosePost: post),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            (profile?.image ?? '').isNotEmpty
                                ? CachedNetworkImageProvider(
                                    profile!.image!,
                                  )
                                : null,
                        radius: 23,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: UserSideInfoWidgets(
                          UserDate: profile,
                          showdescr: 1,
                        ),
                      ),
                      if (profile?.id == user.userinfo?.id)
                        SizedBox(
                          height: 35,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.more_vert,
                              color: MainColor,
                            ),
                            onSelected: (value) {
                              if (value == 'delete') {
                                user.DeletePost(
                                  context: context,
                                  postid: post.id,
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text(
                                  getLang(
                                    context: context,
                                    key: 'Delete',
                                  ),
                                  style: style6,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                InkWell(
                  onTap: () {
                    navigateTo(
                      context: context,
                      screen: Momentcontent(ChoosePost: post),
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        ReadMoreText(
                          post.content ?? '',
                          trimLines: 2,
                          colorClickableText: MainColor,
                          trimMode: TrimMode.Line,
                          style: style5.copyWith(height: 1),
                          trimCollapsedText: getLang(
                            context: context,
                            key: 'Show_more',
                          ),
                          trimExpandedText: getLang(
                            context: context,
                            key: 'Show_less',
                          ),
                          moreStyle: const TextStyle(
                            fontSize: 14,
                            color: MainColor,
                            fontWeight: FontWeight.bold,
                          ),
                          lessStyle: const TextStyle(
                            fontSize: 14,
                            color: MainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),

                        if ((post.image ?? '').isNotEmpty)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ImageView(
                                    url: post.image!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 250,
                              width:
                                  (SizeConfig.screenWidth ?? 300) / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    post.image!.isNotEmpty
                                        ? post.image!
                                        : Images.offical,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  Helper().getTimeago(time: post.createdAt),
                  style: style6.copyWith(
                    fontSize: 13,
                    color: Colors.black26,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (isLiked) {
                              posts.RemoveLike(
                                Postid: post.id,
                                context: context,
                              );
                            } else {
                              posts.LikePost(
                                Postid: post.id,
                                context: context,
                              );
                            }
                          },
                          child: FaIcon(
                            FontAwesomeIcons.fire,
                            color: isLiked ? MainColor : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          post.like?.length.toString() ?? '0',
                          style: style6,
                        ),
                      ],
                    ),

                    InkWell(
                      onTap: () {
                        navigateTo(
                          context: context,
                          screen: Momentcontent(ChoosePost: post),
                        );
                      },
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.comment,
                            color: MainColor,
                            size: 22,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            post.commentsuser?.length.toString() ?? '0',
                            style: style6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
