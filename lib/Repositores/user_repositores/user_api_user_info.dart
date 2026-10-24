part of 'user_api.dart';

// Fetching user info / profile data
mixin UserApiUserInfo on _UserApiBase {
  Future<usermodel> userinfoRoom({
    id,
    roomid,
    context,
  }) async {
    print(
      '=============================>$roomid',
    );

    print(
      '=============================>$id',
    );

    try {
      Response response2 = await dio.get(
        '/api/getuserRoom/$id/$roomid',
      );

      print(userinfo);

      if (response2.statusCode == 200) {
        userinfo =
            usermodel.fromJson(
          response2.data['users'],
        );
        debugPrint('========== INITIAL COUNTS: Userinfo API ==========');
debugPrint('Source: POST /api/userinfo');
debugPrint('Raw users JSON: ${response2.data['users']}');
debugPrint('User ID: ${userinfo.id}');
debugPrint('Friends count: ${userinfo.friends}');
debugPrint('Visitors count: ${userinfo.visitors}');
debugPrint('==================================================');
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }
      }
    }

    print(userinfo);

    return userinfo;
  }

  Future<usermodel> UserProfileData({
    id,
    context,
  }) async {
    try {
      Response response2 = await dio.get(
        '/api/UserProfileData/$id/$UserId',
      );

      if (response2.statusCode == 200) {
        userinfo =
            usermodel.fromJson(
          response2.data['users'],
        );
        debugPrint('========== INITIAL COUNTS: Userinfo API ==========');
debugPrint('Source: POST /api/userinfo');
debugPrint('Raw users JSON: ${response2.data['users']}');
debugPrint('User ID: ${userinfo.id}');
debugPrint('Friends count: ${userinfo.friends}');
debugPrint('Visitors count: ${userinfo.visitors}');
debugPrint('==================================================');
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }
      }
    }

    print(userinfo);

    return userinfo;
  }

  Future<usermodel> Userinfo({
    context,
  }) async {
    try {
      FormData formData =
          FormData.fromMap({
        "": '',
      });

      Response response2 = await dio.post(
        '/api/userinfo',
        data: formData,
      );

      if (response2.statusCode == 200) {
        userinfo =
            usermodel.fromJson(
          response2.data['users'],
        );
        debugPrint('========== INITIAL COUNTS: Userinfo API ==========');
debugPrint('Source: POST /api/userinfo');
debugPrint('Raw users JSON: ${response2.data['users']}');
debugPrint('User ID: ${userinfo.id}');
debugPrint('Friends count: ${userinfo.friends}');
debugPrint('Visitors count: ${userinfo.visitors}');
debugPrint('==================================================');

        final newToken =
            (userinfo.rememperToken ?? '')
                .toString();

        UserId =
            userinfo.id.toString();

        if (newToken.isNotEmpty) {
          Token = newToken;

          SharedPreferences prefs =
              await SharedPreferences
                  .getInstance();

          await prefs.setString(
            'token',
            newToken,
          );
        }

        SharedPreferences prefs =
            await SharedPreferences.getInstance();

        await prefs.setString(
          'UserData',
          jsonEncode(
            response2.data['users'],
          ),
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      Navigator.pushNamed(
        context,
        AppConstants.Login_Screan,
      );
    }

    return userinfo;
  }

  Future<usermodel> UserinfoID({
    ID,
    context,
  }) async {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    try {
      Response response2 = await dio.get(
        '/api/userinformation/'
        '${ID.toString()}/'
        '${user.userinfo?.id.toString()}',
      );

      if (response2.statusCode == 200) {
        userinfo =
            usermodel.fromJson(
          response2.data['users'],
        );
        debugPrint('========== INITIAL COUNTS: Userinfo API ==========');
debugPrint('Source: POST /api/userinfo');
debugPrint('Raw users JSON: ${response2.data['users']}');
debugPrint('User ID: ${userinfo.id}');
debugPrint('Friends count: ${userinfo.friends}');
debugPrint('Visitors count: ${userinfo.visitors}');
debugPrint('==================================================');
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorToast(
            errNum,
            context,
          );
        }
      }
    }

    return userinfo;
  }

}
