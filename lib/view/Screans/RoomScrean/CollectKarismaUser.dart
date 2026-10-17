
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/widgets/UserSideInfoWidget.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserCollectKarismas extends StatelessWidget {
  const UserCollectKarismas({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);

    final contributors = room.Collectkarismas;

    return Container(
      height: 500,
      width: SizeConfig.screenWidth!,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'المساهمين',
            style: style1,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: contributors.isEmpty
                ? const Center(
                    child: Text(
                      'لا يوجد مساهمون حتى الآن',
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                      left: 10,
                      bottom: 16,
                    ),
                    itemCount: contributors.length,
                    itemBuilder: (context, index) {
                      final contributor = contributors[index];
                      final contributorUser = contributor.user;
                      final String image =
                          contributorUser?.image ?? AppConstants.User_Profile;

                      return InkWell(
                        onTap: () {
                          if (user.userinfo?.id != contributorUser?.id) {
                            Navigator.pop(context);
                            room.changeloading13();
                            user.GetShoweduserProfile(contributorUser);
                            CheckBlocked = false;
                            Navigator.pushNamed(
                              context,
                              AppConstants.ShowUser_Profile,
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.transparent,
                                backgroundImage: image.isNotEmpty
                                    ? CachedNetworkImageProvider(image)
                                    : null,
                                child: image.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.white70,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: UserSideInfoWidgets(
                                  UserDate: contributorUser,
                                  TextColor: Colors.white,
                                  showdescr: 0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                contributor.karisma.toString(),
                                style: style6.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                Images.coins,
                                width: 20,
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
