import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

class RoomBackground extends StatelessWidget {
  final RoomViewmodel room;

  const RoomBackground({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: room.Currentroom?.animateimage ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => const SizedBox.expand(),
        errorWidget: (context, url, error) => const SizedBox.expand(),
      ),
    );
  }
}