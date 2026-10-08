import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ahlachat/util/images.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class RoomWinComboOverlay extends StatelessWidget {
  final RoomViewmodel room;

  const RoomWinComboOverlay({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (room.Combowin.isNotEmpty)
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/image/ic_lucky_new_bg.png', height: 160),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'فوز',
                        style: TextStyle(color: Colors.yellow, fontSize: 25, height: 0),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(Images.coins, height: 18),
                          const SizedBox(width: 3),
                          Text(
                            room.Combowin.first['amount'].toString(),
                            style: style1.copyWith(fontSize: 22, color: Colors.yellow),
                          ),
                        ],
                      ),
                      Text(
                        ' تهانينك علي فوزك 0.${room.Combowin.first['persantage'].toString()} اضعاف العائد',
                        style: const TextStyle(color: Colors.white, fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (room.Combouser.isNotEmpty)
          Directionality(
            textDirection: TextDirection.ltr,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  room.Combouser.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: gradiant10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              room.Combouser[index]['image'] ?? "",
                            ),
                          ),
                          Text('ارسل', style: style1),
                          CachedNetworkImage(
                            imageUrl: room.Combouser[index]['imagegift'] ?? "",
                            width: 60,
                            height: 60,
                          ),
                          Text(
                            'X' + '${room.Combouser[index]['count']}',
                            style: style1.copyWith(fontSize: 25, color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}