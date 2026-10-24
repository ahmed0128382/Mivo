
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../util/Localization.dart';
import '../../../../util/styles.dart';
import '../../../../viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'MyFramesWidgets.dart';

class FrameItem extends StatelessWidget {
  final int index1;

  const FrameItem(this.index1, {super.key});

  DateTime? _getExpiryDate(dynamic sale) {
    final timestamp = sale.createdAt?.toString() ?? '';

    if (timestamp.isEmpty) {
      return null;
    }

    try {
      return DateTime.parse(timestamp).toUtc();
    } catch (_) {
      return null;
    }
  }

  bool _isSaleActive(dynamic sale) {
    final expiryDate = _getExpiryDate(sale);

    // Preserve records with missing or invalid expiration data.
    if (expiryDate == null) {
      return true;
    }

    return expiryDate.isAfter(DateTime.now().toUtc());
  }

  List<dynamic> _removeDuplicates(List<dynamic> sales) {
    // Keep one sale per item_id: the one with the latest expiration.
    final Map<String, dynamic> latestSales = {};

    for (final sale in sales) {
      final itemId = sale.itemId?.toString() ?? '';

      // Keep records with no item ID rather than accidentally grouping them.
      if (itemId.isEmpty) {
        latestSales['missing_${sale.id}'] = sale;
        continue;
      }

      final existingSale = latestSales[itemId];

      if (existingSale == null) {
        latestSales[itemId] = sale;
        continue;
      }

      final currentExpiry = _getExpiryDate(sale);
      final existingExpiry = _getExpiryDate(existingSale);

      if (currentExpiry != null &&
          (existingExpiry == null ||
              currentExpiry.isAfter(existingExpiry))) {
        latestSales[itemId] = sale;
      }
    }

    return latestSales.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final shop = Provider.of<ShopViewmodel>(context);

    if (index1 < 0 || index1 >= shop.AllMyItem.length) {
      return const SizedBox.shrink();
    }

    final category = shop.AllMyItem[index1];
    final allSales = category.sales ?? [];

    // First remove expired purchases.
    final activeSales = allSales.where(_isSaleActive).toList();

    // Then keep only the purchase with the longest time remaining
    // for each item_id.
    final sales = _removeDuplicates(activeSales);

    if (sales.isEmpty) {
      return Center(
        child: Text(
          getLang(context: context, key: 'NoItems'),
          style: style2.copyWith(
            color: Colors.black54,
            fontSize: 14,
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(4),
          sliver: SliverGrid(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final sale = sales[index];

                return Frameitemwidgets(
                  items: sale.item,
                  create: sale.createdAt,
                  update_at: sale.updatedAt,
                  durationDays: sale.day?.toString(),
                );
              },
              childCount: sales.length,
            ),
          ),
        ),
      ],
    );
  }
}
