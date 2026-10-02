
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

class AgoraViewmodel extends ChangeNotifier{
  /// App ID on the Agora dashboard
  String APP_ID = '1fa18aa462fd4d28a420c248fa789386';
  bool muted = true;
  bool KickedFromChair=false;
  RtcEngine? _engine;
  List usersuid=[];
bool Rebeate=false;
ChangeRepeate(state){
  Rebeate=state;
  notifyListeners();
}
  updateKickedFromChair({value}){
    KickedFromChair=value;

    notifyListeners();
  }


  EndAgora(){
    muted=true;
    _engine?.leaveChannel();
    //_engine?.destroy();
    notifyListeners();
  }
  bool disableAudio=false;
  disableAudioroomvoice(){
    disableAudio=false;
    playmusic=false;
    PlaySong.clear();
    notifyListeners();
  }
  closeroomvoice(){
    _engine?.disableAudio();
    disableAudio=true;
       notifyListeners();
  }
  enableroomvoice(){
    _engine?.enableAudio();
    disableAudio=false;
    notifyListeners();
  }

  var initialValue=0.0;
  Future<void> initialize({ClientRole? role,required Token,required channelName}) async {
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
    await _engine?.initialize(RtcEngineContext(appId: APP_ID));


    await _engine?.enableAudio();
    await _engine?.setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    if(Role==ClientRole.Broadcaster){
      await _engine?. adjustRecordingSignalVolume(400);
        muted=false;
    }else{
        muted=true;
    }
    await _engine?.enableAudioVolumeIndication(interval: 250, smooth: 3, reportVad: true);

    await _engine?.setClientRole(
      role: Role == ClientRole.Broadcaster
          ? ClientRoleType.clientRoleBroadcaster
          : ClientRoleType.clientRoleAudience,
    );

    notifyListeners();
  }
bool playmusic=false;
List PlaySong=[];
int index=0;
  StartAudioMexing({required filePath,required duration,required tittle,required indexsong})async{
    PlaySong.clear();
    playmusic=true;
    index=indexsong;
    PlaySong.add(tittle);
    await _engine?.startAudioMixing(filePath: filePath, loopback: false, cycle: -1);
    notifyListeners();
  }

  next(context)async{
    MusicViewModel music= Provider.of<MusicViewModel>(context,listen: false);

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
  last(context)async{
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
int volumnaudio=50;
  setaudiovolum(int volum) {
    volumnaudio=volum;
      _engine?.adjustAudioMixingVolume(volum);

  }
  volumnausdio(int volum) {
    volumnaudio=volum;

    notifyListeners();
  }

  //
  stopAudioMexing( context)async{
    playmusic=false;
    MusicViewModel music= Provider.of<MusicViewModel>(context,listen: false);

    await _engine?.pauseAudioMixing();
  //  music.player.pause();
    notifyListeners();
  }
  resumAudioMexing( context)async{
    MusicViewModel music= Provider.of<MusicViewModel>(context,listen: false);

    playmusic=true;
    await _engine?.resumeAudioMixing();
   // music.player.play();
    notifyListeners();
  }


  muteusermic(uid)async{
    await _engine?.muteRemoteAudioStream(uid: uid, mute: true);
    notifyListeners();
  }
  unmuteusermic(uid)async{
    await _engine?.muteRemoteAudioStream(uid: uid, mute: false);
    notifyListeners();
  }




  pauseAudioMixing()async{
    await _engine?.pauseAudioMixing();
    notifyListeners();
  }
  resumeAudioMixing()async{
    await _engine?.resumeAudioMixing();
    notifyListeners();
  }
  setAudioMixingPosition(int duration)async{
    await _engine?.setAudioMixingPosition(duration);
    notifyListeners();
  }
  mutebyuid({uid, context})async{

    RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: false);
   if(Room.Mutedids.contains(uid)){
     Room.Mutedids.remove(uid);
     await _engine?.muteRemoteAudioStream(uid: uid, mute: false);
   }else{
     Room.Mutedids.add(uid);
     await _engine?.muteRemoteAudioStream(uid: uid, mute: true);
   }


    notifyListeners();
  }
  SetasBroadcaster()async{
    muted=false;
    notifyListeners();
    await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine?. adjustRecordingSignalVolume(400);
  }
  SetasAudience()async{
    // await _engine?.muteLocalAudioStream(true);

    muted=true;
    notifyListeners();
   await _engine?.setClientRole(role: ClientRoleType.clientRoleAudience);
  }

  void Mute()async{

    muted=true;

    await _engine?. adjustRecordingSignalVolume(0);
    notifyListeners();
  }
  void UnMute()async{

    muted=false;
   SetasBroadcaster();
    await _engine?. adjustRecordingSignalVolume(400);
    notifyListeners();
  }
  keickedfromasAudience()async{
    muted=true;
    JoinChairs=false;
    KickedFromChair=false;
    await _engine?.setClientRole(role: ClientRoleType.clientRoleAudience);
    notifyListeners();
  }
  int userjoindid=0;
  List<Map> userjoin=[];
  int speakeruid=0;
  List speakerids=[];
  List UserIDS=[];

   void _addAgoraEventHandlers() {
    _engine?.registerEventHandler(RtcEngineEventHandler(
      onError: (code, message) {print('onError: $code $message');},
      onJoinChannelSuccess: (connection, elapsed) {
        userjoindid=connection.localUid ?? 0;

      },
      onLeaveChannel: (connection, stats) {
        print('onLeaveChannel :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: ');
      },
      onUserJoined: (connection, uid, elapsed) {
        usersuid.add(uid);
        userjoin.add({'userid':userjoindid,'uid':uid});

        }, onAudioVolumeIndication: (connection, volumeInfo, speakerNumber, totalVolume) {

      volumeInfo.forEach((speaker) {

    if ((speaker.volume ?? 0) >70){

      if(speaker.uid!=0){
        speakerids.add({'uid':speaker.uid,'time': DateTime.now()});
      }
      Timer.periodic(const Duration(seconds:1,), (timer) {
        for (var i in speakerids){
          if(DateTime.now().difference(i['time']).inSeconds>3){
              speakerids.remove(i) ;
              notifyListeners();
              break;
          }
        }
      });
    }

    });}
    ));
  }
}
