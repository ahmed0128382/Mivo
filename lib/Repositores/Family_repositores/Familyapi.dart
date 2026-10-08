import 'dart:io';

import 'package:ahlachat/Repositores/Moment_repositores/Moment_repository.dart';
import 'package:ahlachat/models/FamilyModel.dart';
import 'package:ahlachat/models/FamilyRequest.dart';
import 'package:ahlachat/models/FamilyRequestModel.dart';
import 'package:ahlachat/models/Leaderboardusermodel.dart';
import 'package:ahlachat/models/Usermodel.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';

class Familyapi extends MomentRepository {
  final Dio _dio = ApiClient.instance.dio;

  final List<FamilyModel> AllFamily = [];
  FamilyModel FamilyProfile = FamilyModel();

  final List<FamilyRequest> RequestesFamily = [];
  final List<usermodel> FamilyMembers = [];

  final ImagePicker _picker = ImagePicker();

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;

      return ApiException(
        statusCode: response?.statusCode,
        message: response?.data?['message']?.toString() ??
            response?.data?['error']?.toString() ??
            error.message ??
            'Something went wrong',
        data: response?.data,
      );
    }

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }

  Future<List<FamilyModel>> SearchFamily(tittle) async {
    try {
      final response = await _dio.get(
        '/api/SearchFAmily/$tittle',
      );

      final List list = response.data['Family'] ?? [];

      AllFamily.clear();

      for (final element in list) {
        AllFamily.add(
          FamilyModel.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return AllFamily;
  }

  Future getImageGalary() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final Signupimage = File(pickedFile.path);

      print(Signupimage);

      return Signupimage;
    } else {
      print('No image selected.');
    }
  }

  Future<ListoflEaderboardcategory?> GetMembersLeaderboard(id) async {
    ListoflEaderboardcategory? Leaderboardsupported;

    try {
      final response = await _dio.get(
        '/api/GetFamilyStar/$id',
      );

      Leaderboardsupported =
          ListoflEaderboardcategory.fromJson(
        response.data['Leaderboard']['supporter'],
      );
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Leaderboardsupported;
  }

  Future<FamilyModel> GetFamilyProfile({id}) async {
    try {
      final response = await _dio.get(
        '/api/GetFamilyProfile/$id',
      );

      print(response.data);

      FamilyProfile = FamilyModel.fromJson(
        response.data['Family'],
      );
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return FamilyProfile;
  }

  Future<List<FamilyRequest>> GetFamilyRequest(id) async {
    try {
      final response = await _dio.get(
        '/api/GetRequestFamily/$id',
      );

      final List list = response.data['Families'] ?? [];

      RequestesFamily.clear();

      for (final element in list) {
        RequestesFamily.add(
          FamilyRequest.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return RequestesFamily;
  }

  Future<List<usermodel>> GetFamilyMembers(id) async {
    try {
      final response = await _dio.get(
        '/api/GetFamilyMembers/$id',
      );

      final List list = response.data['users'] ?? [];

      FamilyMembers.clear();

      for (final element in list) {
        FamilyMembers.add(
          usermodel.fromJson(element),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return FamilyMembers;
  }

  Future<bool> EditFamilyNames(id, name) async {
    try {
      final response = await _dio.get(
        '/api/EditFamilyyName/$id/$name',
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> ExchangeFamily(id) async {
    try {
      final response = await _dio.get(
        '/api/ExchangeFamilyCoins/$id',
      );

      return response.statusCode == 200;
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      return false;
    }
  }

  Future<bool> SentjoinRequesr({
    context,
    familyid,
  }) async {
    var send = true;

    try {
      final formData = FormData.fromMap({
        'user_id': UserId,
        'Family_id': familyid.toString(),
      });

      final response = await _dio.post(
        'api/joinFamily',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        final LoginViewmodel user =
            Provider.of<LoginViewmodel>(
          context,
          listen: false,
        );

        final FamilyRequestModel Requtest =
            FamilyRequestModel.fromJson(
          response.data['Families'],
        );

        user.AddFamilyRequest(
          Requtest.familyId ?? 0,
        );

        print(Requtest.id);

        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      send = false;
    }

    return send;
  }

  Future<FamilyModel> CreateFamily({
    context,
    name,
    describtion,
    image,
  }) async {
    FamilyModel Requtest = FamilyModel();

    try {
      final formData = FormData.fromMap({
        'user_id': UserId,
        'image': await MultipartFile.fromFile(
          image?.path,
          filename: image?.path?.split('/').last,
        ),
        'describtion': describtion.toString(),
        'name': name.toString(),
      });

      final response = await _dio.post(
        'api/CreateFamily',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        Requtest = FamilyModel.fromJson(
          response.data['Families'],
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);
    }

    return Requtest;
  }

  Future<bool> LeaveMyFamily({
    context,
    familyid,
  }) async {
    var send = true;

    try {
      final formData = FormData.fromMap({
        'user_id': UserId,
        'Family_id': familyid.toString(),
      });

      final response = await _dio.post(
        'api/LeaveFamily',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        final LoginViewmodel user =
            Provider.of<LoginViewmodel>(
          context,
          listen: false,
        );

        user.LeaveFamily(familyid);

        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      send = false;
    }

    return send;
  }

  Future<bool> RemoveFamilyMember({
    userid,
    familyid,
  }) async {
    var send = true;

    try {
      final formData = FormData.fromMap({
        'user_id': userid,
        'Family_id': familyid.toString(),
      });

      final response = await _dio.post(
        'api/LeaveFamily',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      send = false;
    }

    return send;
  }

  Future<bool> AcceptFamilyRequest({
    joinid,
  }) async {
    var send = true;

    try {
      final formData = FormData.fromMap({
        'join_id': joinid.toString(),
      });

      final response = await _dio.post(
        'api/Acceptjoin',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      send = false;
    }

    return send;
  }

  Future<bool> RemoveAdmin({
    context,
    familyid,
    id,
  }) async {
    var send = true;

    try {
      final formData = FormData.fromMap({
        'user_id': id.toString(),
        'Family_id': familyid.toString(),
      });

      final response = await _dio.post(
        'api/RemoveAdmin',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      send = false;
    }

    return send;
  }

  Future<bool> AddAdmin({
    context,
    familyid,
    id,
  }) async {
    var send = true;

    try {
      final formData = FormData.fromMap({
        'user_id': id.toString(),
        'Family_id': familyid.toString(),
      });

      final response = await _dio.post(
        'api/AddAdmins',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        final LoginViewmodel user =
            Provider.of<LoginViewmodel>(
          context,
          listen: false,
        );

        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      send = false;
    }

    return send;
  }

  Future<bool> CanclejoinRequesr({
    Familyid,
  }) async {
    var send = true;

    try {
      final formData = FormData.fromMap({
        'user_id': UserId,
        'family_id': Familyid,
      });

      final response = await _dio.post(
        'api/Canclejoin',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      send = false;
    }

    return send;
  }

  Future<bool> CancleMemberjoinRequesr({
    Familyid,
    userid,
  }) async {
    var send = true;

    try {
      final formData = FormData.fromMap({
        'user_id': userid,
        'family_id': Familyid,
      });

      final response = await _dio.post(
        'api/Canclejoin',
        data: formData,
      );

      print(response.data);

      if (response.statusCode == 200) {
        send = true;
      } else {
        send = false;
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      send = false;
    }

    return send;
  }
}