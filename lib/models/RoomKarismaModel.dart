import 'package:ahlachat/models/Usermodel.dart';


class roomkarismamodel {
  int? userId;
  String? karisma;
  usermodel? user;

  roomkarismamodel({this.userId, this.karisma, this.user});

  roomkarismamodel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    karisma = json['karisma'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['karisma'] = this.karisma;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Roomkarismamodel {
  List<roomkarismamodel>? weeklysupporter;
  List<roomkarismamodel>? monthlysupporter;
  List<roomkarismamodel>? dailysupporter;

  Roomkarismamodel(
      {this.weeklysupporter, this.monthlysupporter, this.dailysupporter});

  Roomkarismamodel.fromJson(Map<String, dynamic> json) {
    if (json['weeklysupporter'] != null) {
      weeklysupporter = <roomkarismamodel>[];
      json['weeklysupporter'].forEach((v) {
        weeklysupporter!.add(new roomkarismamodel.fromJson(v));
      });
    }
    if (json['Monthlysupporter'] != null) {
      monthlysupporter = <roomkarismamodel>[];
      json['Monthlysupporter'].forEach((v) {
        monthlysupporter!.add(new roomkarismamodel.fromJson(v));
      });
    }
    if (json['dailysupporter'] != null) {
      dailysupporter = <roomkarismamodel>[];
      json['dailysupporter'].forEach((v) {
        dailysupporter!.add(new roomkarismamodel.fromJson(v));
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
