

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
  String?Enterbubles;
  String? entry;
  String? phoneNumber;
  int?Hidden;
  int?MessageNumber=0;
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
  int? Karisma=0;
  int? Input;
  int ?ChairKarisma=0;
  int?followers;
  int?following;
  int?friends;
  int?FriendState;
  int?visitors=0;
  int?Level=0;
  int?AgencyId=0;
  int?AgencyKarisma=0;
  String? faceBook;
  String? instgram;
  String? myappid;
    var  password;
  String? createdAt;
  String? updatedAt;
  List<Gifts>? giftssent=[];
  List<Gifts>? giftscollect=[];
  List<String> ?followIds=[];
  List<int> ?joinsrequested=[];
  List<Postes>? Postuser;
  String? Flag;
  MyVipmodel ?MyVip;
  RoomModel ? currentroom;
  RoomModel ? MyRoom;
  var  music;
  Agencymodel? agency;
  joinRoom? CurrentRoom;
  int?FamilyKarisma;
  var FamilyId;
  var FamilyModels;
  var FamilyAdmin;
  List<int>   ?FamilyRequests =[];
  FamilyModel? MyFamil;
  List <UserModels> ?Models=[];
  List <RelationModel> ?Relations=[];
  List <UserImages> ?ProfileImages=[];
int?ginput=0;
  int?Official=0;
  int?Admin=0;
  int?SuperAdmin=0;
  int?MemberAgency=0;

  int?Announcer=0;
  int?DB=0;
  int?MoneyAgency=0;
  int?CustomersService=0;
  int?Supporter=0;
StartBannerModel ?StarterBanner;
  int? ban=0;
  usermodel(
      {this.id,
        this.ban,
        this.Announcer,
        this.DB,
        this.Official,
        this.Admin,
        this.SuperAdmin,
        this.Models,this.ProfileImages,
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
        this.	frameimage,
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
        this.CurrentRoom
      });

  usermodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = AppConstants.Image_URL+json['image'];
    phoneNumber = json['phone_number'].toString();
    entry=json['entry']==null?'':AppConstants.Image_URL+json['entry'];
    name = json['name'];
    AgencyId=json['AgencyId'];
    ColoredMessage=json['ColoredMessage'];
    bubbles=json['bubbles'];
    FriendState=json['FriendState']??0;
    CurrentRoom = json['myjoindroom'] != null ?   joinRoom .fromJson(json['myjoindroom']) : null;
    StarterBanner= json['StartBanner'] != null ?   StartBannerModel .fromJson(json['StartBanner']) : null;
     year = json['year'].toString();
    day = json['day'].toString();
    MessageNumber=json['MessageNumber'];
    Hidden=json['Hidden'];
    Newid=json['Newid'];
    month = json['month'].toString();
    social = json['social'];
    email = json['email'];
    Level= json['Level'];
    FamilyKarisma=json['FamilyKarisma'];
    FamilyAdmin=json['FamilyAdmin'];
    FamilyId=json['FamilyId'];
    FamilyModels=json['FamilyModel'];
    MyRoom = json['myroom'] != null ? new RoomModel.fromJson(json['myroom']) : null;

    MyFamil=json['family'] != null ? new FamilyModel.fromJson(json['family']) : null;
    music=json['music']==null?null:AppConstants.Image_URL+json['music'];
    socialToken = json['social_token'];
    notifiToken = json['notifi_token'].toString();
    rememperToken = json['userToken'] ?? '';

    ginder =json['ginder'].toString();
    AgencyKarisma=json['AgencyKarisma'];
    description = json['description'];
    followers=json['followers']==null?0:json['followers'];
    following=json['following']==null?0:json['following'];
    friends=json['friends']==null?0:json['friends'];
    visitors=json['visitors']==null?0:json['visitors'];
    coins = json['coins']==null?0:json['coins'];
    Flag= json['Flag'];
    Official=json['Official'];
    Admin=json['Admin'];
    SuperAdmin=json['SuperAdmin'];
    Announcer=json['Announcer'];
    DB=json['db'];
    MemberAgency=json['MemberAgency'];
    MoneyAgency=json['MoneyAgency'];
    Supporter=json['Supporter'];
     ban=json['ban'];
    CustomersService=json['CustomersService'];
    MyVip = json['myvip'] != null ? new MyVipmodel.fromJson(json['myvip']) : null;
    agency= json['agency'] != null ? new Agencymodel.fromJson(json['agency']) : null;
    currentroom = json['currentroom'] != null ? new RoomModel.fromJson(json['currentroom']) : null;
    if (json['giftssent'] != null) {
      giftssent = <Gifts>[];
      json['giftssent'].forEach((v) {
        giftssent!.add(new Gifts.fromJson(v));
      });
    }

    if (json['models'] != null) {
      Models = <UserModels>[];
      json['models'].forEach((v) {
        Models!.add(new UserModels.fromJson(v));
      });
    }

    if (json['Relations'] != null) {
      Relations = <RelationModel>[];
      json['Relations'].forEach((v) {
        Relations!.add(new RelationModel.fromJson(v));
      });
    }
    if (json['profile_image'] != null) {
      ProfileImages = <UserImages>[];
      json['profile_image'].forEach((v) {
        ProfileImages!.add(new UserImages.fromJson(v));
      });
    }
    if (json['Postes'] != null) {
      Postuser = <Postes>[];
      json['Postes'].forEach((v) {
        Postuser!.add(new Postes.fromJson(v));
      });
    }else{
      Postuser=[];
    }

    if (json['followIds'] != null) {
      followIds = <String>[];
      json['followIds'].forEach((v) {
        followIds!.add(v);
      });
    }
    if (json['JoinAgencyids'] != null) {
      joinsrequested = <int>[];
      json['JoinAgencyids'].forEach((v) {
        joinsrequested!.add(v);
      });
    }
    if (json['familyrequest'] != null) {
      FamilyRequests = <int>[];
      json['familyrequest'].forEach((v) {
        FamilyRequests!.add(v);
      });
    }


    if (json['giftscollect'] != null) {
      giftscollect = <Gifts>[];
      json['giftscollect'].forEach((v) {
        giftscollect!.add(new Gifts.fromJson(v));
      });
    }
    Karisma=json['Karisma'];
    ChairKarisma=json['ChairKarisma'];
    Input=json['Input'];

    ginput=json['ginput'];
    faceBook = json['FaceBook'];
    instgram = json['Instgram'];
    createdAt = json['created_at']??'';
    myappid=json['myappid'];
    password=json['PassApp'];
    city=json['city'];
    frameimage=json['frameimage']==null?'':AppConstants.Image_URL+json['frameimage'];
    Enterbubles=json['Enterbubles']==null?'':AppConstants.Image_URL+json['Enterbubles'];

    SuporrtedImage=json['SuporrtedImage']==null?null:AppConstants.Image_URL+json['SuporrtedImage'];
    Hidden=json['Hidden'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['phone_number'] = this.phoneNumber;
    data['AgencyKarisma'] = this.AgencyKarisma;
    data['name'] = this.name;
    data['Hidden'] = this.Hidden;
    data['followers'] =this.followers;
    data['following'] =this.following;
    data['friends'] =this.friends;
    data['year'] =  this.year  ;
    data['MessageNumber']=this.MessageNumber;
    data['ginput']=this.ginput;
    data['AgencyId'] =this.AgencyId;
    data['Newid']= this.Newid;
    data['Supporter']= this.Supporter;
    data['ban']=this.ban;
    data['ChairKarisma']=this.ChairKarisma;
    data['Level']=  this.Level  ;
    data['day']=  this.day  ;
    data['bubbles']= this.bubbles;
    data['ColoredMessage']=  this.ColoredMessage  ;
    data['agency']=  this.agency ;
    data['month']=  this.month;
    data['followIds']=this.followIds;
    data['JoinAgencyids']=this.joinsrequested;
    data['Official']= this.Official;

    data['db']= this.DB;
    data['Announcer']= this.Announcer;

    data['Admin']= this.Admin;
    data['SuperAdmin']= this.SuperAdmin;
    data['MemberAgency']= this.MemberAgency;
    data['Supporter']= this.Supporter;
    data['PassApp']= password;
    data['MoneyAgency']= this.MoneyAgency;
    data['CustomersService']= this.CustomersService;

    data['familyrequest']= this.FamilyRequests;

    if (this.MyFamil != null) {
      data['family'] = this.MyFamil!.toJson();
    }
    if (this.MyRoom != null) {
      data['myroom'] = this.MyRoom!.toJson();
    }
    data['social'] = this.social;
    data['email'] = this.email;
    data['Flag']=this.Flag;
    data['social_token'] = this.socialToken;
    data['notifi_token'] = this.notifiToken;
    data['music']=this.music;
    data['userToken'] = this.rememperToken;
    data['ginder'] = this.ginder;
    data['description'] = this.description;
    data['coins'] = this.coins;
    data['FriendState'] =FriendState;
    data['visitors']=  visitors;
    data['FaceBook'] = this.faceBook;
    data['Instgram'] = this.instgram;

    data['created_at'] = this.createdAt;
    data['myappid']=this.myappid;
    data['city']=this.city;
    data['giftssent']=this.giftssent;
    data['giftscollect']=this.giftscollect;
    data['frameimage']=this.frameimage;
    data['Enterbubles']=this.Enterbubles;
    data['Input']=this.Input;
    data['Karisma']=this.Karisma;
    data['entry']=this.entry;
    data['Postes']=this.Postuser;
    data['models']=this.Models;
    data['profile_image']=this.Models;
    data['myjoindroom']=CurrentRoom;
    if (this.MyVip != null) {
      data['MyVip'] = this.MyVip!.toJson();
    }
    if (StarterBanner != null) {
      data['StartBanner'] = StarterBanner!.toJson();
    }
    if (this.currentroom != null) {
      data['currentroom'] = this.currentroom!.toJson();
    }
    return data;
  }
}