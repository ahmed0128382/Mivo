import 'package:ahlachat/models/AgencyModel.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/Usermodel.dart';

class Leaderboardusermodel {
  String? coins;
  int? userId;
  usermodel? user;

  Leaderboardusermodel({this.coins, this.userId, this.user});

  Leaderboardusermodel.fromJson(Map<String, dynamic> json) {
    coins = json['coins'];
    userId = json['user_id'];
    user = json['user'] != null ? new usermodel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins'] = this.coins;
    data['user_id'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class LeaderboardFamilymodel {
  String? coins;
  int? userId;
  FamilyModel? Family;

  LeaderboardFamilymodel({this.coins, this.userId, this.Family});

  LeaderboardFamilymodel.fromJson(Map<String, dynamic> json) {
    coins = json['coins'];
    userId = json['user_id'];
    Family = json['family'] != null ? new FamilyModel.fromJson(json['family']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins'] = this.coins;
    data['user_id'] = this.userId;
    if (this.Family != null) {
      data['family'] = this.Family!.toJson();
    }
    return data;
  }
}

class LeaderboardAgencymodel {
  String? coins;
  int? agencyid;
  Agencymodel? Agency;

  LeaderboardAgencymodel({this.coins, this.agencyid, this.Agency});

  LeaderboardAgencymodel.fromJson(Map<String, dynamic> json) {
    coins = json['coins'];
    agencyid = json['agency_id'];
    Agency = json['agency'] != null ? new Agencymodel.fromJson(json['agency']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coins'] = this.coins;
    data['agency_id'] = this.agencyid;
    if (this.Agency != null) {
      data['agency'] = this.Agency!.toJson();
    }
    return data;
  }
}

class AgencyLeaderBoard {
  List<LeaderboardAgencymodel>? supporter;
  List<LeaderboardAgencymodel>? supported;

  AgencyLeaderBoard({this.supporter, this.supported});

  AgencyLeaderBoard.fromJson(Map<String, dynamic> json) {
    if (json['Supporter'] != null) {
      supporter = <LeaderboardAgencymodel>[];
      json['Supporter'].forEach((v) {
        supporter!.add(new LeaderboardAgencymodel.fromJson(v));
      });
    }
    if (json['Supported'] != null) {
      supported = <LeaderboardAgencymodel>[];
      json['Supported'].forEach((v) {
        supported!.add(new LeaderboardAgencymodel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.supporter != null) {
      data['Supporter'] = this.supporter!.map((v) => v.toJson()).toList();
    }
    if (this.supported != null) {
      data['Supported'] = this.supported!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class ListoflEaderboardcategory {
  List<Leaderboardusermodel>? weeklysupporter;
  List<Leaderboardusermodel>? monthlysupporter;
  List<Leaderboardusermodel>? dailysupporter;

  ListoflEaderboardcategory(
      {this.weeklysupporter, this.monthlysupporter, this.dailysupporter});

  ListoflEaderboardcategory.fromJson(Map<String, dynamic> json) {
    if (json['weeklysupporter'] != null) {
      weeklysupporter = <Leaderboardusermodel>[];
      json['weeklysupporter'].forEach((v) {
        weeklysupporter!.add(new Leaderboardusermodel.fromJson(v));
      });
    }
    if (json['Monthlysupporter'] != null) {
      monthlysupporter = <Leaderboardusermodel>[];
      json['Monthlysupporter'].forEach((v) {
        monthlysupporter!.add(new Leaderboardusermodel.fromJson(v));
      });
    }
    if (json['dailysupporter'] != null) {
      dailysupporter = <Leaderboardusermodel>[];
      json['dailysupporter'].forEach((v) {
        dailysupporter!.add(new Leaderboardusermodel.fromJson(v));
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
class ListoflEaderboardFamilycategory {
  List<LeaderboardFamilymodel>? weeklysupporter;
  List<LeaderboardFamilymodel>? monthlysupporter;
  List<LeaderboardFamilymodel>? dailysupporter;

  ListoflEaderboardFamilycategory(
      {this.weeklysupporter, this.monthlysupporter, this.dailysupporter});

  ListoflEaderboardFamilycategory.fromJson(Map<String, dynamic> json) {
    if (json['weeklyFamily'] != null) {
      weeklysupporter = <LeaderboardFamilymodel>[];
      json['weeklyFamily'].forEach((v) {
        weeklysupporter!.add(new LeaderboardFamilymodel.fromJson(v));
      });
    }
    if (json['MonthlyFamily'] != null) {
      monthlysupporter = <LeaderboardFamilymodel>[];
      json['MonthlyFamily'].forEach((v) {
        monthlysupporter!.add(new LeaderboardFamilymodel.fromJson(v));
      });
    }
    if (json['dailyFamily'] != null) {
      dailysupporter = <LeaderboardFamilymodel>[];
      json['dailyFamily'].forEach((v) {
        dailysupporter!.add(new LeaderboardFamilymodel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.weeklysupporter != null) {
      data['weeklyFamily'] =
          this.weeklysupporter!.map((v) => v.toJson()).toList();
    }
    if (this.monthlysupporter != null) {
      data['Monthlysupporter'] =
          this.monthlysupporter!.map((v) => v.toJson()).toList();
    }
    if (this.dailysupporter != null) {
      data['dailyFamily'] =
          this.dailysupporter!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
