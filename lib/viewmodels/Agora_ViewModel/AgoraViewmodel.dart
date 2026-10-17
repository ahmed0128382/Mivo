
import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/app_constants.dart';
import '../Auth_Viewmodel/LoginViewModel.dart';
import '../Music_Viewmodel/MusicViewmodel.dart';
import '../Room_Viewmodel/Room_Viewmodel.dart';

enum ClientRole { Broadcaster, Audience }

class AgoraViewmodel extends ChangeNotifier {
  // Must match the App ID used to generate the backend Agora token.
  String APP_ID = '808fe19c64ec48868d2499f86c97457e';

  static const Duration _joinTimeoutDuration = Duration(seconds: 20);

  Timer? _joinTimeoutTimer;

  bool muted = true;
  bool KickedFromChair = false;

  RtcEngine? _engine;

  // Connection state.
  bool isInitializing = false;
  bool isJoining = false;
  bool isJoined = false;
  String? connectionError;

  List usersuid = [];
  bool Rebeate = false;

  void ChangeRepeate(state) {
    Rebeate = state;
    notifyListeners();
  }

  void updateKickedFromChair({value}) {
    KickedFromChair = value;
    notifyListeners();
  }

  void _cancelJoinTimeout() {
    _joinTimeoutTimer?.cancel();
    _joinTimeoutTimer = null;
  }

  void _startJoinTimeout() {
    _cancelJoinTimeout();

    _joinTimeoutTimer = Timer(_joinTimeoutDuration, () {
      // A callback may already have completed the connection attempt.
      if (isJoined || (!isInitializing && !isJoining)) {
        return;
      }

      debugPrint(
        '[AGORA][JOIN_TIMEOUT] No successful join callback after '
        '${_joinTimeoutDuration.inSeconds} seconds.',
      );

      isInitializing = false;
      isJoining = false;
      isJoined = false;
      connectionError =
          'Agora connection timed out. Check the token, App ID, channel and UID.';

      notifyListeners();

      // Stop a possibly incomplete SDK join attempt.
      unawaited(_leaveAfterJoinFailure());
    });
  }

  Future<void> _leaveAfterJoinFailure() async {
    try {
      await _engine?.leaveChannel();
    } catch (e) {
      debugPrint('[AGORA][CLEANUP_ERROR] $e');
    }
  }

  Future<void> EndAgora() async {
    _cancelJoinTimeout();

    muted = true;
    isInitializing = false;
    isJoining = false;
    isJoined = false;
    connectionError = null;

    _stopAllSpeakingTracking();

    try {
      await _engine?.leaveChannel();
    } catch (e) {
      debugPrint('[AGORA][LEAVE_ERROR] $e');
    }

    notifyListeners();
  }

  bool disableAudio = false;

  void disableAudioroomvoice() {
    disableAudio = false;
    playmusic = false;
    PlaySong.clear();
    notifyListeners();
  }

  void closeroomvoice() {
    _engine?.disableAudio();
    disableAudio = true;
    notifyListeners();
  }

  void enableroomvoice() {
    _engine?.enableAudio();
    disableAudio = false;
    notifyListeners();
  }

  var initialValue = 0.0;

  /// Initialize Agora and attempt to join the requested channel.
  ///
  /// The attempt has a timeout because joinChannel returning successfully
  /// does not mean that Agora has authenticated the token or joined the room.
  Future<void> initialize({
    ClientRole? role,
    required Token,
    required channelName,
  }) async {
    if (isInitializing || isJoining) {
      debugPrint(
        '[AGORA][JOIN] A connection attempt is already running.',
      );
      return;
    }

    final String token = Token?.toString().trim() ?? '';
    final String channel = channelName?.toString().trim() ?? '';
    final int? uid = int.tryParse(UserId?.toString() ?? '');

    if (APP_ID.trim().isEmpty) {
      connectionError = 'Agora App ID is missing.';
      debugPrint('[AGORA][CONFIG_ERROR] App ID is empty.');
      notifyListeners();
      return;
    }

    if (token.isEmpty) {
      connectionError = 'Agora token is empty.';
      debugPrint('[AGORA][CONFIG_ERROR] Token is empty.');
      notifyListeners();
      return;
    }

    if (channel.isEmpty) {
      connectionError = 'Agora channel name is empty.';
      debugPrint('[AGORA][CONFIG_ERROR] Channel name is empty.');
      notifyListeners();
      return;
    }

    if (uid == null || uid <= 0) {
      connectionError = 'Invalid local Agora UID.';
      debugPrint(
        '[AGORA][CONFIG_ERROR] Invalid UserId for Agora UID: $UserId',
      );
      notifyListeners();
      return;
    }

    isInitializing = true;
    isJoining = false;
    isJoined = false;
    connectionError = null;

    // Start the timeout before initialization, so a stalled SDK operation
    // cannot leave the app in a permanent connecting state.
    _startJoinTimeout();
    notifyListeners();

    try {
      await _initAgoraRtcEngine(Role: role);

      // Initialization might have timed out while awaiting the SDK.
      if (!isInitializing && !isJoining) {
        debugPrint(
          '[AGORA][JOIN] Initialization ended after the attempt was '
          'already cancelled or timed out.',
        );
        return;
      }

      _addAgoraEventHandlers();

      isInitializing = false;
      isJoining = true;
      notifyListeners();

      debugPrint(
        '[AGORA][JOIN_ATTEMPT] '
        'appId=$APP_ID channel=$channel uid=$uid '
        'role=${role ?? ClientRole.Audience}',
      );

      await _engine!.joinChannel(
        token: token,
        channelId: channel,
        uid: uid,
        options: const ChannelMediaOptions(),
      );

      // Do not mark joined here. The actual result comes from
      // onJoinChannelSuccess or onError.
    } on AgoraRtcException catch (e) {
      _cancelJoinTimeout();

      isInitializing = false;
      isJoining = false;
      isJoined = false;
      connectionError = 'Agora error ${e.code}: ${e.message}';

      debugPrint(
        '[AGORA][JOIN_EXCEPTION] '
        'code=${e.code} message=${e.message}',
      );

      notifyListeners();
    } catch (e, stackTrace) {
      _cancelJoinTimeout();

      isInitializing = false;
      isJoining = false;
      isJoined = false;
      connectionError = 'Unable to connect to the audio channel.';

      debugPrint('[AGORA][JOIN_EXCEPTION] $e');
      debugPrint('$stackTrace');

      notifyListeners();
    }
  }

  Future<void> _initAgoraRtcEngine({Role}) async {
    _engine = createAgoraRtcEngine();

    await _engine!.initialize(
      RtcEngineContext(appId: APP_ID),
    );

    await _engine!.enableAudio();

    await _engine!.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );

    if (Role == ClientRole.Broadcaster) {
      await _engine!.adjustRecordingSignalVolume(400);
      muted = false;
    } else {
      muted = true;
    }

    await _engine!.enableAudioVolumeIndication(
      interval: 250,
      smooth: 3,
      reportVad: true,
    );

    await _engine!.setClientRole(
      role: Role == ClientRole.Broadcaster
          ? ClientRoleType.clientRoleBroadcaster
          : ClientRoleType.clientRoleAudience,
    );

    notifyListeners();
  }

  bool playmusic = false;
  bool isAudioMixingActive = false;
  List PlaySong = [];

  int index = 0;

  Future<void> StartAudioMexing({
    required filePath,
    required duration,
    required tittle,
    required indexsong,
  }) async {
    PlaySong.clear();
    playmusic = true;
    index = indexsong;
    PlaySong.add(tittle);

    try {
      if (_engine != null) {
        await _engine!.startAudioMixing(
          filePath: filePath,
          loopback: false,
          cycle: -1,
        );
        isAudioMixingActive = true;
      }
    } on AgoraRtcException catch (e) {
      isAudioMixingActive = false;
      debugPrint(
        '[AUDIO_MIXING] Start failed: code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      isAudioMixingActive = false;
      debugPrint('[AUDIO_MIXING] Unexpected start error: $e');
    }

    notifyListeners();
  }

  next(context) async {
    Provider.of<MusicViewModel>(context, listen: false);
    notifyListeners();
  }

  last(context) async {
    notifyListeners();
  }

  int volumnaudio = 50;

  setaudiovolum(int volum) {
    volumnaudio = volum;
    _engine?.adjustAudioMixingVolume(volum);
  }

  volumnausdio(int volum) {
    volumnaudio = volum;
    notifyListeners();
  }

  Future<void> stopAudioMexing(context) async {
    playmusic = false;

    Provider.of<MusicViewModel>(context, listen: false);

    if (!isAudioMixingActive) {
      notifyListeners();
      return;
    }

    try {
      if (_engine != null) {
        await _engine!.pauseAudioMixing();
      }
    } on AgoraRtcException catch (e) {
      debugPrint(
        '[AUDIO_MIXING] Pause failed: code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      debugPrint('[AUDIO_MIXING] Unexpected pause error: $e');
    } finally {
      isAudioMixingActive = false;
    }

    notifyListeners();
  }

  Future<void> resumAudioMexing(context) async {
    Provider.of<MusicViewModel>(context, listen: false);

    try {
      if (_engine != null) {
        await _engine!.resumeAudioMixing();
        isAudioMixingActive = true;
        playmusic = true;
      }
    } on AgoraRtcException catch (e) {
      debugPrint(
        '[AUDIO_MIXING] Resume failed: code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      debugPrint('[AUDIO_MIXING] Unexpected resume error: $e');
    }

    notifyListeners();
  }

  Future<void> pauseAudioMixing() async {
    try {
      if (_engine != null) {
        await _engine!.pauseAudioMixing();
      }
    } on AgoraRtcException catch (e) {
      debugPrint(
        '[AUDIO_MIXING] Pause failed: code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      debugPrint('[AUDIO_MIXING] Unexpected pause error: $e');
    }

    notifyListeners();
  }

  resumeAudioMixing() async {
    await _engine?.resumeAudioMixing();
    notifyListeners();
  }

  setAudioMixingPosition(int duration) async {
    await _engine?.setAudioMixingPosition(duration);
    notifyListeners();
  }

  Future<void> muteusermic(uid) async {
    try {
      if (_engine != null) {
        await _engine!.muteRemoteAudioStream(uid: uid, mute: true);
      }
    } on AgoraRtcException catch (e) {
      debugPrint(
        '[AUDIO] Mute remote failed: code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      debugPrint('[AUDIO] Unexpected mute error: $e');
    }

    notifyListeners();
  }

  Future<void> unmuteusermic(uid) async {
    try {
      if (_engine != null) {
        await _engine!.muteRemoteAudioStream(uid: uid, mute: false);
      }
    } on AgoraRtcException catch (e) {
      debugPrint(
        '[AUDIO] Unmute remote failed: code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      debugPrint('[AUDIO] Unexpected unmute error: $e');
    }

    notifyListeners();
  }

  mutebyuid({uid, context}) async {
    RoomViewmodel Room = Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    if (Room.Mutedids.contains(uid)) {
      Room.Mutedids.remove(uid);
      await _engine?.muteRemoteAudioStream(uid: uid, mute: false);
    } else {
      Room.Mutedids.add(uid);
      await _engine?.muteRemoteAudioStream(uid: uid, mute: true);
    }

    notifyListeners();
  }

  SetasBroadcaster() async {
    muted = false;
    notifyListeners();

    await _engine?.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );
    await _engine?.adjustRecordingSignalVolume(400);
  }

  SetasAudience() async {
    muted = true;
    notifyListeners();

    await _engine?.setClientRole(
      role: ClientRoleType.clientRoleAudience,
    );
  }

  void Mute() async {
    muted = true;
    await _engine?.adjustRecordingSignalVolume(0);
    notifyListeners();
  }

  void UnMute() async {
    muted = false;
    SetasBroadcaster();
    await _engine?.adjustRecordingSignalVolume(400);
    notifyListeners();
  }

  keickedfromasAudience() async {
    muted = true;
    JoinChairs = false;
    KickedFromChair = false;

    await _engine?.setClientRole(
      role: ClientRoleType.clientRoleAudience,
    );

    notifyListeners();
  }

  int userjoindid = 0;
  List<Map> userjoin = [];
  int speakeruid = 0;

  // ============================================================
  // SPEAKING / VOICE ACTIVITY TRACKING
  // ============================================================

  final Set<int> speakingUsers = <int>{};

  final Map<int, DateTime> speakingStartedAt = <int, DateTime>{};
  final Map<int, Duration> speakingDuration = <int, Duration>{};
  final Map<int, DateTime> _lastSpeakingSignalAt = <int, DateTime>{};

  static const int _speakingVolumeThreshold = 10;
  static const Duration _speakingSilenceGrace =
      Duration(milliseconds: 900);

  int? get _localAppUserId {
    return int.tryParse(UserId?.toString() ?? '');
  }

  bool isUserSpeaking(int uid) => speakingUsers.contains(uid);

  Duration getUserSpeakingDuration(int uid) {
    Duration total = speakingDuration[uid] ?? Duration.zero;
    final startedAt = speakingStartedAt[uid];

    if (startedAt != null && speakingUsers.contains(uid)) {
      total += DateTime.now().difference(startedAt);
    }

    return total;
  }

  int getUserSpeakingSeconds(int uid) {
    return getUserSpeakingDuration(uid).inSeconds;
  }

  void _handleUserStartedSpeaking(
    int uid, {
    required int volume,
    required int vad,
  }) {
    if (speakingUsers.contains(uid)) return;

    speakingUsers.add(uid);
    speakingStartedAt[uid] = DateTime.now();

    debugPrint(
      '[SPEAKING][START] uid=$uid volume=$volume vad=$vad',
    );

    notifyListeners();
  }

  void _handleUserStoppedSpeaking(int uid) {
    if (!speakingUsers.contains(uid)) return;

    speakingUsers.remove(uid);
    _lastSpeakingSignalAt.remove(uid);

    final startedAt = speakingStartedAt.remove(uid);

    if (startedAt != null) {
      final duration = DateTime.now().difference(startedAt);
      speakingDuration[uid] =
          (speakingDuration[uid] ?? Duration.zero) + duration;

      debugPrint(
        '[SPEAKING][STOP] uid=$uid '
        'session=${duration.inSeconds}s '
        'total=${speakingDuration[uid]!.inSeconds}s',
      );
    }

    notifyListeners();
  }

  void _clearUserSpeakingData(int uid) {
    speakingUsers.remove(uid);
    speakingStartedAt.remove(uid);
    speakingDuration.remove(uid);
    _lastSpeakingSignalAt.remove(uid);
  }

  void _stopAllSpeakingTracking() {
  final now = DateTime.now();

  // Preserve completed speaking durations without notifying listeners
  // repeatedly while cleaning up one connection failure.
  for (final uid in List<int>.from(speakingUsers)) {
    final startedAt = speakingStartedAt[uid];

    if (startedAt != null) {
      final duration = now.difference(startedAt);
      speakingDuration[uid] =
          (speakingDuration[uid] ?? Duration.zero) + duration;
    }
  }

  speakingUsers.clear();
  speakingStartedAt.clear();
  _lastSpeakingSignalAt.clear();
}

  List UserIDS = [];

  // ============================================================
  // AGORA EVENT HANDLERS
  // ============================================================

  void _addAgoraEventHandlers() {
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onError: (code, message) {
  debugPrint('[AGORA][ERROR] code=$code message=$message');

  final bool connectionWasPending =
      isInitializing || isJoining;

  connectionError = 'Agora error: $code';

  if (connectionWasPending ||
      code == ErrorCodeType.errInvalidToken) {
    _cancelJoinTimeout();

    isInitializing = false;
    isJoining = false;
    isJoined = false;

    _stopAllSpeakingTracking();

    if (code == ErrorCodeType.errInvalidToken) {
      connectionError =
          'Agora rejected the token. Check the backend token, App ID, channel and UID.';
    }

    debugPrint(
      '[AGORA][JOIN_FAILED] '
      'initializing=$isInitializing joining=$isJoining '
      'joined=$isJoined error=$connectionError',
    );
  }

  notifyListeners();
},

        onJoinChannelSuccess: (connection, elapsed) {
          _cancelJoinTimeout();

          userjoindid = connection.localUid ?? 0;

          isInitializing = false;
          isJoining = false;
          isJoined = true;
          connectionError = null;

          debugPrint(
            '[AGORA][JOIN] Channel joined; '
            'localAgoraUid=$userjoindid '
            'appUserId=${_localAppUserId ?? "unknown"} '
            'elapsed=${elapsed}ms',
          );

          notifyListeners();
        },

        onLeaveChannel: (connection, stats) {
          _cancelJoinTimeout();

          debugPrint(
            '[AGORA][LEAVE] Left channel; clearing speaking state.',
          );

          isInitializing = false;
          isJoining = false;
          isJoined = false;
          _stopAllSpeakingTracking();

          notifyListeners();
        },

        onUserJoined: (connection, uid, elapsed) {
          if (!usersuid.contains(uid)) {
            usersuid.add(uid);
          }

          userjoin.removeWhere((item) => item['uid'] == uid);
          userjoin.add({
            'userid': userjoindid,
            'uid': uid,
          });

          debugPrint(
            '[AGORA][USER_JOINED] uid=$uid elapsed=${elapsed}ms',
          );
          notifyListeners();
        },

        onUserOffline: (connection, uid, reason) {
          debugPrint(
            '[AGORA][USER_OFFLINE] uid=$uid reason=$reason',
          );

          _handleUserStoppedSpeaking(uid);
          _clearUserSpeakingData(uid);

          usersuid.remove(uid);
          userjoin.removeWhere((item) => item['uid'] == uid);

          notifyListeners();
        },

       onAudioVolumeIndication: (
  connection,
  volumeInfo,
  speakerNumber,
  totalVolume,
) {
  // A failed or disconnected Agora session must never keep a speaking
  // indicator alive.
  if (!isJoined || connectionError != null) {
    if (speakingUsers.isNotEmpty) {
      _stopAllSpeakingTracking();
      notifyListeners();
    }
    return;
  }

  final now = DateTime.now();

  for (final speaker in volumeInfo) {
    final int reportedUid = speaker.uid ?? 0;
    final int volume = speaker.volume ?? 0;
    final int vad = speaker.vad ?? 0;

    // Agora uses UID 0 for the local speaker.
    final int? uid =
        reportedUid == 0 ? _localAppUserId : reportedUid;

    if (uid == null) continue;

    // Require both a voice-activity indication and meaningful volume.
    // Admin status alone never activates the speaking animation.
    final bool active =
        vad == 1 && volume >= _speakingVolumeThreshold;

    if (active) {
      _lastSpeakingSignalAt[uid] = now;

      if (!speakingUsers.contains(uid)) {
        _handleUserStartedSpeaking(
          uid,
          volume: volume,
          vad: vad,
        );
      }
    }
  }

  // A participant stops glowing when fresh voice activity stops arriving.
  final expiredUsers = speakingUsers.where((uid) {
    final lastSignal = _lastSpeakingSignalAt[uid];

    return lastSignal == null ||
        now.difference(lastSignal) > _speakingSilenceGrace;
  }).toList();

  for (final uid in expiredUsers) {
    _handleUserStoppedSpeaking(uid);
  }
},
      ),
    );
  }

  @override
  void dispose() {
    _cancelJoinTimeout();
    super.dispose();
  }
}
