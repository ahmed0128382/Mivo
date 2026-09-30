import 'dart:async';
import 'dart:io';

import 'package:ahlachat/Repositores/Shop_repositores/ShopRepository.dart';
import 'package:ahlachat/models/RelationModel.dart';
import 'package:dio/dio.dart';

import '../../models/MyItemModel.dart';
import '../../models/ShopModel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';



class Relationapi extends ShopRepository {



  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: {
        'Accept': 'application/json',
        'Authorization':Token,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ),
  );


  List<RelationModel> UserRelations=[];

  Future<int> SendRelations({user_id,Relationid,context}) async {
    int check=0;

    try {
      FormData formData = new FormData.fromMap({
        "sender_id": UserId.toString(),
        "user_id": user_id.toString(),
        "Relation_id": Relationid.toString(),

      });

      Response response2 = await dio.post(
        'api/SendRelation',
        data: formData,
      );

      if (response2.statusCode == 200) {

        if(response2.data['status']=="done"){

          check=1;
        }else{
          Dialogs().showtoast('لقد قمت بارسالها من قبل');
          check=2;
        }

      }else{

        check=0;
      }
    } catch (e) {
      check=0;


    }

    return check;
  }

  Future<bool> RemoveRelations({id,context}) async {
    bool check=false;

    try {
      FormData formData = new FormData.fromMap({
        "id": id.toString(),
      });

      Response response2 = await dio.post(
        'api/RemoveRelation',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check=true;


      }else{

        check=false;
      }
    } catch (e) {
      check=false;


    }

    return check;
  }
  Future<bool> AcceptRelations({id,userid,context}) async {
    bool check=false;

    print(id.toString());
    print(userid.toString());
    try {
      FormData formData = new FormData.fromMap({
        "id": id.toString(),
        "user_id":UserId.toString()
      });

      Response response2 = await dio.post(
        'api/AcceptRelation',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check=true;


      }else{

        check=false;
      }
    } catch (e) {
      check=false;


    }

    return check;
  }

  Future<bool> LeaveRelations({id,context}) async {
    bool check=false;

    print(id.toString());

    try {
      FormData formData = new FormData.fromMap({
        "id": id.toString(),
        "user_id":UserId.toString()
      });

      Response response2 = await dio.post(
        'api/LeaveRelation',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check=true;


      }else{

        check=false;
      }
    } catch (e) {
      check=false;


    }

    return check;
  }


  Future<List<RelationModel> >  GetUserRelation({context})async {
    try {
      Response response2 = await dio.get(
        '/api/UserRelations/$UserId',
      );
print(response2.data);
      if (response2.statusCode == 200) {
        List list =response2.data;

        list.forEach((element) {
          UserRelations.add(RelationModel.fromJson(element));
        });


      }
    } catch (e) {
      print(e);

    }

    return UserRelations;

  }






  Future<bool> SendByeShop({itemId,day,price,userid, context,categoryid}) async {
    bool check=false;

    try {
      FormData formData = new FormData.fromMap({
        "item_id": itemId.toString(),
        "user_id": UserId.toString(),
        "reciver":userid.toString(),
        "day": day.toString(),
        "price": price.toString(),
        "category_id":categoryid.toString(),
      });

      Response response2 = await dio.post(
        'api/SendItem',
        data: formData,
      );

      if (response2.statusCode == 200) {
        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;

    }

    return check;
  }

  Future<bool> RemoveFrame({context}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),


      });

      Response response2 = await dio.post(
        'api/removeframe',
        data: formData,
      );

      if (response2.statusCode == 200) {

        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }

}
