part of 'user_api.dart';

// Session restore, logout, constants
mixin UserApiSession on _UserApiBase {
  @override
  checklogin(context) async {
    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    Token = prefs.getString('token');

    // FlutterNativeSplash.remove();

    if (Token == null ||
        Token!.trim().isEmpty) {
      Navigator.pushNamed(
        context,
        AppConstants.Login_Screan,
      );
    } else {
      try {
       var datauser = prefs.getString('UserData');

debugPrint('========== INITIAL COUNTS: SharedPreferences ==========');
debugPrint('Source: SharedPreferences -> UserData');
debugPrint('UserData exists: ${datauser != null}');
debugPrint('Raw UserData: $datauser');

if (datauser != null) {
  final Map<String, dynamic> decodedData =
      jsonDecode(datauser) as Map<String, dynamic>;

  debugPrint('Cached user ID: ${decodedData['id']}');
  debugPrint('Cached friends count: ${decodedData['friends']}');
  debugPrint('Cached visitors count: ${decodedData['visitors']}');
}

debugPrint('=======================================================');

        

        if (datauser == null ||
            datauser.isEmpty) {
          await prefs.remove('token');

          Token = null;

          Navigator.pushNamed(
            context,
            AppConstants.Login_Screan,
          );

          return;
        }

        userinfo =
            usermodel.fromJson(
          jsonDecode(datauser),
        );

        UserId =
            userinfo.id.toString();

        Provider.of<LoginViewmodel>(
          context,
          listen: false,
        ).MyUSERINFO(userinfo);

        Provider.of<LoginViewmodel>(
          context,
          listen: false,
        ).waitingConstDate(context);

        Navigator.pushNamed(
          context,
          AppConstants.Buttom_Navigation,
        );

        Provider.of<LoginViewmodel>(
          context,
          listen: false,
        ).userinformation(
          context: context,
        );
      } catch (e) {
        print(
          'checklogin restore error: $e',
        );

        if (Token != null &&
            Token!.trim().isNotEmpty) {
          Navigator.pushNamed(
            context,
            AppConstants.Buttom_Navigation,
          );
        } else {
          Navigator.pushNamed(
            context,
            AppConstants.Login_Screan,
          );
        }
      }
    }
  }

  Future<bool> SignOut({
    context,
  }) async {
    final SharedPreferences prefs =
        await SharedPreferences
            .getInstance();

    // Save current values BEFORE clearing them.
    final String logoutUserId =
        UserId?.toString() ?? '';

    final String logoutToken =
        Token?.toString() ?? '';

    final String logoutUserIP =
        UserIP?.toString() ?? '';

    print('');
    print(
      '========== LOGOUT ==========',
    );
    print(
      'USER ID: $logoutUserId',
    );
    print(
      'TOKEN PRESENT: '
      '${logoutToken.isNotEmpty}',
    );
    print(
      'TOKEN LENGTH: '
      '${logoutToken.length}',
    );
    print(
      'DEVICE ID: $deviceId',
    );
    print(
      'USER IP: $logoutUserIP',
    );
    print(
      'awqeASERQW: 8/325*mAIOEN',
    );
    print(
      '============================',
    );

    try {
      final Response response =
          await dio.post(
        '/api/logout',
        data: FormData.fromMap({
          'user_id': logoutUserId,
        }),
        options: Options(
          headers: {
            // Keep explicit logout headers.
            // ApiInterceptors will also apply the same
            // current session headers automatically.
            'awqeASERQW': '8/325*mAIOEN',
            'Authorization': logoutToken,
            'userid': logoutUserId,
            'UserIP': logoutUserIP,
            'DeviceId': deviceId,
            'Accept': 'application/json',
          },
        ),
      );

      print(
        'LOGOUT RESPONSE STATUS: '
        '${response.statusCode}',
      );

      print(
        'LOGOUT RESPONSE DATA: '
        '${response.data}',
      );

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      final exception = _handleError(e);

      print(
        'LOGOUT ERROR: $exception',
      );

      if (e is DioException) {
        print(
          'LOGOUT STATUS: '
          '${e.response?.statusCode}',
        );

        print(
          'LOGOUT RESPONSE: '
          '${e.response?.data}',
        );
      }

      return false;
    } finally {
      // Clear local session AFTER the logout request.
      await prefs.remove('token');
      await prefs.remove('uuid');
      await prefs.remove('UserData');

      Token = null;
      UserId = null;
      UserIP = null;
      userinfo = usermodel();

      print(
        'LOCAL SESSION CLEARED',
      );

      print(
        '============================',
      );
    }
  }

  getAllconstant(context) async {
    try {
      final response = await dio.get(
        'api/GetConstData',
      );

      print(
        'GET CONST DATA: '
        'status=${response.statusCode}',
      );

      print(
        'GET CONST DATA: '
        'dataType=${response.data.runtimeType}',
      );

      print(
        'GET CONST DATA: '
        'data=${response.data}',
      );

      return response.data;
    } on DioException catch (
      exception
    ) {
      final apiException =
          _handleError(exception);

      print(
        'GET CONST DATA DIO ERROR: '
        '${exception.type}',
      );

      print(
        'GET CONST DATA STATUS: '
        '${exception.response?.statusCode}',
      );

      print(
        'GET CONST DATA RESPONSE: '
        '${exception.response?.data}',
      );

      print(
        'GET CONST DATA MESSAGE: '
        '${exception.message}',
      );

      print(apiException);

      return null;
    } catch (
      exception,
      stackTrace
    ) {
      print(
        'GET CONST DATA ERROR: '
        '$exception',
      );

      print(
        'GET CONST DATA STACKTRACE: '
        '$stackTrace',
      );

      return null;
    }
  }

}
