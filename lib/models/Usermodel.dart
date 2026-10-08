import 'package:ahlachat/models/AgencyModel.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/FamilyRequestModel.dart';
import 'package:ahlachat/models/JoinRoomModel.dart';
import 'package:ahlachat/models/MyVip.dart';
import 'package:ahlachat/models/PostsModel.dart';
import 'package:ahlachat/models/RelationModel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/StartBannerModel.dart';
import 'package:ahlachat/models/UsarImages.dart';
import 'package:ahlachat/models/UserModels.dart';
import 'package:ahlachat/models/gifts.dart';
import 'package:ahlachat/util/app_constants.dart';

class usermodel {
  int? id;

  String? image;
  String? frameimage;
  String? SuporrtedImage;
  String? Enterbubles;
  String? entry;
  String? phoneNumber;

  int? Hidden;
  int? MessageNumber = 0;

  String? name;
  String? year;

  var Newid;
  var ColoredMessage;
  var bubbles;

  String? day;
  String? month;
  String? social;
  String? city;
  String? email;
  String? socialToken;
  String? notifiToken;
  String? rememperToken;
  String? ginder;
  String? description;

  int? coins;
  int? Karisma = 0;
  int? Input;
  int? ChairKarisma = 0;
  int? followers;
  int? following;
  int? friends;
  int? FriendState;
  int? visitors = 0;
  int? Level = 0;
  int? AgencyId = 0;
  int? AgencyKarisma = 0;

  String? faceBook;
  String? instgram;
  String? myappid;

  var password;

  String? createdAt;
  String? updatedAt;

  List<Gifts>? giftssent = [];
  List<Gifts>? giftscollect = [];

  List<String>? followIds = [];
  List<int>? joinsrequested = [];

  List<Postes>? Postuser;

  String? Flag;

  MyVipmodel? MyVip;

  RoomModel? currentroom;
  RoomModel? MyRoom;

  var music;

  Agencymodel? agency;

  joinRoom? CurrentRoom;

  int? FamilyKarisma;

  var FamilyId;
  var FamilyModels;
  var FamilyAdmin;

  List<int>? FamilyRequests = [];

  FamilyModel? MyFamil;

  List<UserModels>? Models = [];
  List<RelationModel>? Relations = [];
  List<UserImages>? ProfileImages = [];

  int? ginput = 0;

  int? Official = 0;
  int? Admin = 0;
  int? SuperAdmin = 0;
  int? MemberAgency = 0;

  int? Announcer = 0;
  int? DB = 0;
  int? MoneyAgency = 0;
  int? CustomersService = 0;
  int? Supporter = 0;

  StartBannerModel? StarterBanner;

  int? ban = 0;

  usermodel({
    this.id,
    this.ban,
    this.Announcer,
    this.DB,
    this.Official,
    this.Admin,
    this.SuperAdmin,
    this.Models,
    this.ProfileImages,
    this.MemberAgency,
    this.MoneyAgency,
    this.Supporter,
    this.CustomersService,
    this.FamilyKarisma,
    this.FamilyAdmin,
    this.StarterBanner,
    this.FamilyId,
    this.Relations,
    this.FamilyRequests,
    this.MyFamil,
    this.FamilyModels,
    this.MyRoom,
    this.Flag,
    this.image,
    this.Postuser,
    this.phoneNumber,
    this.name,
    this.year,
    this.day,
    this.AgencyId,
    this.month,
    this.social,
    this.email,
    this.Enterbubles,
    this.FriendState,
    this.socialToken,
    this.notifiToken,
    this.rememperToken,
    this.ginder,
    this.description,
    this.coins,
    this.faceBook,
    this.instgram,
    this.joinsrequested,
    this.Hidden,
    this.MessageNumber,
    this.password,
    this.AgencyKarisma,
    this.SuporrtedImage,
    this.visitors,
    this.createdAt,
    this.myappid,
    this.city,
    this.frameimage,
    this.entry,
    this.giftssent,
    this.giftscollect,
    this.Input,
    this.Karisma,
    this.ChairKarisma,
    this.followers,
    this.following,
    this.friends,
    this.followIds,
    this.Level,
    this.ginput,
    this.MyVip,
    this.Newid,
    this.ColoredMessage,
    this.bubbles,
    this.currentroom,
    this.agency,
    this.music,
    this.CurrentRoom,
  });

  // ============================================================
  // Safe JSON Helpers
  // ============================================================

  int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    final String stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return null;
    }

    return int.tryParse(stringValue);
  }

  String? _toStringOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }

  String _toSafeString(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString();
  }

  String _imageUrl(dynamic value) {
    if (value == null) {
      return '';
    }

    final String path = value.toString().trim();

    if (path.isEmpty) {
      return '';
    }

    // Prevent accidentally creating Image_URL + "null".
    return AppConstants.Image_URL + path;
  }

  Map<String, dynamic>? _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  // ============================================================
  // From JSON
  // ============================================================

  usermodel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);

    image = _imageUrl(json['image']);

    phoneNumber = _toStringOrNull(json['phone_number']);

    entry = json['entry'] == null
        ? ''
        : _imageUrl(json['entry']);

    name = _toStringOrNull(json['name']);

    AgencyId = _toInt(json['AgencyId']);

    ColoredMessage = json['ColoredMessage'];

    bubbles = json['bubbles'];

    FriendState = _toInt(json['FriendState']) ?? 0;

    // ============================================================
    // Current joined room
    // ============================================================

    final currentJoinedRoomJson = _toMap(json['myjoindroom']);

    CurrentRoom = currentJoinedRoomJson != null
        ? joinRoom.fromJson(currentJoinedRoomJson)
        : null;

    // ============================================================
    // Starter Banner
    // ============================================================

    final starterBannerJson = _toMap(json['StartBanner']);

    StarterBanner = starterBannerJson != null
        ? StartBannerModel.fromJson(starterBannerJson)
        : null;

    // ============================================================
    // Basic information
    // ============================================================

    year = _toSafeString(json['year']);
    day = _toSafeString(json['day']);

    MessageNumber = _toInt(json['MessageNumber']);

    Hidden = _toInt(json['Hidden']);

    Newid = json['Newid'];

    month = _toSafeString(json['month']);

    social = _toStringOrNull(json['social']);

    email = _toStringOrNull(json['email']);

    Level = _toInt(json['Level']);

    FamilyKarisma = _toInt(json['FamilyKarisma']);

    FamilyAdmin = json['FamilyAdmin'];

    FamilyId = json['FamilyId'];

    FamilyModels = json['FamilyModel'];

    // ============================================================
    // My Room
    // ============================================================

    final myRoomJson = _toMap(json['myroom']);

    MyRoom = myRoomJson != null
        ? RoomModel.fromJson(myRoomJson)
        : null;

    // ============================================================
    // Family
    // ============================================================

    final familyJson = _toMap(json['family']);

    MyFamil = familyJson != null
        ? FamilyModel.fromJson(familyJson)
        : null;

    // ============================================================
    // Media
    // ============================================================

    music = json['music'] == null
        ? null
        : _imageUrl(json['music']);

    socialToken = _toStringOrNull(json['social_token']);

    notifiToken = _toStringOrNull(json['notifi_token']);

    rememperToken = _toStringOrNull(json['userToken']) ?? '';

    ginder = _toStringOrNull(json['ginder']);

    AgencyKarisma = _toInt(json['AgencyKarisma']);

    description = _toStringOrNull(json['description']);

    // ============================================================
    // Counters
    // ============================================================

    followers = _toInt(json['followers']) ?? 0;

    following = _toInt(json['following']) ?? 0;

    friends = _toInt(json['friends']) ?? 0;

    visitors = _toInt(json['visitors']) ?? 0;

    coins = _toInt(json['coins']) ?? 0;

    // ============================================================
    // User flags
    // ============================================================

    Flag = _toStringOrNull(json['Flag']);

    Official = _toInt(json['Official']);

    Admin = _toInt(json['Admin']);

    SuperAdmin = _toInt(json['SuperAdmin']);

    Announcer = _toInt(json['Announcer']);

    DB = _toInt(json['db']);

    MemberAgency = _toInt(json['MemberAgency']);

    MoneyAgency = _toInt(json['MoneyAgency']);

    Supporter = _toInt(json['Supporter']);

    ban = _toInt(json['ban']);

    CustomersService = _toInt(json['CustomersService']);

    // ============================================================
    // VIP
    // ============================================================

    final myVipJson = _toMap(json['myvip']);

    MyVip = myVipJson != null
        ? MyVipmodel.fromJson(myVipJson)
        : null;

    // ============================================================
    // Agency
    // ============================================================

    final agencyJson = _toMap(json['agency']);

    agency = agencyJson != null
        ? Agencymodel.fromJson(agencyJson)
        : null;

    // ============================================================
    // Current Room
    // ============================================================

    final currentRoomJson = _toMap(json['currentroom']);

    currentroom = currentRoomJson != null
        ? RoomModel.fromJson(currentRoomJson)
        : null;

    // ============================================================
    // Gifts Sent
    // ============================================================

    if (json['giftssent'] is List) {
      giftssent = <Gifts>[];

      for (final dynamic value in json['giftssent']) {
        final map = _toMap(value);

        if (map != null) {
          giftssent!.add(
            Gifts.fromJson(map),
          );
        }
      }
    }

    // ============================================================
    // Models
    // ============================================================

    if (json['models'] is List) {
      Models = <UserModels>[];

      for (final dynamic value in json['models']) {
        final map = _toMap(value);

        if (map != null) {
          Models!.add(
            UserModels.fromJson(map),
          );
        }
      }
    }

    // ============================================================
    // Relations
    // ============================================================

    if (json['Relations'] is List) {
      Relations = <RelationModel>[];

      for (final dynamic value in json['Relations']) {
        final map = _toMap(value);

        if (map != null) {
          Relations!.add(
            RelationModel.fromJson(map),
          );
        }
      }
    }

    // ============================================================
    // Profile Images
    // ============================================================

    if (json['profile_image'] is List) {
      ProfileImages = <UserImages>[];

      for (final dynamic value in json['profile_image']) {
        final map = _toMap(value);

        if (map != null) {
          ProfileImages!.add(
            UserImages.fromJson(map),
          );
        }
      }
    }

    // ============================================================
    // Posts
    // ============================================================

    if (json['Postes'] is List) {
      Postuser = <Postes>[];

      for (final dynamic value in json['Postes']) {
        final map = _toMap(value);

        if (map != null) {
          Postuser!.add(
            Postes.fromJson(map),
          );
        }
      }
    } else {
      Postuser = [];
    }

    // ============================================================
    // Follow IDs
    // ============================================================

    if (json['followIds'] is List) {
      followIds = <String>[];

      for (final dynamic value in json['followIds']) {
        if (value != null) {
          followIds!.add(value.toString());
        }
      }
    }

    // ============================================================
    // Join Agency IDs
    // ============================================================

    if (json['JoinAgencyids'] is List) {
      joinsrequested = <int>[];

      for (final dynamic value in json['JoinAgencyids']) {
        final int? parsedValue = _toInt(value);

        if (parsedValue != null) {
          joinsrequested!.add(parsedValue);
        }
      }
    }

    // ============================================================
    // Family Requests
    // ============================================================

    if (json['familyrequest'] is List) {
      FamilyRequests = <int>[];

      for (final dynamic value in json['familyrequest']) {
        final int? parsedValue = _toInt(value);

        if (parsedValue != null) {
          FamilyRequests!.add(parsedValue);
        }
      }
    }

    // ============================================================
    // Gifts Collected
    // ============================================================

    if (json['giftscollect'] is List) {
      giftscollect = <Gifts>[];

      for (final dynamic value in json['giftscollect']) {
        final map = _toMap(value);

        if (map != null) {
          giftscollect!.add(
            Gifts.fromJson(map),
          );
        }
      }
    }

    // ============================================================
    // Additional numeric values
    // ============================================================

    Karisma = _toInt(json['Karisma']);

    ChairKarisma = _toInt(json['ChairKarisma']);

    Input = _toInt(json['Input']);

    ginput = _toInt(json['ginput']);

    // ============================================================
    // Social
    // ============================================================

    faceBook = _toStringOrNull(json['FaceBook']);

    instgram = _toStringOrNull(json['Instgram']);

    // ============================================================
    // Account information
    // ============================================================

    createdAt = _toStringOrNull(json['created_at']);

    updatedAt = _toStringOrNull(json['updated_at']);

    myappid = _toStringOrNull(json['myappid']);

    password = json['PassApp'];

    city = _toStringOrNull(json['city']);

    // ============================================================
    // Images
    // ============================================================

    frameimage = json['frameimage'] == null
        ? ''
        : _imageUrl(json['frameimage']);

    Enterbubles = json['Enterbubles'] == null
        ? ''
        : _imageUrl(json['Enterbubles']);

    SuporrtedImage = json['SuporrtedImage'] == null
        ? null
        : _imageUrl(json['SuporrtedImage']);

    // ============================================================
    // Hidden
    // ============================================================

    Hidden = _toInt(json['Hidden']);
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['image'] = image;
    data['phone_number'] = phoneNumber;

    data['AgencyKarisma'] = AgencyKarisma;
    data['name'] = name;
    data['Hidden'] = Hidden;

    data['followers'] = followers;
    data['following'] = following;
    data['friends'] = friends;

    data['year'] = year;
    data['MessageNumber'] = MessageNumber;
    data['ginput'] = ginput;
    data['AgencyId'] = AgencyId;
    data['Newid'] = Newid;

    data['Supporter'] = Supporter;
    data['ban'] = ban;
    data['ChairKarisma'] = ChairKarisma;
    data['Level'] = Level;
    data['day'] = day;

    data['bubbles'] = bubbles;
    data['ColoredMessage'] = ColoredMessage;

    data['agency'] = agency;

    data['month'] = month;
    data['followIds'] = followIds;
    data['JoinAgencyids'] = joinsrequested;

    data['Official'] = Official;
    data['db'] = DB;
    data['Announcer'] = Announcer;
    data['Admin'] = Admin;
    data['SuperAdmin'] = SuperAdmin;
    data['MemberAgency'] = MemberAgency;

    data['PassApp'] = password;

    data['MoneyAgency'] = MoneyAgency;
    data['CustomersService'] = CustomersService;

    data['familyrequest'] = FamilyRequests;

    if (MyFamil != null) {
      data['family'] = MyFamil!.toJson();
    }

    if (MyRoom != null) {
      data['myroom'] = MyRoom!.toJson();
    }

    data['social'] = social;
    data['email'] = email;
    data['Flag'] = Flag;

    data['social_token'] = socialToken;
    data['notifi_token'] = notifiToken;
    data['music'] = music;
    data['userToken'] = rememperToken;

    data['ginder'] = ginder;
    data['description'] = description;
    data['coins'] = coins;

    data['FriendState'] = FriendState;
    data['visitors'] = visitors;

    data['FaceBook'] = faceBook;
    data['Instgram'] = instgram;

    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    data['myappid'] = myappid;
    data['city'] = city;

    data['giftssent'] = giftssent;
    data['giftscollect'] = giftscollect;

    data['frameimage'] = frameimage;
    data['Enterbubles'] = Enterbubles;

    data['Input'] = Input;
    data['Karisma'] = Karisma;

    data['entry'] = entry;

    data['Postes'] = Postuser;
    data['models'] = Models;

    // Keep original behavior.
    data['profile_image'] = Models;

    data['myjoindroom'] = CurrentRoom;

    if (MyVip != null) {
      data['MyVip'] = MyVip!.toJson();
    }

    if (StarterBanner != null) {
      data['StartBanner'] = StarterBanner!.toJson();
    }

    if (currentroom != null) {
      data['currentroom'] = currentroom!.toJson();
    }

    return data;
  }
}
