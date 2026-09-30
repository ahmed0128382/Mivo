
import 'package:ahlachat/Repositores/Room_repositores/Room_repository.dart';
import 'package:ahlachat/models/FlagModel.dart';
import 'package:ahlachat/models/KarismaCollectModel.dart';
import 'package:ahlachat/models/Leaderboardroommodel.dart';
import 'package:ahlachat/models/Weeklystarmodel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:dio/dio.dart';

 import 'package:provider/provider.dart';

import '../../models/ChairModel.dart';
import '../../models/JoinRoomModel.dart';
import '../../models/Kickedusers.dart';
import '../../models/Leaderboardusermodel.dart';
import '../../models/RoomKarismaModel.dart';
import '../../models/RoomModel.dart';
import '../../models/SupervisorsModel.dart';
import '../../models/gifts.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import '../../viewmodels/Room_Viewmodel/Room_Viewmodel.dart';

int Index=2;
int IndexTrade=2;
int IndexRecommended=2;
int IndexRecommended2=2;
class Roomapi extends RoomRepository {
  @override
  var dio = Dio(BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization':Token,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ));
  List<RoomModel> ImportantRooms=[];
  List<FlagModel> Countries=[];
  List<RoomModel> FixedRooms=[];
  List<RoomModel> TradeRooms=[];
  List<KickedUser> KickeduserRooms=[];
  List<joinRoom> joinuserRooms=[];
  RoomModel Roominfo=RoomModel();
  Updatemute({room_id, user_id, context,state})async{
   bool Mute= false;
    try {
      FormData formData = FormData.fromMap({
        "user_id": user_id.toString(),
        "state":int.parse(state.toString()),
        "room_id":room_id.toString()
      });
      Response response2 = await dio.post(
        'api/updatemutechair',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
        Mute=true;
      }else{
        Mute=false;
      }
    } catch (e) {
    print(e);
    }

    return Mute;
  }
  Future<RoomModel> UpdateRoom({name,roomid, image,backimage ,Category,lock,password,RoomAds})async{
    try {
      print({
        "name":name.toString(),
        "password": password,
        "Category": Category,
        "animateimage":backimage,
        "room_id":roomid.toString(),
        "RoomAds":RoomAds.toString()
      });
      var  map;
      if(image==null){
          map={
          "name":name.toString(),
           "password": password,
          "Category": Category,
          "animateimage":backimage,
          "room_id":roomid.toString(),
            "RoomAds":RoomAds.toString()
        };
      }else{
          map={
          "name":name.toString(),
          "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
          "password": password,
          "Category": Category,
          "animateimage":backimage,
          "room_id":roomid.toString(),
            "RoomAds":RoomAds.toString()
        };
      }

      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/UpdateRoom',
        data: formData,
      );

      if (response2.statusCode == 200) {
        Roominfo = RoomModel.fromJson(response2.data['Room']);
      }
    } catch (e) {
      print(e);

    }

    return Roominfo;
  }
  Future<bool> UnkickeuserRoom({kickid,context})async{
    bool states=false;
    try {
      var  map={
        "kick_id": kickid.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/unkickuser',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }

  Future<bool> UpdateThroneChair({room_id,State,context})async{
    bool states=false;
    try {
      var  map={
        "room_id": room_id.toString(),
        "status": State.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/SetThroneChair',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }


  Future<bool> SendInviteChairRoom({roomid,userid,context})async{
    bool states=false;
    try {
      var  map={
        "user_id": userid.toString(),
        "room_id":roomid.toString(),
        "chair_id":InviteChairId.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/SentInviteChair',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {

    }

    return states;
  }


  Future<bool> deleteChatRoom({RoomID,context})async{
    bool states=false;
    try {
      var  map={
        "room_id": RoomID.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/DeleteRoomChat',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }
  Future<bool> SetRoomPssword({roomid,password,context})async{
   bool states=false;
    try {
      var  map={
          "password": password.toString(),
          "room_id":roomid.toString()
        };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/SetPasswordRoom',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }
  Future<bool> RemoveRoomPssword({roomid,context})async{
    bool states=false;

    try {


      var   map={
        "room_id":roomid.toString()
      };


      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/RemovePasswordRoom',
        data: formData,
      );
       
      if(response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }
      else
      {
        states=false;
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return states;
  }
  Future<List<joinRoom>>  Roomsjoinuser({context, room_id})async {
    try {
      FormData formData = FormData.fromMap({
        "room_id":room_id.toString()
      });
      Response response2 = await dio.post(
        'api/Getjoinusers',
        data: formData,
      );
      print(response2.data['join']);
      if (response2.statusCode == 200) {
        List list =response2.data['join'];
        list.forEach((element){
          joinuserRooms.add(joinRoom.fromJson(element));
        });
        print(joinuserRooms);
      }
    } catch (e) {
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }
    return joinuserRooms;

  }
  Future<Roomkarismamodel?>  RoomsKarisma({context, room_id})async {
    Roomkarismamodel ?RoomKarismas ;
    try {

      Response response2 = await dio.get(
        'api/GetRoomKarismas/$room_id',

      );

      if (response2.statusCode == 200) {

        RoomKarismas=Roomkarismamodel.fromJson(response2.data['RoomKarisma']);
        print(RoomKarismas.monthlysupporter?.length);
        print(RoomKarismas.dailysupporter?.length);
        print(RoomKarismas.weeklysupporter?.length);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }
    return   RoomKarismas ;

  }
  List<KarismaCollectModel> karismas=[];
  Future<List<KarismaCollectModel>>  GetCollectKarisma({context, room_id,user_id,chairid})async {

    try {

      Response response2 = await dio.get(
        'api/GetUserKarismaDetales2/$user_id/$room_id/$chairid',

      );

      if (response2.statusCode == 200) {
        List list =response2.data;
        list.forEach((element) {
          karismas.add(KarismaCollectModel.fromJson(element));
        });

      }
    } catch (e) {

    }
    return   karismas ;

  }

  Future<bool> Evictionuser({context,Roomid,Userid})async{
    bool JoinRoom=false;
    try {
      FormData formData = FormData.fromMap({
        "room_id": Roomid.toString(),
        "user_id": Userid.toString(),
      });
      Response response2 = await dio.post(
        'api/Evictionuser',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
        JoinRoom=true;
      }else{
        JoinRoom=false;
      }
    } catch (e) {

    }

    return JoinRoom;
  }
  Future<bool> DisbandRoom({context,Roomid })async{
    bool JoinRoom=false;
    try {
      FormData formData = FormData.fromMap({
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/DisbandRoom',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
        JoinRoom=true;
      }else{
        JoinRoom=false;
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return JoinRoom;
  }
  Future<List<RoomModel>>  Rooms(context)async {
 Index=2;
    try {
      Response response2 = await dio.get(
        'https://worldchat.online/api/GetRooms/$SelectedRoomCategory',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];
        list.forEach((element) {
          ImportantRooms.add(RoomModel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
         }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  getFixedRooms(context)async {

    try {
      Response response2 = await dio.get(
        AppConstants.BASE_URL+'api/GetFixedRoom',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms'];
        list.forEach((element) {
          ImportantRooms.add(RoomModel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  SearchRooms(context,tittle)async {

    try {
      Response response2 = await dio.get(
        '/api/SearchRoom/$tittle',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms'];
        list.forEach((element) {
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  GetFollowedRooms(context )async {
    print(UserId);
List<RoomModel> FollowedRoom=[];
    try {
      Response response2 = await dio.get(
        '/api/GetFollowRoom/$UserId',
      );
print(response2.data);
      if (response2.statusCode == 200) {
        List list =response2.data['FollowRoom'];
        list.forEach((element) {
          FollowedRoom.add(RoomModel.fromJson(element['room']));
        });
        print(FollowedRoom);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return FollowedRoom;

  }
  Future<List<RoomModel>>  AddmoreRooms(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetRooms/${SelectedRoomCategory}?page=${Index.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Rooms']['data'];
        if(list.isNotEmpty){
          Index++;
        }
        print("INDEX IS $Index");
        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {
       
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {
          
        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }


  Future<List<RoomModel>>  AddmoreRecommended(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetRecomended?page=${IndexRecommended.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Rooms']['data'];
        if(list.isNotEmpty){
          IndexRecommended++;
        }
        print("INDEX IS $IndexRecommended");
        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }

  Future<List<RoomModel>>  AddExploreRecommended(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetRecomended2?page=${IndexRecommended2.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Rooms']['data'];
        if(list.isNotEmpty){
          IndexRecommended2++;
        }
        print("INDEX IS $IndexRecommended");
        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  FoolowingUserRooms(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetRoomUserFollowing/$UserId',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Rooms'];

        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {

    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  RecommendedRooms(context)async {
    IndexRecommended=2;
    try {
      Response response2 = await dio.get(
        '/api/GetRecomended',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];

        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  ExploreRooms(context)async {
    IndexRecommended2=2;
    try {
      Response response2 = await dio.get(
        '/api/GetRecomended2',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];

        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return ImportantRooms;

  }
  Future<List<RoomModel>>  CountryRooms({  Country})async {
    IndexRecommended2=2;
    try {
      Response response2 = await dio.get(
        '/api/GetCountryRooms/$Country',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];

        list.forEach((element){
          ImportantRooms.add(RoomModel.fromJson(element));
        });
        print(ImportantRooms);
      }
    } catch (e) {

    }

    return ImportantRooms;

  }
  Future<List<FlagModel>>  GetCountries(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetCountries',
      );

      if (response2.statusCode == 200) {
        List list =response2.data;

        list.forEach((element){
          Countries.add(FlagModel.fromJson(element));
        });
        print(Countries);
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return Countries;

  }
  Future<bool>  CheckPassworRooms({id})async {
    bool PasswordRoom=false;
    try {
      Response response2 = await dio.get(
        '/api/CheckPasswordRoomnew/$id',
      );

      if (response2.statusCode == 200) {
        PasswordRoom=true;

      }else{
        PasswordRoom=false;
      }
    } catch (e) {

    }

    return PasswordRoom ;

  }

  Future<bool>  EnterCheckPassworRooms({id,pass})async {
    bool PasswordRoom=false;
    try {
      Response response2 = await dio.get(
        '/api/CheckPasswordright/$id/$pass',
      );

      if (response2.statusCode == 200) {
        PasswordRoom=true;

      }else{
        PasswordRoom=false;
      }
    } catch (e) {

    }

    return PasswordRoom ;

  }

  //--------------------------------
  Future<List<RoomModel>>NewRooms(context)async {
    try {
      Response response2 = await dio.get(
        '/api/GetNewRooms',
      );
      if (response2.statusCode == 200) {
        List list =response2.data['Rooms']['data'];
         list.forEach((element) {
          TradeRooms.add(RoomModel.fromJson(element));
        });

      }
    } catch (e) {
      
    }

    return TradeRooms;

  }

  Future<ListoflEaderboardcategoryRoom?>getRoomLeaderboard(context)async {
    ListoflEaderboardcategory ? Leaderboardsupporter;
    ListoflEaderboardcategory ? Leaderboardsupported;
    ListoflEaderboardcategoryRoom ?LeaderboardRoom;
    try {
      Response response2 = await dio.get(
        '/api/GetRoomLeaderboard',
      );

      if (response2.statusCode == 200) {

        // Leaderboardsupporter=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['supporter']);
        //
        // Leaderboardsupported=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['Recipient']);
        LeaderboardRoom=ListoflEaderboardcategoryRoom.fromJson(response2.data['Leaderboard']['Room']);


  }
    } catch (e) {

    }

    return LeaderboardRoom ;

  }
  Future<ListoflEaderboardcategory?>getGiverLeaderboard(context)async {
    ListoflEaderboardcategory ? Leaderboardsupporter;

    try {
      Response response2 = await dio.get(
        '/api/GetGiverLeaderboard',
      );

      if (response2.statusCode == 200) {

        Leaderboardsupporter=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['supporter']);





      }
    } catch (e) {

    }

    return Leaderboardsupporter ;

  }

  Future<WeeklyStarModel?>GetWeeklystar(context)async {
    WeeklyStarModel ? Leaderboardsupporter;

    try {
      Response response2 = await dio.get(
        '/api/GetsupporterWeeklyStar',
      );
print(response2.data['supporteds']);
      if (response2.statusCode == 200) {

        Leaderboardsupporter=WeeklyStarModel.fromJson(response2.data);





      }
    } catch (e) {

    }

    return Leaderboardsupporter ;

  }

  Future<ListoflEaderboardFamilycategory?>getFamilyLeaderboard(context)async {
    ListoflEaderboardFamilycategory ? Leaderboardsupporter;

    try {
      Response response2 = await dio.get(
        '/api/GetFamilyLeaderboard',
      );
 
      if (response2.statusCode == 200) {

        Leaderboardsupporter=ListoflEaderboardFamilycategory.fromJson(response2.data['Leaderboard']['Family']);
print(Leaderboardsupporter.weeklysupporter?.length);



      }
    } catch (e) {
print(e);
    }

    return Leaderboardsupporter ;

  }

  Future<ListoflEaderboardcategory?>getReciverLeaderboard(context)async {
    ListoflEaderboardcategory ? Leaderboardsupported;
    try {
      Response response2 = await dio.get(
        '/api/GetReciverLeaderboard',
      );
      if (response2.statusCode == 200) {


        Leaderboardsupported=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['Recipient']);



      }
    } catch (e) {

    }

    return Leaderboardsupported ;

  }

  Future<List<RoomModel>>  GetMoreTrendRoom(context)async {
    

    try {
      Response response2 = await dio.get(
        '/api/GetNewRooms?page=${IndexTrade.toString()}',
      );
print(response2.data);
      if (response2.statusCode == 200) {

        List list =response2.data['Rooms']['data'];
        if(list.isNotEmpty){
          IndexTrade++;
        }
        
        list.forEach((element){
          TradeRooms.add(RoomModel.fromJson(element));
        });
        print(TradeRooms);
      }
    } catch (e) {
      
    }

    return TradeRooms;

  }
  Future<List<KickedUser>>  KickedUserRooms({context, roomid})async {

    try {
      Response response2 = await dio.get(
        '/api/getkickeduser/$roomid',
      );

      if (response2.statusCode == 200) {
        List list =response2.data;
        list.forEach((element) {
          KickeduserRooms.add(KickedUser.fromJson(element));
        });
        print(KickeduserRooms);
      }
    } catch (e) {
      
    }

    return KickeduserRooms;

  }

  Future<RoomModel> joinRooms({ context,Roomid}) async {
     RoomViewmodel Roomss=  Provider.of<RoomViewmodel>(context,listen: false);
     try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/JoinRoom',
        data: formData,
      );

      if (response2.statusCode == 200) {

        print('Join Responce is');
        Roominfo = RoomModel.fromJson(response2.data['Room']);
        Joinid = response2.data['Room']['joinid'];
        print( response2.data['Room']['joinid']);
        Roomss.clearcompo();
        Roomss.hidewaitingtimer2();
        print('JOIN ID IS $Joinid');
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {
print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return Roominfo;
  }
  Future<bool> Addsupervisors({ context,Roomid,userid}) async {
    bool state=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": userid.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/AddSupervisors',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
        state=true;
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {
      state=false;
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return state;
  }
  Future<bool> AddackImage({  image}) async {
    bool state=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "image": await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
      });
      Response response2 = await dio.post(
        'api/AddRoomimages',
        data: formData,
      );
print(response2.data['Roomimages']['image']);
      if (response2.statusCode == 200) {
        LoginViewmodel user=  Provider.of<LoginViewmodel>(roomcontext,listen: false);

        user.AddFirstbackground(val: response2.data['Roomimages']['image']);
        state=true;
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {
      state=false;
      print(e);

    }

    return state;
  }
  Future<bool> FollowRoom({ context,Roomid }) async {
    bool state=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/FollowRoom',
        data: formData,
      );

      if (response2.statusCode == 200) {
        state=true;
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {
      state=false;
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return state;
  }
  Future<bool> RemoveFollowRoom({ context,Roomid }) async {
    bool state=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/RemoveFollowRooms',
        data: formData,
      );

      if (response2.statusCode == 200) {
        state=true;
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {
      state=false;
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return state;
  }

  List<Gifts> RoomGifts=[];
  Future<List<Gifts>> GetRoomGifts({Roomid}) async {

    try {
      FormData formData = FormData.fromMap({
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/GetRoomGift',
        data: formData,
      );

      if (response2.statusCode == 200) {
        List list =response2.data['gifts'] ;
        list.forEach((element) {
          RoomGifts.add(Gifts.fromJson(element));
        });
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);

      } else {
        print(e);
      }
    }

    return RoomGifts;
  }
  List<Supervisors> SupervisorRoom=[];
  Future<List<Supervisors>> GetRoomSupercisors({Roomid}) async {

    try {

      Response response2 = await dio.get(
        'api/GetRoomSupervisors/$Roomid',

      );
print(response2.data);
      if (response2.statusCode == 200) {
        List list =response2.data ;
        list.forEach((element) {
          SupervisorRoom.add(Supervisors.fromJson(element));
        });
        //Provider.of<LoginViewmodel>(context,listen: false).SendCodeRegester(context: context,phonenumber: "+2"+phone.toString());
      }
    } catch (e) {

      if (e is DioError) {
        print(e.response?.data['errNum']);

      } else {
        print(e);
      }
    }

    return SupervisorRoom;
  }
  Future<bool> Removesupervisors({ context,Roomid,userid}) async {
    bool state=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": userid.toString(),
        "room_id": Roomid.toString(),
      });
      Response response2 = await dio.post(
        'api/RemoveSupervisors',
        data: formData,
      );

      if (response2.statusCode == 200) {
        state=true;
       }
    } catch (e) {
      state=false;

    }

    return state;
  }
  Future<RoomModel> CreateRoom({context,Category,city,image,name,backgroundimage,RoomAds}) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name.toString(),
        "image": await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
        "admin_id": UserId.toString(),
        "Category":Category,
        "city":city,
        "animateimage":backgroundimage.toString(),
        "RoomAds":RoomAds.toString()
      });

      Response response2 = await dio.post(
        'api/CreateRoom',
        data: formData,
      );
      print(response2.data );
      print(response2.data['errNum']);
      if (response2.statusCode == 200) {
         
        Roominfo = RoomModel.fromJson(response2.data['room']);
      }else{

      }
    } catch (e) {


      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return Roominfo;
  }
  Future<bool>  LeaveRoom({ context,Roomid}) async {
bool leaved=false;

    try {
      var  map={
        "join_id": Joinid.toString(),
        "room_id":Roomid.toString(),
        "user_id":   UserId.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null||value=='null'||key=='null');
      FormData formData = FormData.fromMap(map);
      print('Join id is 1');
      Response response2 = await dio.post(
        'api/LeaveRoom',
        data: formData,
      );
      print('Join id is 2');
       
      if (response2.statusCode == 200) {
         
        leaved=true;
       }else if(response2.statusCode == 400){
        leaved=false;
      }
      print('Join id is  3');
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return leaved;
  }
  Future<bool>  LeaveChair({ context,Roomid,chairid}) async {
    bool leaved = false;
    try {
      FormData formData = FormData.fromMap({
        "chair_id": chairid.toString(),
        "room_id":Roomid.toString(),
        "user_id":   UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/LeaveChair',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         
        leaved=true;
      }else if(response2.statusCode == 400){
        leaved=false;
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return leaved;
  }
  Future<bool>  LeaveuserChair({ context,user_id,Roomid,chairid}) async {
    print(chairid);   print(Roomid);print(user_id);
    try {
      FormData formData = FormData.fromMap({
        "chair_id": chairid.toString(),
        "room_id":Roomid.toString(),
        "user_id":   user_id.toString(),
      });

      Response response2 = await dio.post(
        'api/LeaveChair',
        data: formData,
      );
      print(response2.data);
      if (response2.statusCode == 200) {
         
        print('done');
      }else if(response2.statusCode == 400){
        print('not done');
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return true;
  }
  Future<bool> joinChair({context,index,room_id,chair_id}) async {
      bool joicchair=false;
      try {
        print('xxxxxxxxxxxxxxxxx');
        print(UserId.toString());
        print(room_id.toString());
        print(chair_id.toString());
        FormData formData = FormData.fromMap({
          "user_id":  UserId.toString(),
          "room_id": room_id.toString(),
          "chair_id":chair_id.toString()
        });

        Response response2 = await dio.post(
          'api/JoinChair',
          data: formData,
        );
         
        print('waeassaeaseasasasewaeassaeaseasasasewaeassaeaseasasasewaeassaeaseasasasewaeassaeaseasasase');
        if (response2.statusCode == 200||response2.statusCode == 201) {


          joicchair=true;
        }else{
           
          print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
          joicchair=false;
        }
      } catch (e) {

        if (e is DioError) {
          print(e.response?.data['errNum']);
          Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
        } else {
          print(e);
        }
      }

      return joicchair;
  }
  Future<bool> ChangeChair({context,index,room_id,NewCharid,CurrentChairid}) async {
    bool joicchair=false;
    try {

      FormData formData =   FormData.fromMap({
        "user_id":  UserId.toString(),
        "room_id": room_id.toString(),
        "Current_chair":CurrentChairid.toString(),
        "chair_id":NewCharid.toString(),
      });

      Response response2 = await dio.post(
        'api/ChangeChair',
        data: formData,
      );

      print(response2.data);
      if (response2.statusCode == 200||response2.statusCode == 201) {


        joicchair=true;
      }else{


        joicchair=false;
      }
    } catch (e) {


    }

    return joicchair;
  }
  Future<bool> AdminChangeChair({context,index,room_id,NewCharid,CurrentChairid}) async {
    bool joicchair=false;
    try {

      FormData formData =   FormData.fromMap({
        "user_id":  UserId.toString(),
        "room_id": room_id.toString(),
        "Current_chair":CurrentChairid.toString(),
        "chair_id":NewCharid.toString(),
      });

      Response response2 = await dio.post(
        'api/AdminChangeChair',
        data: formData,
      );

      print(response2.data);
      if (response2.statusCode == 200||response2.statusCode == 201) {


        joicchair=true;
      }else{


        joicchair=false;
      }
    } catch (e) {


    }

    return joicchair;
  }
  Future<bool> ReturnAdminChair({context,index,room_id,NewCharid,CurrentChairid}) async {
    bool joicchair=false;
    try {

      FormData formData =   FormData.fromMap({
        "user_id":  UserId.toString(),
        "room_id": room_id.toString(),
        "Current_chair":CurrentChairid.toString(),
        "chair_id":NewCharid.toString(),
      });

      Response response2 = await dio.post(
        'api/ReturntoAdminChair',
        data: formData,
      );

      print(response2.data);
      if (response2.statusCode == 200||response2.statusCode == 201) {


        joicchair=true;
      }else{


        joicchair=false;
      }
    } catch (e) {


    }

    return joicchair;
  }

KickJoinadminuser({context,room_id,user_id})async{
  bool update=false;

  try {
    FormData formData = FormData.fromMap({
      "user_id": user_id.toString(),
      "room_id": room_id.toString(),

    });

    Response response2 = await dio.post(
      'api/Removeadminroom',
      data: formData,
    );

    if (response2.statusCode == 200) {
      update=true;
      print('true');
    }else{
      update=false;
      print('false');
    }
  } catch (e) {
    if (e is DioError) {
       
      Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
      if (e.response!.data['errNum'] == '3500') {
        
      }
    } else {
      print(e);
    }
  }

  return update;


}
  InviteUserToSET({context,room_id,user_id})async{
    bool update=false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": user_id.toString(),
        "room_id": room_id.toString(),

      });

      Response response2 = await dio.post(
        'api/Inviteuser',
        data: formData
      );

      if (response2.statusCode == 200) {
        update=true;
        print('true');
      }else{
        update=false;
        print('false');
      }
    } catch (e) {
      if (e is DioError) {
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {
        }
      } else {
        print(e);
      }
    }
    return update;
  }
Future<bool> sendmessage({  content,Roomid})async{

bool sent=true;
  try {
    FormData formData = FormData.fromMap({
      "user_id": UserId.toString(),
      "room_id": Roomid.toString(),
      "content":content.toString(),
    });

    Response response2 = await dio.post(
      'api/AddChatRoom',
      data: formData,
    );

    if (response2.statusCode == 200) {
      sent=true;
      print('true');
    }else{
      sent=false;
      print('false');
    }
  } catch (e) {
    if (e is DioError) {
       

      if (e.response!.data['errNum'] == '3500') {
        
      }
    } else {
      print(e);
    }
  }

  return sent;

}
  Future<bool> sendMention({  content,Roomid,Reciver_id})async{

    bool sent=true;
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
        "content":content.toString(),
        "reciver_id":Reciver_id.toString(),
      });

      Response response2 = await dio.post(
        'api/AddMention',
        data: formData,
      );

      if (response2.statusCode == 200) {
        sent=true;
        print('true');
      }else{
        sent=false;
        print('false');
      }
    } catch (e) {
      if (e is DioError) {


        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return sent;

  }
  Future<bool> LockChair ({ Chair_id, int? Lock,RoomModel ?Roominfo})async{
   bool update=false;
    try {
      FormData formData = FormData.fromMap({
        "chair_id": Chair_id.toString(),
        "room_id": Roominfo?.id.toString(),
        "Lock":Lock.toString(),
      });

      Response response2 = await dio.post(
        'api/LockChair',
        data: formData,
      );

      if (response2.statusCode == 200) {
        update=true;
        print('true');
      }else{
        update=false;
        print('false');
      }
    } catch (e) {
      
    }
    return update;
  }
  Future<bool> SendGift({ context,Roomid,Listuser,giftid,quantity,Cost}) async {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    var send=true;
    try {
      FormData formData = FormData.fromMap({
        "Listuser": Listuser.toString(),
        "room_id": Roomid.toString(),
        "user_id": UserId.toString(),
        "quantity": quantity.toString(),
        "gift_id": giftid.toString(),
        "Cost":Cost.toString()

      });

      Response response2 = await dio.post(
        'api/sentGift',
        data: formData,
      );


      if (response2.statusCode == 200) {
        user.Updatecoins(coins: int.parse(response2.data['user']['coins'].toString()));
        send=true;
         
      }else{
        send=false;
      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return send;
  }
  Future<String> SentLuckyGift({ context,Roomid,Listuser,giftid,quantity,Cost}) async {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    String prsantage='';
    try {
      FormData formData = FormData.fromMap({
        "Listuser": Listuser.toString(),
        "room_id": Roomid.toString(),
        "user_id": UserId.toString(),
        "quantity": quantity.toString(),
        "gift_id": giftid.toString(),
        "Cost":Cost.toString()

      });

      Response response2 = await dio.post(
        'api/SentLuckyGift',
        data: formData,
      );

      if (response2.statusCode == 200) {
        print('=====================ReturnMyCOINS========>${response2.data['gain']['coins'].toString()}==================>');
        print('=====================ReturnWin========>${response2.data['gain']['ReturnedValue']['win'].toString()}==================>');
        print('=====================Persantagec========>${response2.data['gain']['ReturnedValue']['Persantage'].toString()}==================>');


        if(response2.data['gain']['ReturnedValue']['Persantage']!=0&&response2.data['gain']['ReturnedValue']['Persantage']!='0'){
          Provider.of<RoomViewmodel>(roomcontext,listen: false).addComboWin( amount:response2.data['gain']['ReturnedValue']['win'],persantage: response2.data['gain']['ReturnedValue']['Persantage']);

        }
        user.Updatecoins(coins: int.parse(response2.data['gain']['coins'].toString()));
        prsantage=response2.data['gain']['ReturnedValue']['win'].toString();
        print(response2.data['gain']);
      }else{
        prsantage='';
      }
    } catch (e) {
      print(e);
      prsantage='';

    }

    return prsantage;
  }
  Future<String> SentCompoGift({ context,Roomid,Listuser,giftid,quantity,Cost}) async {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    String prsantage='';
    try {
      FormData formData = FormData.fromMap({
        "Listuser": Listuser.toString(),
        "room_id": Roomid.toString(),
        "user_id": UserId.toString(),
        "quantity": quantity.toString(),
        "gift_id": giftid.toString(),
        "Cost":Cost.toString()

      });

      Response response2 = await dio.post(
        'api/SentCompo',
        data: formData,
      );

      if (response2.statusCode == 200) {
        print('=====================ReturnMyCOINS========>${response2.data['gain']['coins'].toString()}==================>');
        print('=====================ReturnWin========>${response2.data['gain']['ReturnedValue']['win'].toString()}==================>');
        print('=====================Persantagec========>${response2.data['gain']['ReturnedValue']['Persantage'].toString()}==================>');

        if(response2.data['gain']['ReturnedValue']['Persantage']!=0&&response2.data['gain']['ReturnedValue']['Persantage']!='0'){
          Provider.of<RoomViewmodel>(roomcontext,listen: false).addComboWin( amount:response2.data['gain']['ReturnedValue']['win'],persantage: response2.data['gain']['ReturnedValue']['Persantage']);

        }

        user.Updatecoins(coins: int.parse(response2.data['gain']['coins'].toString()));
        prsantage=response2.data['gain']['ReturnedValue']['win'].toString();
        print(response2.data['gain']);
      }else{
        prsantage='';
      }
    } catch (e) {
      prsantage='';
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return prsantage;
  }

  Future<bool> SendEmoje({ context,Emoje,Room_id}) async {
    print( Emoje.toString());
    var send=true;
    try {
      FormData formData = FormData.fromMap({
        "emoji": Emoje.toString(),
        "room_id": Room_id.toString(),
        "user_id":UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/Sendemoji',
        data: formData,
      );

      if (response2.statusCode == 200) {

        send=true;
         
      }else{

        send=false;
      }
    } catch (e) {
      print(e);

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return send;
  }

  Future<bool> SentImageRoom({ context,image,Room_id}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
        "room_id": Room_id.toString(),
        "user_id":UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/SendImage',
        data: formData,
      );

      if (response2.statusCode == 200) {

        send=true;
         
      }else{

        send=false;
      }
    } catch (e) {
      print(e);

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return send;
  }
  Future<bool> Playdice({ context,Room_id}) async {

    var send=true;
    try {
      FormData formData = FormData.fromMap({

        "room_id": Room_id.toString(),
        "user_id":UserId.toString(),
      });

      Response response2 = await dio.post(
        'api/Playdice',
        data: formData,
      );

      if (response2.statusCode == 200) {

        send=true;
         
      }else{

        send=false;
      }
    } catch (e) {
      print(e);

    }

    return send;
  }
  Future<bool> Playrollet({ context,Room_id,Name}) async {

    var send=true;
    try {
      FormData formData = FormData.fromMap({

        "room_id": Room_id.toString(),
        "user_id":UserId.toString(),
        "name":Name.toString(),
      });

      Response response2 = await dio.post(
        'api/Playrollet',
        data: formData,
      );

      if (response2.statusCode == 200) {

        send=true;
         
      }else{

        send=false;
      }
    } catch (e) {
      print(e);

    }

    return send;
  }
  Future<bool> Addinsults ({context, type,message})async{
    bool update=false;

    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId,
        "type": type,
        "text":message.toString(),
      });

      Response response2 = await dio.post(
        'api/Addinsult',
        data: formData,
      );

      if (response2.statusCode == 200) {
        update=true;
        print('true');
      }else{
        update=false;
        print('false');
      }
    } catch (e) {
      if (e is DioError) {

        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }
    return update;
  }
}
