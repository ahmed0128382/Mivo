import 'package:flutter/cupertino.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryReporter {
  late Sentry sentry;
  static Future<void> setup(Widget child) async {
    await SentryFlutter.init(
          (options) {
        options.dsn = 'https://386710488c824ee7ae8ac1a18bc4cb3d@o4503951050997760.ingest.sentry.io/4503951052308481';
        options.tracesSampleRate = 1.0;
        options.reportPackages = false;
        options.considerInAppFramesByDefault = false;
        // options.environmentAttributes = {
        //   'app_version': '1.0.0',
        //   'device_name': 'My device',
        //   'device_id': '12345',
        // };
      },
      appRunner: () => runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(
            enableStructuredDataTracing: true,
          ),
          child: child,
        ),
      ),
    );
  }

  static genericThrow(String message, Exception exc, {stackTrace}) async {
    if (stackTrace != null) {
      Sentry.captureException(exc, stackTrace: stackTrace);
    } else {
      Sentry.captureException(exc);
    }
  }

  static setupPerformance() async {
    final transaction = Sentry.startTransaction('processOrderBatch', 'task');
    try {
      await processOrderBatch(transaction);
    } catch (exc) {
      transaction.throwable = exc;
      transaction.status = const SpanStatus.internalError();
    } finally {
      await transaction.finish();
    }
  }

  static Future<void> processOrderBatch(ISentrySpan span) async {
    final innerSpan = span.startChild('task', description: 'operation');
    try {
      await Future.delayed(const Duration(seconds: 1));
    } catch (exc) {
      innerSpan.throwable = exc;
      innerSpan.status = const SpanStatus.notFound();
    } finally {
      await innerSpan.finish();
    }
  }
}
