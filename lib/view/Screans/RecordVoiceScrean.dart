
import 'dart:io';

import 'package:ahlachat/util/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
class RecordVoiceScrean extends StatefulWidget {
  const RecordVoiceScrean({Key? key}) : super(key: key);

  @override
  State<RecordVoiceScrean> createState() => _RecordVoiceScreanState();
}

class _RecordVoiceScreanState extends State<RecordVoiceScrean> {
  final Recorder=FlutterSoundRecorder();
  final AudioPlayer  player = AudioPlayer();
  bool record=false;
  Future startrecord()async{
    record=true;
    setState(() {

    });
    await Recorder.startRecorder(toFile: 'audio');
  }
  Future stoprecord()async{
    record=false;
    setState(() {

    });
final path=    await Recorder.stopRecorder();
final asd=File(path!);
print('Path is asd$asd');
    player.setFilePath(asd.path) ;
    player.play();
  }

  Future RecordPermission()async{
final status=await Permission.microphone.request();
if(status!=PermissionStatus.granted){
  print('NotACCEW[T');

}
await Recorder.openRecorder();
  }
  @override
  void initState() {
    RecordPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(height: SizeConfig.screenHeight,width: SizeConfig.screenWidth,child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(!record?Colors.blue:Colors.red) ),onPressed: () {
             if(!record){
               startrecord();
             }else{
               stoprecord();
             }
           }, child:Icon(record?Icons.stop:Icons.mic)),
           InkWell(onTap: () {

           },child: Container(width: 100,height: 50,color: Colors.blue,))

         ],

       )),
    );
  }
}
