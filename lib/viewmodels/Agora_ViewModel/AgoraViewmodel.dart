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
  /// App ID on the Agora dashboard
  String APP_ID = '808fe19c64ec48868d2499f86c97457e';

  bool muted = true;
  bool KickedFromChair = false;

  RtcEngine? _engine;

  List usersuid = [];

  bool Rebeate = false;

  ChangeRepeate(state) {
    Rebeate = state;
    notifyListeners();
  }

  updateKickedFromChair({value}) {
    KickedFromChair = value;

    notifyListeners();
  }

  EndAgora() {
    muted = true;

    _stopAllSpeakingTracking();

    _engine?.leaveChannel();

    //_engine?.destroy();

    notifyListeners();
  }

  bool disableAudio = false;

  disableAudioroomvoice() {
    disableAudio = false;
    playmusic = false;
    PlaySong.clear();

    notifyListeners();
  }

  closeroomvoice() {
    _engine?.disableAudio();

    disableAudio = true;

    notifyListeners();
  }

  enableroomvoice() {
    _engine?.enableAudio();

    disableAudio = false;

    notifyListeners();
  }

  var initialValue = 0.0;

  Future<void> initialize({
    ClientRole? role,
    required Token,
    required channelName,
  }) async {
    await _initAgoraRtcEngine(Role: role);

    _addAgoraEventHandlers();

    await _engine?.joinChannel(
      token: Token,
      channelId: channelName,
      uid: int.parse(UserId!),
      options: const ChannelMediaOptions(),
    );

    notifyListeners();
  }

  Future<void> _initAgoraRtcEngine({Role}) async {
    _engine = createAgoraRtcEngine();

    await _engine?.initialize(
      RtcEngineContext(
        appId: APP_ID,
      ),
    );

    await _engine?.enableAudio();

    await _engine?.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );

    if (Role == ClientRole.Broadcaster) {
      await _engine?.adjustRecordingSignalVolume(400);

      muted = false;
    } else {
      muted = true;
    }

    /// Enable Agora audio volume indication + Voice Activity Detection.
    ///
    /// interval:
    /// Agora reports audio information every 250ms.
    ///
    /// smooth:
    /// Smooths the reported volume values.
    ///
    /// reportVad:
    /// Enables Voice Activity Detection.
    await _engine?.enableAudioVolumeIndication(
      interval: 250,
      smooth: 3,
      reportVad: true,
    );

    await _engine?.setClientRole(
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
      '⚠️ startAudioMixing failed: code=${e.code}, message=${e.message}',
    );
  } catch (e) {
    isAudioMixingActive = false;

    debugPrint(
      '⚠️ startAudioMixing unexpected error: $e',
    );
  }

  notifyListeners();
}

  next(context) async {
    MusicViewModel music = Provider.of<MusicViewModel>(
      context,
      listen: false,
    );

    //
    // if(music.SongsList.length==index+1){
    //   Dialogs().showtoast('لا يوجد اغاني اخري');
    // }else{
    //
    //   PlaySong.clear();
    //   playmusic=true;
    //   PlaySong.add(music.SongsList[index+1].title);
    //   await _engine?.startAudioMixing(music.SongsList[index+1].data, false, false, -1);
    //   music.play(music.SongsList[index+1].data);
    //   index=index+1;
    // }

    notifyListeners();
  }

  last(context) async {
    //
    // MusicViewModel music= Provider.of<MusicViewModel>(context,listen: false);
    // print(index+1);
    // print(music.SongsList.length);
    // if(music.SongsList.length==index-1){
    //   Dialogs().showtoast('لا يوجد اغاني اخري');
    // }else{
    //
    //   PlaySong.clear();
    //   playmusic=true;
    //   PlaySong.add(music.SongsList[index-1].title);
    //
    //   await _engine?.startAudioMixing(music.SongsList[index-1].data, false, false, -1);
    //   music.play(music.SongsList[index-1].data);
    //   index=index-1;
    // }

    // }

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

  //
Future<void> stopAudioMexing(context) async {
  playmusic = false;

  Provider.of<MusicViewModel>(
    context,
    listen: false,
  );

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
      '⚠️ pauseAudioMixing failed: code=${e.code}, message=${e.message}',
    );
  } catch (e) {
    debugPrint(
      '⚠️ pauseAudioMixing unexpected error: $e',
    );
  } finally {
    isAudioMixingActive = false;
  }

  notifyListeners();
}

Future<void> resumAudioMexing(context) async {
  Provider.of<MusicViewModel>(
    context,
    listen: false,
  );

  try {
    if (_engine != null) {
      await _engine!.resumeAudioMixing();
      isAudioMixingActive = true;
      playmusic = true;
    }
  } on AgoraRtcException catch (e) {
    debugPrint(
      '⚠️ resumeAudioMixing failed: code=${e.code}, message=${e.message}',
    );
  } catch (e) {
    debugPrint(
      '⚠️ resumeAudioMixing unexpected error: $e',
    );
  }

  notifyListeners();
}

Future<void> muteusermic(uid) async {
  try {
    if (_engine != null) {
      await _engine!.muteRemoteAudioStream(
        uid: uid,
        mute: true,
      );
    }
  } on AgoraRtcException catch (e) {
    debugPrint(
      '⚠️ muteRemoteAudioStream failed: code=${e.code}, message=${e.message}',
    );
  } catch (e) {
    debugPrint(
      '⚠️ muteRemoteAudioStream unexpected error: $e',
    );
  }

  notifyListeners();
}

Future<void> unmuteusermic(uid) async {
  try {
    if (_engine != null) {
      await _engine!.muteRemoteAudioStream(
        uid: uid,
        mute: false,
      );
    }
  } on AgoraRtcException catch (e) {
    debugPrint(
      '⚠️ unmuteRemoteAudioStream failed: code=${e.code}, message=${e.message}',
    );
  } catch (e) {
    debugPrint(
      '⚠️ unmuteRemoteAudioStream unexpected error: $e',
    );
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
      '⚠️ pauseAudioMixing failed: code=${e.code}, message=${e.message}',
    );
  } catch (e) {
    debugPrint(
      '⚠️ pauseAudioMixing unexpected error: $e',
    );
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

  mutebyuid({
    uid,
    context,
  }) async {
    RoomViewmodel Room = Provider.of<RoomViewmodel>(
      context,
      listen: false,
    );

    if (Room.Mutedids.contains(uid)) {
      Room.Mutedids.remove(uid);

      await _engine?.muteRemoteAudioStream(
        uid: uid,
        mute: false,
      );
    } else {
      Room.Mutedids.add(uid);

      await _engine?.muteRemoteAudioStream(
        uid: uid,
        mute: true,
      );
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
    // await _engine?.muteLocalAudioStream(true);

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

  /*
   * ============================================================
   * SPEAKING / VOICE ACTIVITY TRACKING
   * ============================================================
   */

  /// Users who are currently detected as speaking.
  ///
  /// Example:
  ///
  /// speakingUsers.contains(123)
  ///
  /// means Agora currently detects user 123 as speaking.
  final Set<int> speakingUsers = <int>{};

  /// The moment each user started speaking.
  ///
  /// uid -> start time
  final Map<int, DateTime> speakingStartedAt = <int, DateTime>{};

  /// Total accumulated speaking duration for each user.
  ///
  /// uid -> total duration
  final Map<int, Duration> speakingDuration = <int, Duration>{};

  /// Returns true if Agora currently detects this user as speaking.
  bool isUserSpeaking(int uid) {
    return speakingUsers.contains(uid);
  }

  /// Returns the total speaking duration for a user.
  ///
  /// If the user is currently speaking, the current active period
  /// is also included in the returned duration.
  Duration getUserSpeakingDuration(int uid) {
    Duration total = speakingDuration[uid] ?? Duration.zero;

    final startedAt = speakingStartedAt[uid];

    if (startedAt != null && speakingUsers.contains(uid)) {
      total += DateTime.now().difference(startedAt);
    }

    return total;
  }

  /// Returns the total speaking time in seconds.
  int getUserSpeakingSeconds(int uid) {
    return getUserSpeakingDuration(uid).inSeconds;
  }

  /// Called when a user starts speaking.
  void _handleUserStartedSpeaking(int uid) {
    if (uid == 0) {
      return;
    }

    /// Avoid starting the timer again every 250ms.
    if (speakingUsers.contains(uid)) {
      return;
    }

    speakingUsers.add(uid);

    speakingStartedAt[uid] = DateTime.now();

    print(
      '🎤 User $uid started speaking',
    );
  }

  /// Called when a user stops speaking.
  void _handleUserStoppedSpeaking(int uid) {
    if (uid == 0) {
      return;
    }

    if (!speakingUsers.contains(uid)) {
      return;
    }

    speakingUsers.remove(uid);

    final startedAt = speakingStartedAt.remove(uid);

    if (startedAt != null) {
      final duration = DateTime.now().difference(startedAt);

      speakingDuration[uid] =
          (speakingDuration[uid] ?? Duration.zero) + duration;

      print(
        '🔇 User $uid stopped speaking '
        'for ${duration.inSeconds}s '
        '(total: ${speakingDuration[uid]!.inSeconds}s)',
      );
    }
  }

  /// Completely removes speaking state for a user.
  void _clearUserSpeakingData(int uid) {
    speakingUsers.remove(uid);
    speakingStartedAt.remove(uid);
    speakingDuration.remove(uid);
  }

  /// Stop all current speaking tracking.
  ///
  /// This is useful when leaving the Agora channel.
  void _stopAllSpeakingTracking() {
    final currentSpeakingUsers = List<int>.from(
      speakingUsers,
    );

    for (final uid in currentSpeakingUsers) {
      _handleUserStoppedSpeaking(uid);
    }

    speakingUsers.clear();
    speakingStartedAt.clear();
  }

  /*
   * ============================================================
   * OLD USER LISTS
   * ============================================================
   */

  List UserIDS = [];

  /*
   * ============================================================
   * AGORA EVENT HANDLERS
   * ============================================================
   */

  void _addAgoraEventHandlers() {
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onError: (code, message) {
          print(
            'onError: $code $message',
          );
        },

        onJoinChannelSuccess: (connection, elapsed) {
          userjoindid = connection.localUid ?? 0;

          print(
            'Agora joined channel. '
            'Local UID: $userjoindid',
          );
        },

        onLeaveChannel: (connection, stats) {
          print(
            'onLeaveChannel '
            '::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::',
          );

          _stopAllSpeakingTracking();

          notifyListeners();
        },

        onUserJoined: (connection, uid, elapsed) {
          usersuid.add(uid);

          userjoin.add({
            'userid': userjoindid,
            'uid': uid,
          });

          print(
            '👤 User joined: $uid',
          );

          notifyListeners();
        },

        onUserOffline: (connection, uid, reason) {
          print(
            '👋 User offline: $uid',
          );

          /// If the user was speaking when they left,
          /// finalize their current speaking duration.
          if (speakingUsers.contains(uid)) {
            _handleUserStoppedSpeaking(uid);
          }

          /// Remove the user from the active users list.
          usersuid.remove(uid);

          /// Remove old userjoin records.
          userjoin.removeWhere(
            (item) => item['uid'] == uid,
          );

          notifyListeners();
        },

        onAudioVolumeIndication: (
  connection,
  volumeInfo,
  speakerNumber,
  totalVolume,
) {
  for (final speaker in volumeInfo) {
    final int uid = speaker.uid ?? 0;
    final int volume = speaker.volume ?? 0;
    final int vad = speaker.vad ?? 0;

    // Skip local user for now.
    if (uid == 0) {
      continue;
    }

    print(
      '🔊 Agora Audio '
      'uid=$uid '
      'volume=$volume '
      'vad=$vad',
    );

    if (vad == 1) {
      if (!speakingUsers.contains(uid)) {
        _handleUserStartedSpeaking(uid);

        print(
          '🎤🎤🎤 USER $uid IS SPEAKING 🎤🎤🎤',
        );

        notifyListeners();
      }
    } else {
      if (speakingUsers.contains(uid)) {
        _handleUserStoppedSpeaking(uid);

        print(
          '🔇🔇🔇 USER $uid STOPPED SPEAKING 🔇🔇🔇',
        );

        notifyListeners();
      }
    }
  }
},
      ),
    );
  }
}