import 'package:flutter/material.dart';

/// Legacy compatibility widget.
///
/// Leaving a room is different from leaving a chair. This widget is no
/// longer displayed; use the room's normal leave-room flow instead.
class LeaveAdminChair extends StatelessWidget {
  const LeaveAdminChair({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}