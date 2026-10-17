import 'package:flutter/material.dart';

/// Legacy compatibility widget.
///
/// Room participation no longer uses chairs. Remove this widget from
/// room layouts and use the participant list instead.
class ChairLockwidget extends StatelessWidget {
  final int index;

  const ChairLockwidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}