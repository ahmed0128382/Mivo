import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pusher_client/pusher_client.dart';

class RoomConnectionTestScreen extends StatefulWidget {
  const RoomConnectionTestScreen({super.key});

  @override
  State<RoomConnectionTestScreen> createState() =>
      _RoomConnectionTestScreenState();
}

class _RoomConnectionTestScreenState
    extends State<RoomConnectionTestScreen> {
  static const String _pusherAppKey = 'c131d267a74a0cbd3da9';
  static const String _pusherCluster = 'mt1';

  // Must match the App ID used by the backend to generate the Agora token.
  static const String _agoraAppId =
      '808fe19c64ec48868d2499f86c97457e';

  final TextEditingController _roomIdController =
      TextEditingController(text: '5');

  final TextEditingController _uidController =
      TextEditingController(text: '13');

  final TextEditingController _tokenController =
      TextEditingController();

  PusherClient? _pusher;
  Channel? _channel;
  RtcEngine? _engine;

  bool _pusherConnecting = false;
  bool _agoraConnecting = false;
  bool _agoraJoined = false;
  bool _isBroadcaster = true;
  bool _showToken = false;

  String _pusherStatus = 'Not connected';
  String _subscriptionStatus = 'Not subscribed';
  String _agoraStatus = 'Not connected';

  final List<String> _logs = [];

  String get _roomChannel =>
      'Room${_roomIdController.text.trim()}';

  void _log(String message) {
    log(message);

    if (!mounted) return;

    setState(() {
      _logs.insert(
        0,
        '${DateTime.now().toIso8601String().substring(11, 19)}  $message',
      );

      if (_logs.length > 100) {
        _logs.removeLast();
      }
    });
  }

  void _updatePusherStatus(String status) {
    if (!mounted) return;
    setState(() => _pusherStatus = status);
  }

  void _updateAgoraStatus(String status) {
    if (!mounted) return;
    setState(() => _agoraStatus = status);
  }

  // =========================================================
  // PUSHER TEST
  // Channel: Room5
  // Event: Room
  // =========================================================

  Future<void> _connectPusher() async {
    final roomId = _roomIdController.text.trim();

    if (roomId.isEmpty) {
      _log('[PUSHER] Enter a room ID first.');
      return;
    }

    await _disconnectPusher();

    if (!mounted) return;

    setState(() {
      _pusherConnecting = true;
      _pusherStatus = 'Connecting...';
      _subscriptionStatus = 'Subscribing to $_roomChannel...';
    });

    try {
      final pusher = PusherClient(
        _pusherAppKey,
        PusherOptions(
          cluster: _pusherCluster,
          encrypted: true,
        ),
        enableLogging: true,
      );

      _pusher = pusher;

      pusher.onConnectionStateChange((state) {
        final previous = state?.previousState;
        final current = state?.currentState;

        _log('[PUSHER] Connection: $previous -> $current');
        _updatePusherStatus('$current');

        if (current.toString().toLowerCase().contains('connected')) {
          if (mounted) {
            setState(() => _pusherConnecting = false);
          }
        }
      });

      pusher.onConnectionError((error) {
        _log('[PUSHER] Connection error: ${error?.message}');
        _updatePusherStatus(
          'Connection error: ${error?.message ?? 'unknown'}',
        );

        if (mounted) {
          setState(() => _pusherConnecting = false);
        }
      });

      // Subscribe to the exact room channel requested by the backend.
      final channelName = _roomChannel;
      final channel = pusher.subscribe(channelName);
      _channel = channel;

      channel.bind('Room', (PusherEvent? event) {
        final rawData = event?.data;

        _log('[PUSHER] EVENT RECEIVED: channel=$channelName');
        _log('[PUSHER] Event name: Room');
        _log('[PUSHER] Payload: ${rawData ?? '(empty)'}');

        // Parse JSON only for inspection. This test screen does not
        // execute the production room event handlers.
        if (rawData != null) {
          try {
            final decoded = jsonDecode(rawData);

            if (decoded is Map) {
              _log('[PUSHER] Payload state: ${decoded['state']}');
            }
          } catch (e) {
            _log('[PUSHER] Payload is not valid JSON: $e');
          }
        }

        if (mounted) {
          setState(() {
            _subscriptionStatus = 'Event received: Room';
          });
        }
      });

      _log('[PUSHER] Subscribing to $channelName');
      _log('[PUSHER] Listening for event: Room');

      // Connect after registering the channel and event handler.
      await pusher.connect();
    } catch (e, stackTrace) {
      _log('[PUSHER] Setup failed: $e');
      log('$stackTrace');

      _updatePusherStatus('Setup failed');

      if (mounted) {
        setState(() {
          _pusherConnecting = false;
          _subscriptionStatus = 'Subscription setup failed';
        });
      }
    }
  }

  Future<void> _disconnectPusher() async {
    final channel = _channel;
    final pusher = _pusher;

    _channel = null;
    _pusher = null;

    try {
      channel?.unbind('Room');
    } catch (e) {
      _log('[PUSHER] Unbind error: $e');
    }

    try {
      if (pusher != null) {
        pusher.unsubscribe(_roomChannel);
        pusher.disconnect();
      }
    } catch (e) {
      _log('[PUSHER] Disconnect error: $e');
    }

    if (mounted) {
      setState(() {
        _pusherConnecting = false;
        _pusherStatus = 'Disconnected';
        _subscriptionStatus = 'Not subscribed';
      });
    }
  }

  // =========================================================
  // AGORA TEST
  // =========================================================

  Future<void> _joinAgora() async {
    if (_agoraConnecting || _agoraJoined) {
      _log('[AGORA] Already connecting or joined.');
      return;
    }

    final roomId = _roomIdController.text.trim();
    final token = _tokenController.text.trim();
    final uid = int.tryParse(_uidController.text.trim());

    if (roomId.isEmpty) {
      _log('[AGORA] Room ID is required.');
      return;
    }

    if (token.isEmpty) {
      _log('[AGORA] Paste the token returned by your backend.');
      return;
    }

    if (uid == null || uid <= 0) {
      _log('[AGORA] UID must be a positive integer.');
      return;
    }

    setState(() {
      _agoraConnecting = true;
      _agoraStatus = 'Initializing...';
    });

    try {
      final engine = createAgoraRtcEngine();
      _engine = engine;

      await engine.initialize(
        const RtcEngineContext(appId: _agoraAppId),
      );

      await engine.setChannelProfile(
        ChannelProfileType.channelProfileLiveBroadcasting,
      );

      await engine.enableAudio();

      await engine.setClientRole(
        role: _isBroadcaster
            ? ClientRoleType.clientRoleBroadcaster
            : ClientRoleType.clientRoleAudience,
      );

      engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            _log(
              '[AGORA] JOIN SUCCESS: '
              'channel=${connection.channelId}, '
              'uid=${connection.localUid}, elapsed=${elapsed}ms',
            );

            if (!mounted) return;

            setState(() {
              _agoraConnecting = false;
              _agoraJoined = true;
              _agoraStatus = 'Joined successfully';
            });
          },
          onError: (code, message) {
            // Never log the token.
            _log('[AGORA] ERROR: code=$code message=$message');

            if (!mounted) return;

            setState(() {
              _agoraConnecting = false;
              _agoraStatus = 'Error: $code';
            });
          },
          onConnectionStateChanged: (connection, state, reason) {
            _log(
              '[AGORA] Connection state: '
              '$state, reason=$reason',
            );
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            _log(
              '[AGORA] REMOTE USER JOINED: uid=$remoteUid',
            );
          },
          onUserOffline: (connection, remoteUid, reason) {
            _log(
              '[AGORA] REMOTE USER LEFT: '
              'uid=$remoteUid, reason=$reason',
            );
          },
        ),
      );

      // Agora uses the channel name, not the database room ID itself.
      final channelName = 'Room$roomId';

      _log(
        '[AGORA] Joining channel=$channelName uid=$uid '
        'role=${_isBroadcaster ? 'broadcaster' : 'audience'}',
      );

      await engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(),
      );

      // Success is confirmed only by onJoinChannelSuccess.
      if (mounted && !_agoraJoined) {
        setState(() {
          _agoraStatus = 'Join requested; waiting for callback...';
        });
      }
    } on AgoraRtcException catch (e) {
      _log('[AGORA] SDK EXCEPTION: code=${e.code}, message=${e.message}');
      _updateAgoraStatus('SDK exception: ${e.code}');

      if (mounted) {
        setState(() => _agoraConnecting = false);
      }
    } catch (e, stackTrace) {
      _log('[AGORA] EXCEPTION: $e');
      log('$stackTrace');

      _updateAgoraStatus('Initialization failed');

      if (mounted) {
        setState(() => _agoraConnecting = false);
      }
    }
  }

  Future<void> _leaveAgora() async {
    final engine = _engine;
    _engine = null;

    if (engine != null) {
      try {
        await engine.leaveChannel();
      } catch (e) {
        _log('[AGORA] Leave error: $e');
      }

      try {
        await engine.release();
      } catch (e) {
        _log('[AGORA] Release error: $e');
      }
    }

    if (mounted) {
      setState(() {
        _agoraConnecting = false;
        _agoraJoined = false;
        _agoraStatus = 'Disconnected';
      });
    }

    _log('[AGORA] Disconnected.');
  }

  @override
  void dispose() {
    _roomIdController.dispose();
    _uidController.dispose();
    _tokenController.dispose();

    final channel = _channel;
    final pusher = _pusher;

    try {
      channel?.unbind('Room');
      pusher?.unsubscribe(_roomChannel);
      pusher?.disconnect();
    } catch (_) {}

    final engine = _engine;
    if (engine != null) {
      unawaited(() async {
        try {
          await engine.leaveChannel();
        } catch (_) {}

        try {
          await engine.release();
        } catch (_) {}
      }());
    }

    super.dispose();
  }

  Widget _statusTile(String title, String status) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: SelectableText(status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Connection Diagnostics'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Test the backend room channel and Agora separately. '
            'This screen does not modify your production room logic.',
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _roomIdController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              labelText: 'Database Room ID',
              helperText: 'Example: 5 creates the Pusher channel Room5',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          _statusTile('Pusher channel', _roomChannel),
          _statusTile('Pusher connection', _pusherStatus),
          _statusTile('Pusher event', _subscriptionStatus),

          ElevatedButton(
            onPressed: _pusherConnecting ? null : _connectPusher,
            child: const Text('Subscribe to Room channel'),
          ),
          OutlinedButton(
            onPressed: _disconnectPusher,
            child: const Text('Disconnect Pusher'),
          ),

          const Divider(height: 32),

          const Text(
            'Agora',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _uidController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              labelText: 'Agora UID',
              helperText: 'Use the UID expected by the backend token',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // FIX: obscured TextFields must have maxLines: 1.
          // When visible, the token can use multiple lines.
          TextField(
            controller: _tokenController,
            minLines: _showToken ? 3 : 1,
            maxLines: _showToken ? 6 : 1,
            obscureText: !_showToken,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              labelText: 'Agora token from JoinRoom response',
              helperText: 'Kept out of diagnostic logs',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: _showToken ? 'Hide token' : 'Show token',
                icon: Icon(
                  _showToken ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _showToken = !_showToken);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Join as broadcaster'),
            subtitle: const Text(
              'Turn off to test as audience instead.',
            ),
            value: _isBroadcaster,
            onChanged: (value) {
              setState(() => _isBroadcaster = value);
            },
          ),

          _statusTile('Agora connection', _agoraStatus),

          ElevatedButton(
            onPressed:
                _agoraConnecting || _agoraJoined ? null : _joinAgora,
            child: const Text('Join Agora channel'),
          ),
          OutlinedButton(
            onPressed: _leaveAgora,
            child: const Text('Leave Agora channel'),
          ),

          const Divider(height: 32),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Diagnostic logs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _logs.clear());
                },
                child: const Text('Clear'),
              ),
            ],
          ),

          Container(
            constraints: const BoxConstraints(minHeight: 100),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SelectableText(
              _logs.isEmpty
                  ? 'No logs yet.'
                  : _logs.join('\n'),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
