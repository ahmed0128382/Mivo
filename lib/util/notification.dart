import 'package:ahlachat/view/Screans/MainScreans/MessageScrean/MessageScrean.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../main.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();
  // dasd(){
  //   print('sssssssssssssssssssssssssssss  ');
  //
  //   _localNotificationService.getNotificationAppLaunchDetails().then((v){
  //     print(v!.payload);
  //     print('cccccccccccccccccccccccccccccccccc  ');
  //   });
  // }
  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@drawable/background');


    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,

    );

    await _localNotificationService.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if(payload=='1'){
          Provider.of<InboxroomViewModel>(NavigationService.navigatorKey.currentContext!,listen: false).GetInboxroom(context: NavigationService.navigatorKey.currentContext);
          showModalBottomSheet(backgroundColor: Colors.white,isScrollControlled: false, barrierColor:Colors.black.withAlpha(1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30), )),
            context: NavigationService.navigatorKey.currentContext!,
            builder: (context) {
              return  MessageScrean();
            },
          );
        }else
          if(payload=='2'){

        }
      }

    );
  }
  void onSelectNotification(String? payload)async {

    print('payloadpayloadpayloadpayloadpayloadpayloadpayloadpayloadpayloadpayload  ');
    print('payload $payload');
    // if (payload != null && payload.isNotEmpty) {
    //   onNotificationClick.add(payload);
    // }
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('channel_id', 'channel_name',
        channelDescription: 'description',
        importance: Importance.max,
        priority: Priority.max,
        playSound: true);



    return const NotificationDetails(
      android: androidNotificationDetails,

    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,payload:id.toString());
  }

  Future<void> showScheduledNotification(
      {required int id,
        required String title,
        required String body,
        required int seconds}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showNotificationWithPayload(
      {required int id,
        required String title,
        required String body,
        required String payload}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }


}
