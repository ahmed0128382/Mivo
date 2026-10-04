
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PusherClient? pusher;
  Channel? channel;

  static const String pusherAppKey = '4e68aedca5c74610deac';
  static const String pusherCluster = 'mt1';

  @override
  void initState() {
    super.initState();

    pusher = PusherClient(
      pusherAppKey,
      PusherOptions(
        cluster: pusherCluster,
        encrypted: true,
      ),
      enableLogging: true,
    );

    pusher?.onConnectionStateChange((state) {
      log(
        'PUSHER STATE: '
        '${state?.previousState} -> ${state?.currentState}',
      );
    });

    pusher?.onConnectionError((error) {
      log(
        'PUSHER ERROR: '
        '${error?.message}',
      );
    });

    channel = pusher?.subscribe('Gigo');

    channel?.bind('Gigo', (event) {
      log(
        'PUSHER GIGO EVENT: '
        '${event?.data}',
      );
    });

    log('PUSHER: Connecting...');
    pusher?.connect();
  }

  @override
  void dispose() {
    log('PUSHER: Disposing...');

    channel?.unbind('Gigo');
    pusher?.unsubscribe('Gigo');
    pusher?.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pusher Test'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  log('PUSHER: Connecting...');
                  pusher?.connect();
                },
                child: const Text('Connect Pusher'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  log('PUSHER: Unsubscribing from Gigo...');

                  pusher?.unsubscribe('Gigo');
                  channel = null;
                },
                child: const Text('Unsubscribe Gigo'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  log('PUSHER: Binding Gigo event...');

                  channel?.bind(
                    'Gigo',
                    (PusherEvent? event) {
                      log(
                        'GIGO EVENT: '
                        '${event?.data}',
                      );
                    },
                  );
                },
                child: const Text('Bind Gigo Event'),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {
                  log('PUSHER: Unbinding Gigo event...');

                  channel?.unbind('Gigo');
                },
                child: const Text('Unbind Gigo Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
