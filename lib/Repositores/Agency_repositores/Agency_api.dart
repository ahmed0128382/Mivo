import 'package:ahlachat/models/JoinRequestModel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:provider/provider.dart';

import '../../models/AgencyModel.dart';
import '../../models/Joinagency.dart';
import '../../models/Usermodel.dart';
import '../../core/network/api_client.dart';
import '../Moment_repositores/Moment_repository.dart';

int Indexxx = 2;
int Indexxx2 = 2;

class Agencyapi extends MomentRepository {
  final _dio = ApiClient.instance.dio;

  final List<Agencymodel> Agences = [];
  final List<joinagincy> joinagincys = [];
  final List<usermodel> useragincys = [];
  final List<Agencymodel> Searchagency = [];
  final List<JoinRequestModel> JoinRequestes = [];

  AgencyLeaderBoard Leader = AgencyLeaderBoard();

  Future<bool> EditAgencyNames(id, name) async {
    try {
      await _dio.get(
        '/api/EditAgencyName/$id/$name',
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<JoinRequestModel>> GetJoinRequests({id}) async {
    try {
      final response = await _dio.get(
        '/api/GetJoinRequests/$id',
      );

      final List list = response.data['request'] ?? [];

      JoinRequestes.clear();

      for (final element in list) {
        JoinRequestes.add(
          JoinRequestModel.fromJson(element),
        );
      }
    } catch (e) {
      print(e);
    }

    return JoinRequestes;
  }

  Future<bool> AcceptJoinRequests({id}) async {
    try {
      await _dio.get(
        '/api/AcceptJoinRequests/$id',
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> refuseJoinRequests({id}) async {
    try {
      await _dio.get(
        '/api/refuseJoinRequests/$id',
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Agencymodel>> Agency(context) async {
    Indexxx = 2;

    try {
      final response = await _dio.get(
        '/api/GetAgency',
      );

      final List list = response.data['Agency']['data'] ?? [];

      Agences.clear();

      for (final element in list) {
        Agences.add(
          Agencymodel.fromJson(element),
        );
      }
    } catch (e) {
      print(e);
    }

    return Agences;
  }

  Future<List<Agencymodel>> AgencyImportant(context) async {
    try {
      final response = await _dio.get(
        '/api/GetImportantAgancy',
      );

      final List list = response.data['Agency'] ?? [];

      Agences.clear();

      for (final element in list) {
        Agences.add(
          Agencymodel.fromJson(element),
        );
      }
    } catch (e) {
      print(e);
    }

    return Agences;
  }

  Future<List<usermodel>> JoinAgency({
    context,
    id,
  }) async {
    Indexxx2 = 2;

    try {
      final response = await _dio.get(
        '/api/GetJoinAgency/$id/$UserId',
      );

      final List list =
          response.data['Agency']['Members']['data'] ?? [];

      useragincys.clear();

      Provider.of<LoginViewmodel>(
        context,
        listen: false,
      ).updateMenuit(
        response.data['Agency']['menuit'],
      );

      for (final element in list) {
        useragincys.add(
          usermodel.fromJson(element),
        );
      }
    } catch (e) {
      print(e);
    }

    return useragincys;
  }

  Future<List<Agencymodel>> AddmoreAgency(context) async {
    try {
      final response = await _dio.get(
        '/api/GetAgency?page=$Indexxx',
      );

      final List list = response.data['Agency']['data'] ?? [];

      if (list.isNotEmpty) {
        Indexxx++;
      }

      print('INDEX IS $Indexxx');

      for (final element in list) {
        Agences.add(
          Agencymodel.fromJson(element),
        );
      }

      print(Agences);
    } catch (e) {
      print(e);
    }

    return Agences;
  }

  Future<List<usermodel>> AddmoreAgencyMembers(
    context,
    id,
  ) async {
    try {
      final response = await _dio.get(
        '/api/GetJoinAgency/$id?page=$Indexxx2',
      );

      final List list = response.data['Agency']['data'] ?? [];

      print('Getten List is list');
      print(list);

      if (list.isNotEmpty) {
        Indexxx2++;
        print('INDEX IS $Indexxx2');
      }

      for (final element in list) {
        useragincys.add(
          usermodel.fromJson(element),
        );
      }

      print('INDEX IS $Indexxx2');
    } catch (e) {
      print(e);
    }

    return useragincys;
  }

  Future<List<Agencymodel>> SearchAgency({tittle}) async {
    try {
      final response = await _dio.get(
        '/api/SearchAgency/$tittle',
      );

      final List list = response.data['Agency'] ?? [];

      Searchagency.clear();

      for (final element in list) {
        Searchagency.add(
          Agencymodel.fromJson(element),
        );
      }
    } catch (e) {
      print(e);
    }

    return Searchagency;
  }

  Future<AgencyLeaderBoard> GetAgencyLeaderBoard(
    context,
    tittle,
  ) async {
    try {
      final response = await _dio.get(
        '/api/AgencysLeaderBoard',
      );

      Leader = AgencyLeaderBoard.fromJson(
        response.data['Leaderboard'],
      );
    } catch (e) {
      print(e);
    }

    return Leader;
  }

  Future<bool> LeaveAgency({
    context,
    Agancyid,
  }) async {
    try {
      final response = await _dio.post(
        '/api/LeaveAgency',
        data: {
          'user_id': UserId.toString(),
          'agancy_id': Agancyid.toString(),
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> RequsetJoinAgency({
    context,
    Agancyid,
  }) async {
    try {
      final response = await _dio.post(
        '/api/RequestJoinAgency',
        data: {
          'user_id': UserId.toString(),
          'agancy_id': Agancyid.toString(),
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}