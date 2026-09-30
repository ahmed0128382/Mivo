import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class RoomPlayViewModel extends ChangeNotifier{
  bool HasRoom = false;
  bool IsRoom = false;
  changeHasRoomstate(value){
    HasRoom=value;
    notifyListeners();
  }
  changeIsRoomstate(value){
    IsRoom=value;
    notifyListeners();
  }
}