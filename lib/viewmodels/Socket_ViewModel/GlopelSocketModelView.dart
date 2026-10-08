import 'dart:convert';
import 'dart:developer';

import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pusher_client/pusher_client.dart';

class GlopelViewmodel extends ChangeNotifier {
  PusherClient? pusher;
  Channel? channel;

  Future<void> ConnectGlopalScocket(context) async {
    print('========== GLOBAL PUSHER CONNECT ==========');
    print('PUSHER KEY: c131d267a74a0cbd3da9');
    print('PUSHER CLUSTER: mt1');
    print('PUSHER CHANNEL: Gigo');
    print('PUSHER EVENT: Gigo');
    print('===========================================');

    // Disconnect previous connection if one exists.
    try {
      pusher?.unsubscribe('Gigo');
      pusher?.disconnect();
    } catch (e) {
      print('OLD PUSHER DISCONNECT ERROR: $e');
    }

    pusher = PusherClient(
      'c131d267a74a0cbd3da9',
      PusherOptions(
        cluster: 'mt1',
        encrypted: true,
      ),
      enableLogging: true,
    );

    // Connection state listener
    pusher?.onConnectionStateChange((state) {
      print(
        '========== GLOBAL PUSHER STATE =========='
      );
      print('PREVIOUS: ${state?.previousState}');
      print('CURRENT:  ${state?.currentState}');
      print('=========================================');

      log(
        'Pusher state: '
        '${state?.previousState} -> ${state?.currentState}',
      );
    });

    // Connection error listener
    pusher?.onConnectionError((error) {
      print('========== GLOBAL PUSHER ERROR ==========');
      print('MESSAGE: ${error?.message}');
      print('CODE: ${error?.code}');
      print('=========================================');

      log('Pusher error: ${error?.message}');
    });

    // Connect
    print('GLOBAL PUSHER: connecting...');
    pusher?.connect();

    // Subscribe to global channel
    print('GLOBAL PUSHER: subscribing to Gigo...');
    channel = pusher?.subscribe('Gigo');

    // Bind Gigo event
    channel?.bind('Gigo', (e) {
      print('========== GLOBAL PUSHER EVENT ==========');
      print('EVENT: Gigo');
      print('RAW DATA: ${e?.data}');
      print('=========================================');

      try {
        final String rawData = e?.data ?? '';

        if (rawData.isEmpty) {
          print('GLOBAL PUSHER: event data is empty');
          return;
        }

        final Map<String, dynamic> decoded =
            jsonDecode(rawData) as Map<String, dynamic>;

        final dynamic state = decoded['state'];

        print('GLOBAL PUSHER EVENT STATE: $state');

        degisenMenu(
          data: decoded,
          state: state,
        );
      } catch (e, stackTrace) {
        print('========== GLOBAL PUSHER EVENT ERROR ==========');
        print('ERROR: $e');
        print('STACK TRACE:');
        print(stackTrace);
        print('===============================================');
      }
    });

    notifyListeners();
  }

  Future<void> DisConnect() async {
    print('========== GLOBAL PUSHER DISCONNECT ==========');

    try {
      channel?.unbind('Gigo');
      pusher?.unsubscribe('Gigo');
      pusher?.disconnect();

      channel = null;
      pusher = null;

      print('GLOBAL PUSHER: disconnected successfully');
    } catch (e, stackTrace) {
      print('GLOBAL PUSHER DISCONNECT ERROR: $e');
      print(stackTrace);
    }

    notifyListeners();
  }

  Future<void> degisenMenu({
    required dynamic data,
    required dynamic state,
    int? index,
  }) async {
    try {
      switch (state) {
        case 0:
          final usermodel sender =
              usermodel.fromJson(data['data']['Sender']);

          final usermodel Reciver =
              usermodel.fromJson(data['data']['Reciver']);

          final Gift giftinfo =
              Gift.fromJson(data['data']['gift']);

          Provider.of<GiftsViewModel>(
            roomcontext,
            listen: false,
          ).GitGlopalGiftData(
            reciver: Reciver,
            sender: sender,
            gift: giftinfo,
            Quantati: data['data']['Quantati'],
            Room_id: data['data']['Roomid'],
            state: 0,
            Roomname: data['data']['Room_name'],
          );

          break;

        case 1:
          final usermodel sender =
              usermodel.fromJson(data['data']['Sender']);

          final Gift giftinfo =
              Gift.fromJson(data['data']['gift']);

          Provider.of<GiftsViewModel>(
            roomcontext,
            listen: false,
          ).GitGlopalGiftData(
            reciver: sender,
            sender: sender,
            gift: giftinfo,
            Quantati: data['data']['Quantati'],
            Room_id: data['data']['Roomid'],
            state: 1,
            Roomname: data['data']['Room_name'],
          );

          break;

        case 2:
          final usermodel sender =
              usermodel.fromJson(data['data']['Sender']);

          final usermodel Reciver =
              usermodel.fromJson(data['data']['Reciver']);

          final Gift giftinfo =
              Gift.fromJson(data['data']['gift']);

          // Existing logic intentionally disabled.
          //
          // Provider.of<GiftsViewModel>(
          //   roomcontext,
          //   listen: false,
          // ).GitGlopalLuckyData(...);

          break;

        case 3:
          final usermodel user =
              usermodel.fromJson(data['data']['user']);

          final RoomModel Room =
              RoomModel.fromJson(data['data']['room']);

          Provider.of<GiftsViewModel>(
            roomcontext,
            listen: false,
          ).GitGlopalLuckyData(
            sender: user,
            Room: Room,
            Room_id: Room.id,
            state: 0,
            Roomname: Room.name,
          );

          final currentRoom =
              Provider.of<RoomViewmodel>(
                roomcontext,
                listen: false,
              ).Currentroom;

          if (Room.id == currentRoom?.id) {
            SmartDialog.showLoading(
              builder: (context) => Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Lottie.asset(
                  'assets/image/1844-timer.json',
                  repeat: false,
                  reverse: false,
                  frameRate: FrameRate.max,
                  animate: true,
                ),
              ),
            );
          }

          break;

        default:
          print(
            'GLOBAL PUSHER: Unknown state received: $state',
          );
      }
    } catch (e, stackTrace) {
      print('========== degisenMenu ERROR ==========');
      print('STATE: $state');
      print('ERROR: $e');
      print('STACK TRACE:');
      print(stackTrace);
      print('======================================');
    }
  }
}