
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:provider/provider.dart';

class CustomizeAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? tittle;
  final bool? autopop;

  const CustomizeAppbar({
    super.key,
    this.tittle,
    this.autopop,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 56,
        backgroundColor: MainColor,
        automaticallyImplyLeading: false,
        title: Text(
          tittle ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style2.copyWith(color: whitecolor),
        ),
        leading: (autopop ?? false)
            ? null
            : IconButton(
                tooltip: MaterialLocalizations.of(context)
                    .backButtonTooltip,
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: whitecolor,
                ),
              ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class CustomizeChatAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? tittle;
  final String? image;
  final usermodel? userchat;
  final dynamic InBoxid;

  const CustomizeChatAppbar({
    super.key,
    this.tittle,
    this.image,
    this.userchat,
    this.InBoxid,
  });

  @override
  Widget build(BuildContext context) {
    final InboxroomViewModel inboxrooms =
        Provider.of<InboxroomViewModel>(context, listen: false);

    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: false);

    final String profileImage = image?.trim().isNotEmpty == true
        ? image!.trim()
        : Images.profilephoto;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        centerTitle: false,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,

        leadingWidth: 48,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context)
              .backButtonTooltip,
          onPressed: () {
            inboxrooms.ExistChatRoom();
            Navigator.maybePop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black45,
          ),
        ),

        titleSpacing: 0,
        title: InkWell(
          onTap: () {
            user.GetShoweduserProfile(userchat);
            Navigator.pushNamed(
              context,
              AppConstants.ShowUser_Profile,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    CachedNetworkImageProvider(profileImage),
              ),
              const SizedBox(width: 8),

              // Restrict the user information to the available width.
              Expanded(
                child: ClipRect(
                  child: UserSideInfoWidgets(
                    UserDate: userchat,
                    showdescr: 1,
                  ),
                ),
              ),
            ],
          ),
        ),

        actions: [
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (value) {
              if (value == 'Delete') {
                inboxrooms.DeleteInboxroom(
                  context: context,
                  inboxid: InBoxid,
                );
              } else if (value == 'Block') {
                inboxrooms.BlockUser(
                  UserId: user.userProfileData?.id,
                  id: InBoxid,
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Block',
                child: Text(
                  getLang(
                    context: context,
                    key: 'Block_User',
                  ),
                  style: style6,
                ),
              ),
              PopupMenuItem<String>(
                value: 'Delete',
                child: Text(
                  getLang(
                    context: context,
                    key: 'Delete_Conv',
                  ),
                  style: style6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
