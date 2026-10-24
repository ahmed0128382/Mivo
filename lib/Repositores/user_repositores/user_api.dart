import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ahlachat/Repositores/user_repositores/user_repository.dart';
import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/UsarImages.dart';
import 'package:ahlachat/view/Screans/Authentication/EnterCodeScrean/EnterCodeScrean.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/LoginScrean.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/network/api_client.dart';
import '../../core/network/api_exception.dart';
import '../../models/MyVip.dart';
import '../../models/NotificationModel.dart';
import '../../models/UserGiftsmodel.dart';
import '../../models/UserMusic.dart';
import '../../models/Usermodel.dart';
import '../../models/VipModel.dart';
import '../../models/gifts.dart';
import '../../util/Dialogs.dart';
import '../../util/Localization.dart';
import '../../util/app_constants.dart';
import '../../util/helperclass.dart';
import '../../viewmodels/Auth_Viewmodel/LoginViewModel.dart';

part 'user_api_profile.dart';
part 'user_api_user_info.dart';
part 'user_api_gifts.dart';
part 'user_api_games.dart';
part 'user_api_social.dart';
part 'user_api_auth_login.dart';
part 'user_api_auth_phone.dart';
part 'user_api_session.dart';
part 'user_api_vip.dart';

/// Shared state and helpers for [userapi] mixins.
/// Mixins use `on _UserApiBase` to avoid circular inheritance.
abstract class _UserApiBase extends UserRepository {
  @override
  final _firebaseAuth = FirebaseAuth.instance;

  usermodel userinfo = usermodel();
  var Signupimage;
  MyVipmodel? myvip;

  List<Gifts> giftssent = [];
  List<Gifts> giftscollect = [];
  List<usermodel> Searchuser = [];
  List<usergifts> UserGifts = [];
  List<Notificationmodel> Notifications = [];

  final ImagePicker _picker = ImagePicker();

  final Dio dio = ApiClient.instance.dio;

  UserImages? ProfileImages;

  // ApiClient.instance.dio already has ApiInterceptors.
  // ApiInterceptors is responsible for all global headers:
  // Authorization, userid, UserIP, DeviceId, awqeASERQW, Accept.
  List<usermusic> UserMusic = [];

  InboxRoomModel? ChatRoom;

  ApiException _handleError(dynamic error) {
    if (error is DioException) {
      final response = error.response;

      dynamic responseData = response?.data;

      String? message;

      if (responseData is Map) {
        message =
            responseData['message']?.toString() ??
            responseData['error']?.toString() ??
            responseData['errNum']?.toString();
      }

      return ApiException(
        statusCode: response?.statusCode,
        message:
            message ??
            error.message ??
            'Something went wrong',
        data: responseData,
      );
    }

    return ApiException(
      message: error.toString(),
      data: error,
    );
  }
}

/// Public API implementation (same type name and surface as before).
class userapi extends _UserApiBase
    with UserApiProfile,
        UserApiUserInfo,
        UserApiGifts,
        UserApiGames,
        UserApiSocial,
        UserApiAuthLogin,
        UserApiAuthPhone,
        UserApiSession,
        UserApiVip {
  userapi();
}
