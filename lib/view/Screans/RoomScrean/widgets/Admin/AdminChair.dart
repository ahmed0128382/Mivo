import 'package:ahlachat/view/Screans/RoomScrean/CollectKarismaUser.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/LeaveChairUser/LeaveChairUser.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/Admin/AdminKarisma.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/InviteToChairScrean/InviteToChairScrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/RoomUserProfile.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:provider/provider.dart';


class AdminChair extends StatelessWidget {
  const AdminChair({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);
    final LoginViewmodel user =
        Provider.of<LoginViewmodel>(context, listen: true);
    final AgoraViewmodel agora =
        Provider.of<AgoraViewmodel>(context, listen: true);

    final chairs = room.Currentroom?.chairs;
final adminChair =
    chairs != null && chairs.length > 8 ? chairs[8] : null;
final secondKingChair =
    chairs != null && chairs.length > 9 ? chairs[9] : null;

    if (adminChair == null) {
      
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminChair.adminleaved == 1 || adminChair.user == null
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  Images.Chairs,
                  height: 50,
                  width: 50,
                ),
              )
            : SizedBox(
                width: 70,
                child: InkWell(
                  onTap: () {
                   
                    if (user.userinfo?.id.toString() ==
                        room.Currentroom?.adminId.toString()) {
                     

                      user.userinfoRoom(
                        context: context,
                        id: adminChair.user?.id,
                      );
                      user.getuserroominfo(user: adminChair.user);

                      GlopalbottomSheet(
                        context: context,
                        Screan: const MyProfileInRoom(),
                      );
                    }

                    if (user.userinfo?.id.toString() !=
                            room.Currentroom?.adminId.toString() &&
                        adminChair.user != null) {
                     

                      user.userinfoRoom(
                        context: context,
                        id: adminChair.user?.id,
                      );
                      user.getuserroominfo(user: adminChair.user);

                      GlopalbottomSheet(
                        context: context,
                        Screan: const RoomUserProfile(),
                      );
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (agora.isUserSpeaking(
                            int.tryParse(
                                  adminChair.userId?.toString() ?? '0',
                                ) ??
                                0,
                          ) &&
                          adminChair.mute == 0)
                        Positioned(
                          top: 0,
                          child: AvatarGlow(
                            glowColor: Colors.tealAccent,
                            glowRadiusFactor: 1.2,
                            glowCount: 2,
                            duration: const Duration(milliseconds: 1000),
                            repeat: true,
                            animate: true,
                            child: const SizedBox(
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PhotoFrame(
                            image: room.checkadmin(context: context)
                                ? user.userinfo?.image
                                : adminChair.user?.image,
                            Frame: room.checkadmin(context: context)
                                ? user.userinfo?.frameimage
                                : adminChair.user?.frameimage,
                          ),
                          InkWell(
                            onTap: () {
                            

                              GlopalbottomSheet(
                                context: context,
                                Screan: UserCollectKarismas(),
                              );

                              room.GetCollectKarisma(
                                context: context,
                                userid: adminChair.userId,
                                chairid: adminChair.id,
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  Helper().CutName(
                                    room.Currentroom?.admin?.name ?? '',
                                  ),
                                  style: Namestyle.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 12,
                                    height: 1,
                                    color: whitecolor,
                                  ),
                                ),
                                const AdminKarisma(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      adminChair.userId == null
                          ? const SizedBox()
                          : Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white54,
                                  child: Icon(
                                    adminChair.mute == 0
                                        ? Icons.mic
                                        : Icons.mic_off_outlined,
                                    color: whitecolor,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                      if (user.imoge.any(
                        (element) =>
                            element['uid'] ==
                            int.tryParse(adminChair.userId ?? '0'),
                      ))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.transparent,
                            child: CachedNetworkImage(
                              imageUrl: user.imoge
                                  .where(
                                    (element) =>
                                        element['uid'] ==
                                        int.tryParse(
                                          adminChair.userId ?? '0',
                                        ),
                                  )
                                  .first['imoge'],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

        if (room.Currentroom?.SecondKing == 1)
          secondKingChair == null
              ? const SizedBox.shrink()
              : secondKingChair.user == null
                  ? InkWell(
                      onTap: () {
                       

                        if (room.checkadmin(context: context) ||
                            (room.Currentroom?.supervisorsId
                                    ?.contains(
                                      user.userinfo?.id.toString(),
                                    ) ??
                                false)) {
                        

                          room.InvitedChair.clear();
                          room.UserIds.clear();

                          room.Currentroom?.chairs?.forEach((element) {
                            if (element.userId != null &&
                                element.userId.toString() !=
                                    user.userinfo?.id.toString() &&
                                element.user != null) {
                              room.InvitedChair.add(
                                element.user?.id.toString() ?? '',
                              );
                            }
                          });

                          InviteChairId =
                              secondKingChair.chairId ?? '';

                          

                          showModalBottomSheet(
                            barrierColor: Colors.transparent,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return const InviteToChair();
                            },
                          );

                          room.GetUserJoin(context: context);
                        } else {
                         
                        }
                      },
                      child: Image.asset(
                        Images.k3,
                        height: 70,
                        width: 70,
                      ),
                    )
                  : Container(
                      color: Colors.transparent,
                      width: 70,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                               

                                if (room.JoinChairLoding) {
                                 

                                  Dialogs().showtoast(
                                    getLang(
                                      context: context,
                                      key: 'wait',
                                    ),
                                  );
                                } else {
                                  if (user.userinfo?.id.toString() ==
                                      secondKingChair.user?.id.toString()) {
                                   

                                    user.userinfoRoom(
                                      context: context,
                                      id: secondKingChair.user?.id,
                                    );
                                    user.getuserroominfo(
                                      user: secondKingChair.user,
                                    );

                                    GlopalbottomSheet(
                                      context: context,
                                      Screan: const LeaveChairUser(),
                                    );
                                  }

                                  if (room.Currentroom?.adminId.toString() ==
                                          user.userinfo?.id.toString() &&
                                      secondKingChair.user != null) {
                                   

                                    room.Chairids = secondKingChair.chairId;
                                    room.useridchair =
                                        secondKingChair.user?.id;
                                    room.ChairIndes = 9;

                                    user.userinfoRoom(
                                      context: context,
                                      id: secondKingChair.user?.id,
                                    );
                                    user.getuserroominfo(
                                      user: secondKingChair.user,
                                    );

                                    GlopalbottomSheet(
                                      context: context,
                                      Screan: const RoomUserProfile(),
                                    );
                                  } else if (secondKingChair.Lock == 1) {
                                   

                                    Dialogs().showtoast(
                                      getLang(
                                        context: context,
                                        key: 'Chair_lock',
                                      ),
                                    );
                                  } else if (room.Currentroom?.adminId
                                          .toString() ==
                                      user.userinfo?.id.toString()) {
                                   

                                    Dialogs().showtoast(
                                      getLang(
                                        context: context,
                                        key: 'Canmove_admin',
                                      ),
                                    );
                                  } else {
                                    if (!JoinChairs &&
                                        secondKingChair.userId == null) {
                                     

                                      room.JoinChair(
                                        index: 9,
                                        context: context,
                                        chairid: secondKingChair.chairId,
                                      );
                                    } else {
                                      if (secondKingChair.userId.toString() ==
                                          user.userinfo?.id.toString()) {
                                       

                                        room.Chairid =
                                            secondKingChair.chairId ?? '0';
                                        room.Chairidex = 9;

                                        user.userinfoRoom(
                                          context: context,
                                          id: user.userinfo?.id.toString(),
                                        );
                                        user.getuserroominfo(
                                          user: user.userinfo,
                                        );
                                        room.showSpinner5();
                                      } else if (
                                          secondKingChair.userId == null &&
                                          JoinChairs) {
                                       

                                        Dialogs().showtoast(
                                          getLang(
                                            context: context,
                                            key: 'Cant_move',
                                          ),
                                        );
                                      } else {
                                     

                                        user.userinfoRoom(
                                          context: context,
                                          id: secondKingChair.user?.id,
                                        );
                                        user.getuserroominfo(
                                          user: secondKingChair.user,
                                        );

                                        GlopalbottomSheet(
                                          context: context,
                                          Screan: const RoomUserProfile(),
                                        );
                                      }
                                    }
                                  }
                                }

                               
                              },
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      PhotoFrame(
                                        image: secondKingChair.user?.image,
                                        Frame:
                                            secondKingChair.user?.frameimage,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          

                                          GlopalbottomSheet(
                                            context: context,
                                            Screan: UserCollectKarismas(),
                                          );

                                          room.GetCollectKarisma(
                                            context: context,
                                            userid: secondKingChair.userId,
                                            chairid: secondKingChair.id,
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              Helper().CutName(
                                                secondKingChair.user?.name ??
                                                    '',
                                              ),
                                              style: Namestyle.copyWith(
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                fontSize: 12,
                                                color: whitecolor,
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Helper().k_m_b_generator(
                                                    secondKingChair.Karisma,
                                                  ),
                                                  style: style2.copyWith(
                                                    fontSize: 7,
                                                    color: whitecolor,
                                                  ),
                                                ),
                                                const SizedBox(width: 3),
                                                const FaIcon(
                                                  FontAwesomeIcons
                                                      .heartCircleCheck,
                                                  size: 8,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  secondKingChair.userId == null
                                      ? const SizedBox()
                                      : Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.transparent,
                                            ),
                                            child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor: Colors.white54,
                                              child: Icon(
                                                secondKingChair.mute == 0
                                                    ? Icons.mic
                                                    : Icons.mic_off_outlined,
                                                color: whitecolor,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                  if (user.imoge.any(
                                    (element) =>
                                        element['uid'] ==
                                        int.tryParse(
                                          secondKingChair.userId ?? '0',
                                        ),
                                  ))
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        color: Colors.transparent,
                                        child: CachedNetworkImage(
                                          imageUrl: user.imoge
                                              .where(
                                                (element) =>
                                                    element['uid'] ==
                                                    int.tryParse(
                                                      secondKingChair.userId ??
                                                          '0',
                                                    ),
                                              )
                                              .first['imoge'],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
      ],
    );
  }
}
