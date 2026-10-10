
import 'package:flutter/foundation.dart';

class ChairDebugLogger {
  // Set to true temporarily when chair debugging is needed.
  static const bool _enabled = false;

  static const String _tag = '[CHAIR_DEBUG]';

  static void log(String stage, Map<String, dynamic> data) {
    if (!_enabled || !kDebugMode) return;

    debugPrint('$_tag $stage');
    debugPrint(data.toString());
  }

  static void error(
    String stage,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    if (!_enabled || !kDebugMode) return;

    debugPrint('$_tag ERROR: $stage');
    debugPrint('$_tag $error');

    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
