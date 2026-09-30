import 'package:ahlachat/Repositores/Follow_repositores/Follow_repository.dart';
import 'package:ahlachat/models/Followmodel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:dio/dio.dart';

import '../../models/Visitors.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';


class Followapi extends FollowRepository {

  @override
  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Connection': 'Keep-Alive',
        'Authorization':Token,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ),
  );
  List<Follows> Myfans=[];
  List<usermodel> Friends=[];
  List<visitors> Myvisitors=[];
  Future<List<Follows>>  GetFans(context)async {

    try {
      Response response2 = await dio.get(
        '/api/Getmyfollowers/${UserId}',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Follow'] ;

        list.forEach((element) {
          Myfans.add(Follows.fromJson(element));
        });

 
      }
    } catch (e) {
      print(e);
      
    }

    return Myfans;

  }
  Future<bool> SentShareRoom({userid,roomid})async{
    bool states=false;
    try {
      var  map={
        "user_id": userid.toString(),
        "room_id": roomid.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = new FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/SentShareRoom',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);

    }

    return states;
  }
  Future<List<visitors>>  Getvisitors(context)async {

    try {
      Response response2 = await dio.get(
        '/api/Getmyvisitors/${UserId}',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['visitor'] ;

        list.forEach((element) {
          Myvisitors.add(visitors.fromJson(element));
        });

 
      }
    } catch (e) {
      print(e);
      
    }

    return Myvisitors;

  }

  Future<List<visitors>>  Getvisitors2({required context,id})async {

    try {
      Response response2 = await dio.get(
        '/api/Getmyvisitors/${id}',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['visitor'] ;
        print(response2.data['visitor'] );
        list.forEach((element) {
          Myvisitors.add(visitors.fromJson(element));
        });

 
      }
    } catch (e) {
      print(e);
      
    }

    return Myvisitors;

  }

  Future<List<Follows>>  GetFollowing(context)async {

    try {
      Response response2 = await dio.get(
        '/api/Getmyfollowing/${UserId}',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Follow'] ;

        list.forEach((element) {
          Myfans.add(Follows.fromJson(element));
        });

 
      }
    } catch (e) {
      print(e);
      
    }

    return Myfans;

  }

  Future<List<usermodel>>  GetFriends(context)async {

    try {
      Response response2 = await dio.get(
        '/api/GetMyFriends/$UserId',
      );

      if (response2.statusCode == 200) {
        List list =response2.data  ;

        list.forEach((element) {
          Friends.add(usermodel.fromJson(element));
        });

 
      }
    } catch (e) {
      print(e);
      
    }

    return Friends;

  }
  Future<bool> CheckFriends(id)async {
bool state=false;
    try {
      Response response2 = await dio.get(
        '/api/CheckFrindstateFriends/$UserId/$id',
      );

      if (response2.statusCode == 200) {
        state=true;
      }
    } catch (e) {
      state=false;

    }

    return state;

  }

  Future<List<Follows>>  GetShareFriends({Roomid})async {


    try {
      Response response2 = await dio.get(
        '/api/GetSharefrinds/$UserId/$Roomid',
      );
      print(response2.data['Follow']);
      if (response2.statusCode == 200) {
        List list =response2.data['Follow'] ;
        SharedRoomIds =response2.data['ShareIds'];

        list.forEach((element) {
          Myfans.add(Follows.fromJson(element));
        });


      }
    } catch (e) {
      print(e);

    }

    return Myfans;

  }

  Future<List<Follows>>  GetFans2(context,id)async {

    try {
      Response response2 = await dio.get(
        '/api/Getmyfollowers/$id',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Follow'] ;
        print(response2.data['Follow'] );
        list.forEach((element) {
          Myfans.add(Follows.fromJson(element));
        });
        print(Myfans );
 
      }
    } catch (e) {
      print(e);
      
    }

    return Myfans;

  }


  Future<List<Follows>>  GetFollowing2(context,id)async {

    try {
      Response response2 = await dio.get(
        '/api/Getmyfollowing/$id',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Follow'] ;
        print(response2.data['Follow'] );
        list.forEach((element) {
          Myfans.add(Follows.fromJson(element));
        });
        print(Myfans );
 
      }
    } catch (e) {
      print(e);
      
    }

    return Myfans;

  }

  Future<List<Follows>>  GetFriends2(context,id)async {

    try {
      Response response2 = await dio.get(
        '/api/Getmyfrinds/$id',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Follow'] ;
        print(response2.data['Follow'] );
        list.forEach((element) {
          Myfans.add(Follows.fromJson(element));
        });
        print(Myfans );
 
      }
    } catch (e) {
      print(e);
      
    }

    return Myfans;

  }


  Future<bool> ReturnFollow({senderid, context})async{
    bool states=false;
    try {
      var  map={
        "user_id":UserId.toString(),
        "sender_id":senderid.toString()
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = new FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/ReturnFollow',
        data: formData,
      );
       
      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
    }
    return states;
  }
  Future<bool> RemoveFollow({followid, context})async{
    bool states=false;
    try {
      var  map={
        "follow_id":followid.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = new FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/RemoveFollow',
        data: formData,
      );
       
      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
    }

    return states;
  }
  Future<bool> RemoveUserFollow({Userid, context})async{
    bool states=false;
    try {
      var  map={
        "user_id":Userid.toString(),
        "sender_id":UserId.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = new FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/RemoveUserFollow',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);
    }

    return states;
  }

  Future<bool> SentFollow({userid, context,Sender})async{
    bool states=false;
    try {
      var  map={
        "user_id":userid.toString(),
        "sender_id":Sender.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = new FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/Followuser',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);

    }

    return states;
  }
  Future<bool> RemoveFollowRoom({userid, context,Sender})async{
    bool states=false;
    try {
      var  map={
        "user_id":userid.toString(),
        "sender_id":Sender.toString(),
      };
      map.removeWhere((key, value) => key == null || value == null);
      FormData formData = new FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/RemoveFollowRoom',
        data: formData,
      );

      if (response2.statusCode == 200||response2.statusCode == 201) {
        states=true;
      }else{
        states=false;
      }
    } catch (e) {
      print(e);

    }

    return states;
  }
}
