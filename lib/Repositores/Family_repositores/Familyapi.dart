

import 'dart:io';

import 'package:ahlachat/Repositores/Moment_repositores/Moment_repository.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/FamilyRequest.dart';
import 'package:ahlachat/models/FamilyRequestModel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/models/RoomModel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/Dialogs.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Familyapi extends MomentRepository {

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
  List<FamilyModel> AllFamily=[];
  FamilyModel  FamilyProfile=FamilyModel();

  List<FamilyRequest>RequestesFamily=[];
  List<usermodel> FamilyMembers=[];
  final ImagePicker _picker= ImagePicker();
  Future<List<FamilyModel>>  SearchFamily( tittle)async {

    try {
      Response response2 = await dio.get(
        '/api/SearchFAmily/$tittle',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Family'];
        list.forEach((element) {
          AllFamily.add(FamilyModel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
    }

    return AllFamily;

  }
  Future getImageGalary() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!= null) {
      var  Signupimage = File(pickedFile.path);
      print(Signupimage);
      return Signupimage;
    } else {
      print('No image selected.');
    }
  }
  Future<ListoflEaderboardcategory?>GetMembersLeaderboard( id)async {
    ListoflEaderboardcategory ? Leaderboardsupported;
    try {
      Response response2 = await dio.get(
        '/api/GetFamilyStar/$id',
      );
      if (response2.statusCode == 200) {


        Leaderboardsupported=ListoflEaderboardcategory.fromJson(response2.data['Leaderboard']['supporter']);



      }
    } catch (e) {
print(e);
    }

    return Leaderboardsupported ;

  }
  Future<FamilyModel>  GetFamilyProfile({id})async {


    try {
      Response response2 = await dio.get(
        '/api/GetFamilyProfile/$id',
      );
print(response2.data);
      if (response2.statusCode == 200) {



          FamilyProfile=FamilyModel.fromJson(response2.data['Family'] );


      }
    } catch (e) {
print(e);
    }

    return FamilyProfile;

  }




  Future<List<FamilyRequest>>  GetFamilyRequest( id)async {


    try {
      Response response2 = await dio.get(
        '/api/GetRequestFamily/$id',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Families'] ;

        list.forEach((element) {
          RequestesFamily.add(FamilyRequest.fromJson(element));
        });

      }
    } catch (e) {
      print(e);

    }

    return RequestesFamily;

  }
  Future<List<usermodel>>  GetFamilyMembers( id)async {


    try {
      Response response2 = await dio.get(
        '/api/GetFamilyMembers/$id',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['users'] ;

        list.forEach((element) {
          FamilyMembers.add(usermodel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);

    }

    return FamilyMembers;

  }


  Future<bool>  EditFamilyNames( id,name)async {


    var send=false;
    try {
      Response response2 = await dio.get(
        '/api/EditFamilyyName/$id/$name',
      );

      if (response2.statusCode == 200) {
       send=true;
      }
    } catch (e) {
      print(e);
      send=false;
    }

    return send;

  }
  Future<bool>  ExchangeFamily( id)async {


    var send=false;
    try {
      Response response2 = await dio.get(
        '/api/ExchangeFamilyCoins/$id',
      );

      if (response2.statusCode == 200) {
        send=true;
      }
    } catch (e) {
      print(e);
      send=false;
    }

    return send;

  }
  Future<bool> SentjoinRequesr({ context,  familyid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":UserId,
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/joinFamily',
        data: formData,
      );
print(response2.data);
      if (response2.statusCode == 200) {
        LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

        FamilyRequestModel Requtest  = FamilyRequestModel.fromJson(response2.data['Families'])  ;
        user.AddFamilyRequest(Requtest.familyId??0);
        print(Requtest.id);
        send=true;
       }else{

        send=false;
      }
    } catch (e) {
      print(e);

    }

    return send;
  }
  Future<FamilyModel> CreateFamily({ context,name,describtion,image}) async {

    FamilyModel Requtest=FamilyModel();
    try {
      FormData formData =   FormData.fromMap({
        "user_id":UserId,
        "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),

        "describtion": describtion.toString(),
        "name": name.toString(),
      });

      Response response2 = await dio.post(
        'api/CreateFamily',
        data: formData,
      );
      print(response2.data);
      if (response2.statusCode == 200) {


         Requtest  = FamilyModel.fromJson(response2.data['Families'])  ;

         
      }
    } catch (e) {
      print(e);


    }

    return Requtest;
  }


  Future<bool> LeaveMyFamily({ context,  familyid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":UserId,
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/LeaveFamily',
        data: formData,
      );
      print(response2.data);
      if (response2.statusCode == 200) {
        LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);

        user.LeaveFamily(familyid);

        send=true;

      }else{

        send=false;
      }
    } catch (e) {
      print(e);


    }

    return send;
  }
  Future<bool> RemoveFamilyMember({ userid,  familyid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":userid,
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/LeaveFamily',
        data: formData,
      );
      print(response2.data);
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
  Future<bool> AcceptFamilyRequest({   joinid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({

        "join_id": joinid.toString(),

      });

      Response response2 = await dio.post(
        'api/Acceptjoin',
        data: formData,
      );
      print(response2.data);
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



  Future<bool> RemoveAdmin({ context,  familyid,id}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":id.toString(),
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/RemoveAdmin',
        data: formData,
      );
      print(response2.data);
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

  Future<bool> AddAdmin({ context,  familyid,id}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":id.toString(),
        "Family_id": familyid.toString(),

      });

      Response response2 = await dio.post(
        'api/AddAdmins',
        data: formData,
      );
      print(response2.data);
      if (response2.statusCode == 200) {
        LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);



        send=true;
         
      }else{

        send=false;
      }
    } catch (e) {
      print(e);

    }

    return send;
  }
  Future<bool> CanclejoinRequesr({    Familyid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":UserId,
        "family_id":Familyid,

      });

      Response response2 = await dio.post(
        'api/Canclejoin',
        data: formData,
      );
      print(response2.data);
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
  Future<bool> CancleMemberjoinRequesr({    Familyid,userid}) async {

    var send=true;
    try {
      FormData formData =   FormData.fromMap({
        "user_id":userid,
        "family_id":Familyid,

      });

      Response response2 = await dio.post(
        'api/Canclejoin',
        data: formData,
      );
      print(response2.data);
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

}
