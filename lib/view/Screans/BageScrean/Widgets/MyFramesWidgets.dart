
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../models/ShopModel.dart';
import '../../../../util/Dialogs.dart';
import '../../../../util/Localization.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';

class Frameitemwidgets extends StatelessWidget {
  final Items? items;

  /// Expiration timestamp from the top-level Sales.created_at field.
  final String? create;

  /// Kept for compatibility with existing calls.
  final String? update_at;

  /// Purchased duration from Sales.day.
  final String? durationDays;

  const Frameitemwidgets({
    super.key,
    this.items,
    this.create,
    this.update_at,
    this.durationDays,
  });

  int? _getRemainingDays() {
    final expiryTimestamp = create;

    if (expiryTimestamp == null || expiryTimestamp.isEmpty) {
      return null;
    }

    try {
      // Convert the API timestamp to the device's local timezone.
      final expiryDate = DateTime.parse(expiryTimestamp).toLocal();
      final now = DateTime.now();

      // Compare calendar dates, ignoring the hours and minutes.
      final expiryDay = DateTime(
        expiryDate.year,
        expiryDate.month,
        expiryDate.day,
      );

      final today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      final remainingDays = expiryDay.difference(today).inDays;

      // Expired calendar dates have no remaining days.
      if (remainingDays <= 0) {
        return 0;
      }

      return remainingDays;
    } catch (_) {
      return null;
    }
  }

  String _getDurationText() {
    final remainingDays = _getRemainingDays();

    if (remainingDays == null || remainingDays <= 0) {
      return '';
    }

    return remainingDays == 1
        ? 'For 1 Day'
        : 'For $remainingDays Days';
  }

  @override
  Widget build(BuildContext context) {
    final shops = Provider.of<ShopViewmodel>(
      context,
      listen: false,
    );

    final user = Provider.of<LoginViewmodel>(
      context,
      listen: true,
    );

    final isSelected =
        user.userinfo?.frameimage == items?.svggift ||
        user.userinfo?.entry == items?.svggift ||
        user.userinfo?.Enterbubles == items?.imagegift ||
        user.userinfo?.bubbles == items?.svggift;

    final durationText = _getDurationText();

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: BoxDecoration(
          color: whitecolor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: InkWell(
                  onTap: () {
                    if (items?.kind == 0 ||
                        items?.kind == 2 ||
                        items?.kind == 3) {
                      Dialogs().ShowEntery(
                        context: context,
                        svga: items?.svggift,
                      );
                    } else if (items?.kind == 1) {
                      Dialogs().ShowFrame(
                        context: context,
                        svga: items?.svggift,
                      );
                    }
                  },
                  child: FaIcon(
                    FontAwesomeIcons.playCircle,
                    size: 19,
                    color: MainColor,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Expanded(
                flex: 5,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: items?.imagegift ?? '',
                    fit: BoxFit.contain,
                    errorWidget: (context, url, error) {
                      return const Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.black26,
                        size: 36,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: Text(
                  items?.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: style6.copyWith(
                    fontWeight: FontWeight.normal,
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ),
              if (durationText.isNotEmpty) ...[
                const SizedBox(height: 3),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    durationText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: style5.copyWith(
                      fontSize: 11,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    if (isSelected) {
                      if (items?.kind == 0) {
                        shops.RemoveEntry(context: context);
                      } else if (items?.kind == 1) {
                        shops.RemoveFrame(context: context);
                      } else if (items?.kind == 2) {
                        shops.RemoveEnterbubles(context: context);
                      } else if (items?.kind == 3) {
                        shops.RemoveProfilebubles(context: context);
                      }
                    } else {
                      if (items?.kind == 0) {
                        shops.UserpdateEntry(
                          context: context,
                          Entry: items?.svga,
                        );
                      } else if (items?.kind == 1) {
                        shops.UserpdateFrame(
                          context: context,
                          Frame: items?.svga,
                        );
                      } else if (items?.kind == 2) {
                        shops.UserpdateEnterbubles(
                          context: context,
                          Frame: items?.image,
                        );
                      } else if (items?.kind == 3) {
                        shops.UserpdatepROFILEbubles(
                          context: context,
                          Frame: items?.svga,
                        );
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: MainColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      getLang(
                        context: context,
                        key: isSelected ? 'Remove' : 'set',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style4.copyWith(
                        fontSize: 12,
                        color: whitecolor,
                      ),
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
