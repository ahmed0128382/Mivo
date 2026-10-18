
import 'package:ahlachat/view/Screans/MainScreans/ShopScrean/SendtofriendsScrean.dart';
import 'package:ahlachat/view/widgets/ModelSheet.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Relations_ViewModel/RelationsViewModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/models/ShopModel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../util/SizeConfig.dart';
import '../../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../ByeItem.dart';

class Framewidgets extends StatelessWidget {
  final Items? items;

  const Framewidgets({super.key, this.items});

  @override
  Widget build(BuildContext context) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: true);
    FollowViewModel follow = Provider.of<FollowViewModel>(context, listen: true);
    RelationsViewModel relation = Provider.of<RelationsViewModel>(context, listen: true);

    RoomViewmodel room = Provider.of<RoomViewmodel>(context, listen: true);
    ShopViewmodel shops = Provider.of<ShopViewmodel>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: whitecolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Action / Play Icon
              if (items?.kind != 4)
                InkWell(
                  onTap: () {
                    if (items?.kind == 0 || items?.kind == 2 || items?.kind == 3) {
                      Dialogs().ShowEntery(context: context, svga: items?.svggift);
                    } else if (items?.kind == 1) {
                      Dialogs().ShowFrame(context: context, svga: items?.svggift);
                    }
                  },
                  child: FaIcon(FontAwesomeIcons.playCircle, size: 18, color: MainColor),
                )
              else
                const SizedBox(height: 18),

              // Gift Image
              Center(
                child: CachedNetworkImage(
                  imageUrl: items?.imagegift ?? '',
                  height: 55,
                  width: 55,
                  fit: BoxFit.contain,
                ),
              ),

              // Item Name
              Center(
                child: Text(
                  items?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ),

              // Price & Duration Info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.coins, height: 13, width: 13),
                  const SizedBox(width: 3),
                  Text(
                    ((items?.price ?? 0) * 7).toString(),
                    style: style6.copyWith(
                      fontSize: 11,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (items?.kind != 4)
                    Flexible(
                      child: Text(
                        ' / 7 ${getLang(key: "Days", context: context)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: style6.copyWith(
                          fontWeight: FontWeight.normal,
                          height: 1,
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),

              // Buy / Dedicate Button
              InkWell(
                onTap: () {
                  if (items?.kind != 4) {
                    room.GetShowItem(items);
                    shops.Getid(id: items?.id, CategoryId: items?.shopcategoryId);
                    shops.selectPackage(
                      value: 2,
                      Priceitem: (items?.price ?? 0) * 7,
                      Dayitem: 7,
                    );
                    GlopalbottomSheet2(context: context, Screan: ByeItem());
                  } else {
                    if ((items?.price ?? 0) <= (user.userinfo?.coins ?? 0)) {
                      follow.GetFriends(context: context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendrelationshipToFriendsScrean(),
                        ),
                      ).then((value) {
                        if (value != null) {
                          GlopalbottomSheet2(
                            context: context,
                            Screan: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 15),
                                    CachedNetworkImage(
                                      imageUrl: items?.imagegift ?? '',
                                      height: 90,
                                      width: 90,
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(Images.coins, height: 22, width: 22),
                                            const SizedBox(width: 8),
                                            Text(
                                              ((items?.price ?? 0) * 7).toString(),
                                              style: style6.copyWith(
                                                fontSize: 16,
                                                height: 1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(items?.name ?? '', style: style2),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'تحديد مده الشراء : ',
                                          style: TextStyle(color: Colors.black26),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          width: SizeConfig.screenWidth,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: SecondColor,
                                          ),
                                          child: const Center(child: Text('دائم')),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: whitecolor2,
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6),
                                            child: Row(
                                              children: [
                                                Image.asset(Images.coins, height: 18, width: 18),
                                                const SizedBox(width: 6),
                                                Text(
                                                  user.userinfo?.coins.toString() ?? '0',
                                                  style: style6.copyWith(
                                                    fontSize: 12,
                                                    height: 1,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            relation.SendRelation(
                                              Relationid: items?.id,
                                              UserId: value.id,
                                              context: context,
                                            );
                                          },
                                          child: Container(
                                            width: 140,
                                            height: 38,
                                            decoration: BoxDecoration(
                                              color: MainColor,
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                                  child: Text(
                                                    getLang(context: context, key: "Dedication"),
                                                    style: style1,
                                                  ),
                                                ),
                                                CircleAvatar(
                                                  radius: 16,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(value.image),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    } else {
                      Dialogs().showtoast(getLang(context: context, key: "Not_Enough"));
                    }
                  }
                },
                child: Container(
                  height: 28,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MainColor,
                  ),
                  child: Center(
                    child: Text(
                      items?.kind == 4
                          ? getLang(context: context, key: "Dedication")
                          : getLang(context: context, key: "Bye"),
                      style: style4.copyWith(fontSize: 13, color: whitecolor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}