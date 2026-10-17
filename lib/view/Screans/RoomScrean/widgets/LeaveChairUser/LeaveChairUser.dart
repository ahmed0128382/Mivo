import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/SizeConfig.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/ShowUserRoom.dart';
import 'package:ahlachat/view/widgets/PhotoWithFrame.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/util/helperclass.dart';
import 'package:ahlachat/view/widgets/UserInfoWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Legacy filename/class name retained for existing imports.
///
/// This widget displays a room participant's profile and received gifts.
/// It no longer contains a Leave Chair action.
class LeaveChairUser extends StatelessWidget {
  const LeaveChairUser({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomViewmodel room =
        Provider.of<RoomViewmodel>(context, listen: true);
    final LoginViewmodel login =
        Provider.of<LoginViewmodel>(context, listen: true);

    // Retain these providers if other existing room UI depends on them.
    Provider.of<AgoraViewmodel>(context, listen: false);
    Provider.of<GiftsViewModel>(context, listen: false);

    final dynamic selectedUser = login.userroominfo;

    if (selectedUser == null) {
      return Container(
        width: SizeConfig.screenWidth!,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF11141D),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: const Text(
          'Participant information is unavailable.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Container(
      width: SizeConfig.screenWidth!,
      decoration: const BoxDecoration(
        color: Color(0xFF11141D),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),

            PhotoFrame2(
              image: selectedUser.image,
              Frame: selectedUser.frameimage,
            ),

            const SizedBox(height: 12),

            UserInfoWidgets(UserDate: selectedUser),

            const SizedBox(height: 20),

            if (!login.showloading3)
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    barrierColor: Colors.black54,
                    isScrollControlled: true,
                    backgroundColor: const Color(0xFF11141D),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(26),
                      ),
                    ),
                    builder: (_) => const ShowGiftRoom(),
                  );
                },
                child: Container(
                  height: 54,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Images.CAS,
                        height: 30,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Gift activity',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if ((selectedUser.giftssent?.length ?? 0) > 0)
                        ...List.generate(
                          (selectedUser.giftssent!.length > 3)
                              ? 3
                              : selectedUser.giftssent!.length,
                          (index) {
                            final String imageUrl =
                                selectedUser.giftssent?[index].gift?.image
                                        ?.toString() ??
                                    '';

                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: imageUrl.isEmpty
                                    ? const Icon(
                                        Icons.card_giftcard,
                                        color: Colors.white54,
                                        size: 20,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.contain,
                                        errorWidget: (_, __, ___) =>
                                            const Icon(
                                          Icons.card_giftcard,
                                          color: Colors.white54,
                                          size: 20,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white54,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Leaving the room is handled by the room-level leave flow.
            // There is deliberately no chair-leaving button here.
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white70,
                ),
                label: Text(
                  getLang(context: context, key: 'Cancel'),
                  style: style3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}