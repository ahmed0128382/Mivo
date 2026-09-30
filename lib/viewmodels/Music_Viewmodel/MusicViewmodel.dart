import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ahlachat/util/styles.dart';

import 'package:just_audio/just_audio.dart';

import 'package:provider/provider.dart';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Repositores/Music_repositores/Musicapi.dart';
import '../Auth_Viewmodel/LoginViewModel.dart';
class DurationState{
  DurationState({this.position = Duration.zero, this.total = Duration.zero});
  Duration position, total;
}
 class MusicViewModel extends ChangeNotifier{
//   final OnAudioQuery  audioQuery = OnAudioQuery();
//   final AudioPlayer  player = AudioPlayer();
//   bool  playerorno = false;
//   List<SongModel> songs = [];
//   List<SongModel> SongsList=[];
//
//   List<SongModel>   searchResult=[];
//   List<SongModel>   SelectedMusic=[];
//   SelectMusic(SongModel val)async{
//     SongsList.add(val);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>?    Songs=  prefs.getStringList('Songs');
//     if(Songs!=null){
//       Songs.add(val.title);
//       prefs.setStringList('Songs',Songs);
//     }else{
//       prefs.setStringList('Songs',[val.title]);
//     }
//
//     notifyListeners();
//   }
//   UnSelectMusic(SongModel val)async{
//
//     SongsList.remove(val);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String>?    Songs=  prefs.getStringList('Songs');
//     if(Songs!=null){
//       Songs.remove(val.title);
//       prefs.setStringList('Songs',Songs);
//     }
//     notifyListeners();
//   }
// bool loading=false;
//   AddNewMusic({context}) async {
//
//     LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
//     loading=true;
//     notifyListeners();
//     await Musicapi().AddMusic(context: context,Music: SelectedMusic.first).then((value) {
//       loading=false;
// if(value.name!=null){
//   Dialogs().showtoast(getLang(context:NavigationService.navigatorKey.currentContext,key: "Done_Succ"));
//   SelectedMusic.clear();
//
//
// }
//       notifyListeners();
//     });
//     notifyListeners();
//   }
//   SelectMusicFile(value)async{
//     SelectedMusic.clear();
//     SelectedMusic.add(value);
//
//     notifyListeners();
//   }
//   addsongs(){
//     searchResult=SelectedMusic;
//     notifyListeners();
//   }
//   TextEditingController NameController=TextEditingController();
//
//   void  Filtercity(String enteredKeyword) {
//
//     print(enteredKeyword);
//     if (enteredKeyword.isEmpty) {
//
//         searchResult = SelectedMusic;
//
//       notifyListeners();
//     } else {
//
//        searchResult = SelectedMusic.where((user) => user.title.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
//       notifyListeners(); //
//     }
//   }
//   int index=0;
//   String currentSongTitle = '';
//   int currentIndex = 0;
//   var songslost;
//
// void pause(){
//   player.stop();
//   playerorno=false;
//   notifyListeners(); //
//
// }
//   void play(url){
//     AgoraViewmodel Agora=Provider.of<AgoraViewmodel>(roomcontext,listen: false);
//     MusicViewModel music= Provider.of<MusicViewModel>(roomcontext,listen: false);
//     player.pause();
//     player.setFilePath(url);
//   player.setVolume(0);
//     player.play();
//
//     player.playerStateStream.listen((event) async{
//
//       if(event.processingState==ProcessingState.completed){
//
//         if(Agora.Rebeate==false){
//
//
//           await Agora.StartAudioMexing(filePath:  SongsList[Agora.index].data,duration: SongsList[Agora.index].duration,tittle:  SongsList[Agora.index].title,indexsong: Agora.index);
//           notifyListeners(); //
//         }else{
//
//           await Agora.StartAudioMexing(filePath:  SongsList[Agora.index+1].data,duration: SongsList[Agora.index+1].duration,tittle:  SongsList[Agora.index+1].title,indexsong: Agora.index+1);
//           notifyListeners(); //
//          }
//
//       }
//     });
//
//     notifyListeners(); //
//
//   }
//
// var Crunnetdata;
//   setindex({value,data}){
//     Crunnetdata=data;
//     index=value;
//     notifyListeners();
//   }
//   Future<List<SongModel>>   GetAllMusic(){
//       var songslost= audioQuery.querySongs(
//         orderType: OrderType.ASC_OR_SMALLER,
//         uriType: UriType.EXTERNAL,
//         ignoreCase: true,sortType: SongSortType.TITLE
//     );
//
//     return songslost;
//   }
//
//
//
//   Stream<DurationState> get  durationStateStream =>
//       Rx.combineLatest2<Duration, Duration?, DurationState>(
//           player.positionStream,  player.durationStream, (position, duration) => DurationState(
//           position: position, total: duration?? Duration.zero
//       ));
//   void seekToSec(int sec) {
//     Duration newPos = Duration(seconds: sec);
//     player.seek(newPos);
//   }
//   Initsong()async{
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //prefs.remove('Songs');
//     List<String>? Songs=await prefs.getStringList('Songs');
//     // Songs?.add('1');
//     // prefs.setStringList('Songs',Songs!);
//     // List<String>? Songsss=await prefs.getStringList('Songs');
//    print(Songs);
//     print("SongsSongsSongsSongsSongsSongsSongsSongsSongsSongs");
//     player.currentIndexStream.listen((index) {
//       if(index != null){
//         _updateCurrentPlayingSongDetails(index);
//       }
//     });
//     GetAllMusic().then((value) {
//       SelectedMusic = value;
//
// if(Songs!=null){
//   SelectedMusic.forEach((element){
//     if(Songs.contains(element.title)){
//       SongsList.add(element);
//     }
//
//   });
// }
//
//
//      // SelectedMusic.removeWhere((element) => element.data.contains('AUD'));
//
//       notifyListeners(); //
//     });
//     notifyListeners(); //
//
//   }
//
//
//   void toast(BuildContext context, String text){
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(text),
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
//     ));
//   }
//
//   void requestStoragePermission() async {
//
//     if(!kIsWeb){
//       bool permissionStatus = await  audioQuery.permissionsStatus();
//       if(!permissionStatus){
//         await  audioQuery.permissionsRequest();
//       }
//
//
//     }
//     notifyListeners(); //
//
//   }
//
//   //create playlist
//   ConcatenatingAudioSource createPlaylist(List<SongModel> songs) {
//     List<AudioSource> sources = [];
//     for (var song in songs){
//       sources.add(AudioSource.uri(Uri.parse(song.uri!)));
//     }
//     return ConcatenatingAudioSource(children: sources);
//   }
//   // bg color
//   //Color bgColor = const Color(0XFF2A2A2A); //Colors.black;
//   Color bgColor = Colors.brown;
//
//   //define on audio plugin
//
//   BoxDecoration getDecoration(BoxShape shape, Offset offset, double blurRadius, double spreadRadius) {
//     return BoxDecoration(
//       color: bgColor,
//       shape: shape,
//       boxShadow: [
//         BoxShadow(
//           offset: -offset,
//           color: whitecolor4,
//           blurRadius: blurRadius,
//           spreadRadius: spreadRadius,
//         ),
//         BoxShadow(
//           offset: offset,
//           color: Colors.black,
//           blurRadius: blurRadius,
//           spreadRadius: spreadRadius,
//         )
//       ],
//     );
//   }
//
//   BoxDecoration getRectDecoration(BorderRadius borderRadius, Offset offset, double blurRadius, double spreadRadius) {
//     return BoxDecoration(
//       borderRadius: borderRadius,
//       color: bgColor,
//       boxShadow: [
//         BoxShadow(
//           offset: -offset,
//           color: whitecolor4,
//           blurRadius: blurRadius,
//           spreadRadius: spreadRadius,
//         ),
//         BoxShadow(
//           offset: offset,
//           color: Colors.black,
//           blurRadius: blurRadius,
//           spreadRadius: spreadRadius,
//         )
//       ],
//     );
//   }
//
//   //update playing song details
//   void _updateCurrentPlayingSongDetails(int index) {
//
//       if(SongsList.isNotEmpty){
//         currentSongTitle = SongsList[index].title;
//         currentIndex = index;
//       }
//       notifyListeners(); //
//
//   }


}