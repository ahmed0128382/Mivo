
import 'package:ahlachat/models/JoinRequestModel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import '../../models/AgencyModel.dart';
import '../../models/Joinagency.dart';
import '../../models/Usermodel.dart';
import '../../util/Dialogs.dart';
import '../../util/app_constants.dart';
import '../Moment_repositores/Moment_repository.dart';

int Indexxx=2;
int Indexxx2=2;
class Agencyapi extends MomentRepository {
  List<Agencymodel> Agences=[];
  List<joinagincy> joinagincys=[];
  List<usermodel> useragincys=[];
  List<Agencymodel> Searchagency=[];
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
  Future<bool>  EditAgencyNames( id,name)async {


    var send=false;
    try {
      Response response2 = await dio.get(
        '/api/EditAgencyName/$id/$name',
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

  List<JoinRequestModel> JoinRequestes=[];
  Future<List<JoinRequestModel>>  GetJoinRequests({id})async {

    try {
      Response response2 = await dio.get(
        '/api/GetJoinRequests/$id',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['request'];
        list.forEach((element) {
          JoinRequestes.add(JoinRequestModel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
    }

    return JoinRequestes;

  }

  Future<bool> AcceptJoinRequests({id})async{
    bool suceed=false;
    try {

      Response response2 = await dio.get(
        '/api/AcceptJoinRequests/$id',
      );
      if (response2.statusCode == 200 || response2.statusCode == 201) {


        suceed=true;


      }else{
        suceed=false;
      }

    } catch (e) {
      suceed=false;

    }


    return suceed;

  }

  Future<bool> refuseJoinRequests({id})async{
    bool suceed=false;
    try {

      Response response2 = await dio.get(
        '/api/refuseJoinRequests/$id',
      );
      if (response2.statusCode == 200 || response2.statusCode == 201) {


        suceed=true;


      }else{
        suceed=false;
      }

    } catch (e) {
      suceed=false;

    }


    return suceed;

  }


  Future<List<Agencymodel>>  Agency(context)async {

    Indexxx=2;
    try {
      Response response2 = await dio.get(
        '/api/GetAgency',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Agency']['data'];

        list.forEach((element) {
          Agences.add(Agencymodel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
    }

    return Agences;

  }

  Future<List<Agencymodel>>  AgencyImportant(context)async {


    try {
      Response response2 = await dio.get(
        '/api/GetImportantAgancy',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Agency'];

        list.forEach((element) {
          Agences.add(Agencymodel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
    }

    return Agences;

  }

  Future<List<usermodel>>  JoinAgency({context, id})async {

    Indexxx2=2;
    try {
      Response response2 = await dio.get(
        '/api/GetJoinAgency/$id/$UserId',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Agency']['Members']['data'];
        Provider.of<LoginViewmodel>(context,listen: false).updateMenuit(response2.data['Agency']['menuit']);
        list.forEach((element) {
          useragincys.add(usermodel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
    }

    return useragincys;

  }
  Future<List<Agencymodel>>  AddmoreAgency(context)async {
     try {
      Response response2 = await dio.get(
        '/api/GetAgency?page=${Indexxx.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Agency']['data'];

        if(list.isNotEmpty){
          Indexxx=Indexxx+1;

        }
        print("INDEX IS $Indexxx");
        list.forEach((element){
          Agences.add(Agencymodel.fromJson(element));
        });
        print(Agences);
      }
    } catch (e) {
       print(e);
    }

    return Agences;

  }
  Future<List<usermodel>>  AddmoreAgencyMembers(context,id)async {
     try {
      Response response2 = await dio.get(
        '/api/GetJoinAgency/${id.toString()}?page=${Indexxx2.toString()}',
      );

      if (response2.statusCode == 200) {

        List list =response2.data['Agency']['data'];
        print('Getten List is list');
        print(list);
        print('Getten List is list');
        if(list.isNotEmpty){
          Indexxx2=Indexxx2+1;
          print("INDEX IS $Indexxx2");
          print("INDEX IS ${Indexxx2+1}");
        }
        print("INDEX IS $Indexxx2");
        list.forEach((element){
          useragincys.add(usermodel.fromJson(element));
        });
        print(joinagincys);
      }
    } catch (e) {
       print(e);
    }

    return useragincys;

  }

  Future<List<Agencymodel>>  SearchAgency({tittle})async {

    try {
      Response response2 = await dio.get(
        '/api/SearchAgency/$tittle',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['Agency'];
        list.forEach((element) {
          Searchagency.add(Agencymodel.fromJson(element));
        });

      }
    } catch (e) {
      print(e);
    }

    return Searchagency;

  }

  AgencyLeaderBoard Leader=AgencyLeaderBoard();
  Future<AgencyLeaderBoard>  GetAgencyLeaderBoard(context,tittle)async {

    try {
      Response response2 = await dio.get(
        '/api/AgencysLeaderBoard',
      );

      if (response2.statusCode == 200) {


        Leader=AgencyLeaderBoard.fromJson(response2.data['Leaderboard']);
      }
    } catch (e) {
      print(e);
    }

    return Leader;

  }


  Future<bool> LeaveAgency({context,Agancyid}) async {
    bool check=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "agancy_id": Agancyid.toString(),

      });

      Response response2 = await dio.post(
        'api/LeaveAgency',
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
    }

    return check;
  }

  Future<bool> RequsetJoinAgency({context,Agancyid}) async {
    bool check=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "agancy_id": Agancyid.toString(),

      });

      Response response2 = await dio.post(
        'api/RequestJoinAgency',
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

    }

    return check;
  }

}
