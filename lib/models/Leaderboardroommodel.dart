import 'package:ahlachat/models/RoomModel.dart';

class LeaderboardRoommodel {
  String? coins;
  int? roomId;
  RoomModel? room;

  LeaderboardRoommodel({this.coins, this.roomId, this.room});

  LeaderboardRoommodel.fromJson(Map<String, dynamic> json) {
    coins = json['coins'];
    roomId = json['room_id'];
    room = json['room'] != null ? new RoomModel.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins'] = this.coins;
    data['room_id'] = this.roomId;
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    return data;
  }
}
class ListoflEaderboardcategoryRoom {
  List<LeaderboardRoommodel>? weeklysupporter;
  List<LeaderboardRoommodel>? monthlysupporter;
  List<LeaderboardRoommodel>? dailysupporter;

  ListoflEaderboardcategoryRoom(
      {this.weeklysupporter, this.monthlysupporter, this.dailysupporter});

  ListoflEaderboardcategoryRoom.fromJson(Map<String, dynamic> json) {
    if (json['weeklysupporter'] != null) {
      weeklysupporter = <LeaderboardRoommodel>[];
      json['weeklysupporter'].forEach((v) {
        weeklysupporter!.add(new LeaderboardRoommodel.fromJson(v));
      });
    }
    if (json['Monthlysupporter'] != null) {
      monthlysupporter = <LeaderboardRoommodel>[];
      json['Monthlysupporter'].forEach((v) {
        monthlysupporter!.add(new LeaderboardRoommodel.fromJson(v));
      });
    }
    if (json['dailysupporter'] != null) {
      dailysupporter = <LeaderboardRoommodel>[];
      json['dailysupporter'].forEach((v) {
        dailysupporter!.add(new LeaderboardRoommodel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.weeklysupporter != null) {
      data['weeklysupporter'] =
          this.weeklysupporter!.map((v) => v.toJson()).toList();
    }
    if (this.monthlysupporter != null) {
      data['Monthlysupporter'] =
          this.monthlysupporter!.map((v) => v.toJson()).toList();
    }
    if (this.dailysupporter != null) {
      data['dailysupporter'] =
          this.dailysupporter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}