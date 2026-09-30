//
// import 'dart:async';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// import 'package:ahlachat/util/app_constants.dart';
// import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// class NotificationViewmodel  {
//
//
//   getnotifitoken({context})async{
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print(message.data);
//       print(message.data);
//       print('Got a message whilst in the foreground!');
//       RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: false);
//       Room.Leaveroom(context:context);
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: false);
//       Room.Leaveroom(context:context);
//       // Navigator.pushNamed(
//       //   context,
//       //   '/message',
//       //   arguments: MessageArguments(message, true),
//       // );
//     });
//
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
//
//       print('resevedddddddddddddddddddddddd');
//     });
//     print(notifitoken);
//   }
//
// }