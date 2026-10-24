part of 'user_api.dart';

// Login flows (phone, Google, ID) and Google sign-in
mixin UserApiAuthLogin on _UserApiBase {
  Future<User?> Googlesignin({
    context,
  }) async {
    try {
      final googleuser = GoogleSignIn();

      print(
        'GOOGLE: opening account chooser',
      );

      final signin = await googleuser.signIn();

      if (signin == null) {
        print(
          'GOOGLE: user cancelled sign in',
        );

        return null;
      }

      print(
        'GOOGLE: account selected: ${signin.email}',
      );

      final googleAuth =
          await signin.authentication;

      print(
        'GOOGLE: idToken=${googleAuth.idToken != null}, '
        'accessToken=${googleAuth.accessToken != null}',
      );

      if (googleAuth.idToken == null) {
        print(
          'GOOGLE: idToken is null',
        );

        return null;
      }

      print(
        'ShowGlopalLoading...',
      );

      ShowGlopalLoading();

      print(
        'GOOGLE: signing into Firebase...',
      );

      final usercredentioal = await _firebaseAuth
          .signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      )
          .timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw TimeoutException(
            'Firebase Google sign-in timed out',
          );
        },
      );

      print(
        'GOOGLE FIREBASE USER: '
        '${usercredentioal.user?.uid}',
      );

      Gmail = usercredentioal.user?.email;

      final photoUrl =
          usercredentioal.user?.photoURL;

      if (photoUrl != null &&
          photoUrl.isNotEmpty) {
        final imageData =
            await NetworkAssetBundle(
          Uri.parse(photoUrl),
        ).load("");

        final Uint8List bytes =
            imageData.buffer.asUint8List();

        final byteData =
            ByteData.view(bytes.buffer);

        var tempDir =
            await getTemporaryDirectory();

        File file = await File(
          '${tempDir.path}/img',
        ).writeAsBytes(
          bytes.buffer.asUint8List(
            byteData.offsetInBytes,
            byteData.lengthInBytes,
          ),
        );

        Provider.of<LoginViewmodel>(
          context,
          listen: false,
        ).updateComimage(
          image: file,
        );
      }

      Provider.of<LoginViewmodel>(
        context,
        listen: false,
      ).UpdateUsernameComp(
        name: usercredentioal.user?.displayName,
      );

      await UserLoginGoogle(
        context: context,
        email: usercredentioal.user?.email,
      );

      return usercredentioal.user;
    } catch (e) {
      print(
        'GOOGLE SIGN-IN ERROR: $e',
      );

      DismissGlopalLoading();

      return null;
    }
  }

  Future<usermodel> UserLogin({
    Phonenumber,
    context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "phone_number": Phonenumber.toString(),
      });

      Response response2 = await dio.post(
        'api/login',
        data: formData,
      );

      if (response2.statusCode == 200) {
        if (response2.data['users'] != "E05") {
          UserId =
              response2.data['users']['id'].toString();

          if (response2.data['users']['ban'] == 1) {
            DismissGlopalLoading();

            Dialogs().showtoast(
              'تم حظر هذا الحساب',
            );

            SharedPreferences prefs =
                await SharedPreferences.getInstance();

            await prefs.clear();

            navigateTo(
              context: context,
              screen: LoginScrean(),
            );
          } else {
            Provider.of<LoginViewmodel>(
              context,
              listen: false,
            ).SendCodeRlogin(
              context: context,
              phonenumber: Phonenumber,
            );
          }
        } else {
          Provider.of<LoginViewmodel>(
            context,
            listen: false,
          ).SendCodeSignUp(
            context: context,
            phonenumber: Phonenumber,
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      DismissGlopalLoading();
    }

    return userinfo;
  }

  Future<usermodel> UserLoginGoogle({
    email,
    context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "email": email.toString(),
      });

      print(
        'GOOGLE LOGIN: email = $email',
      );

      print(
        'GOOGLE LOGIN: POST api/loginGoogle',
      );

      Response response2 = await dio.post(
        'api/loginGoogle',
        data: formData,
      );

      print(
        'GOOGLE LOGIN RESPONSE: '
        'status=${response2.statusCode}, '
        'data=${response2.data}',
      );

      if (response2.statusCode == 200) {
        if (response2.data['users'] != "E05") {
          UserId =
              response2.data['users']['id'].toString();

          if (response2.data['users']['ban'] == 1) {
            DismissGlopalLoading();

            Dialogs().showtoast(
              'تم حظر هذا الحساب',
            );

            SharedPreferences prefs =
                await SharedPreferences.getInstance();

            await prefs.clear();
          } else {
            final usersMap =
                Map<String, dynamic>.from(
              response2.data['users'],
            );

            userinfo =
                usermodel.fromJson(usersMap);

            SharedPreferences prefs =
                await SharedPreferences.getInstance();

            final tokenStr =
                (userinfo.rememperToken ?? '')
                    .toString();

            await prefs.setString(
              'token',
              tokenStr,
            );

            await prefs.setString(
              'UserData',
              jsonEncode(usersMap),
            );

            Token = tokenStr;
            UserId = userinfo.id.toString();

            print(
              'GOOGLE LOGIN: token saved '
              'len=${tokenStr.length}',
            );

            DismissGlopalLoading();

            await Provider.of<LoginViewmodel>(
              context,
              listen: false,
            ).UserLoginVerify(
              context: context,
              Parimater: email.toString(),
            );
          }
        } else {
          print(
            'GOOGLE LOGIN: E05 -> CompleteSignUp',
          );

          DismissGlopalLoading();

          Navigator.pushNamed(
            context,
            AppConstants.CompleteSignUp_Screan,
          );
        }
      }
    } catch (e) {
      final exception = _handleError(e);

      print(
        'GOOGLE LOGIN ERROR: $exception',
      );

      if (e is DioException) {
        final statusCode =
            e.response?.statusCode;

        final data = e.response?.data;

        print(
          'GOOGLE LOGIN ERROR STATUS: '
          '$statusCode',
        );

        print(
          'GOOGLE LOGIN ERROR DATA: '
          '$data',
        );

        if (statusCode == 400 &&
            data is Map &&
            data['errNum']?.toString() ==
                'E05') {
          print(
            'GOOGLE LOGIN: E05 -> CompleteSignUp',
          );

          DismissGlopalLoading();

          Navigator.pushNamed(
            context,
            AppConstants.CompleteSignUp_Screan,
          );

          return userinfo;
        }

        if (data is Map &&
            data['errNum'] != null) {
          Dialogs().ShowErrorToast(
            data['errNum'].toString(),
            context,
          );
        } else {
          Dialogs().showtoast(
            'Google login failed ($statusCode)',
          );
        }
      } else {
        print(
          'GOOGLE LOGIN UNKNOWN ERROR: $e',
        );

        Dialogs().showtoast(
          'Google login failed',
        );
      }

      DismissGlopalLoading();
    }

    print(
      'GOOGLE LOGIN USERINFO: $userinfo',
    );

    return userinfo;
  }

  Future<usermodel> UserLoginID({
    ID,
    Password,
    context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "id": ID.toString(),
        "password": Password.toString(),
      });

      Response response2 = await dio.post(
        'api/loginID',
        data: formData,
      );

      print(response2.data);

      if (response2.statusCode == 200) {
        if (response2.data['users'] != "E05") {
          UserId =
              response2.data['users']['id'].toString();

          if (response2.data['users']['ban'] == 1) {
            DismissGlopalLoading();

            Dialogs().showtoast(
              'تم حظر هذا الحساب',
            );

            SharedPreferences prefs =
                await SharedPreferences.getInstance();

            await prefs.clear();
          } else {
            Provider.of<LoginViewmodel>(
              context,
              listen: false,
            ).UserLoginVerify(
              context: context,
              Parimater: ID.toString(),
            );
          }
        }
      } else {
        DismissGlopalLoading();

        Dialogs().showtoast(
          'الايدي او الرقم السري خطاء',
        );
      }
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      DismissGlopalLoading();

      Dialogs().showtoast(
        'الايدي او الرقم السري خطاء',
      );
    }

    return userinfo;
  }

  Future<usermodel> CheckRegester({
    name,
    phone,
    context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name.toString(),
        "phone_number": phone.toString(),
      });

      Response response2 = await dio.post(
        'api/checkForRegester',
        data: formData,
      );

      if (response2.statusCode == 200) {}
    } catch (e) {
      final exception = _handleError(e);
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    print(userinfo);

    return userinfo;
  }

  @override
  Future<usermodel> UserLoginVerify({
    context,
    Parimater,
  }) async {
    try {
      var map = {
        "user_id": UserId.toString(),
        "notifi_token": notifitoken.toString(),
      };

      FormData formData =
          FormData.fromMap(map);

      Response response2 = await dio.post(
        'api/Verifyaccount',
        data: formData,
      );

      if (response2.statusCode == 200 ||
          response2.statusCode == 201) {
        print(notifitoken);

        userinfo =
            usermodel.fromJson(
          response2.data['users'],
        );
        debugPrint('========== INITIAL COUNTS: Verifyaccount ==========');
debugPrint('Source: POST api/Verifyaccount');
debugPrint('Raw users JSON: ${response2.data['users']}');
debugPrint('Parsed user ID: ${userinfo.id}');
debugPrint('Parsed friends count: ${userinfo.friends}');
debugPrint('Parsed visitors count: ${userinfo.visitors}');
debugPrint('====================================================');

        SharedPreferences prefs =
            await SharedPreferences.getInstance();

        final newToken =
            (userinfo.rememperToken ?? '')
                .toString();

        if (newToken.isNotEmpty) {
          await prefs.setString(
            'token',
            newToken,
          );

          Token = newToken;
        } else {
          print(
            'Verifyaccount returned empty token – '
            'keeping existing token',
          );
        }

        await prefs.setString(
          'UserData',
          jsonEncode(
            response2.data['users'],
          ),
        );

        UserId = userinfo.id.toString();

        if (userinfo.music != null &&
            userinfo.music != '' &&
            Gmail == null) {
          Helper().PlaylinkMusic(
            path: userinfo.music,
          );
        }

        Navigator.pushNamed(
          context,
          AppConstants.Buttom_Navigation,
        );

        DismissGlopalLoading();
      }
    } catch (e) {
      final exception = _handleError(e);

      print('ksap');
      print(exception);

      if (e is DioException) {
        final responseData = e.response?.data;

        final errNum = responseData is Map
            ? responseData['errNum']
            : null;

        if (errNum != null) {
          Dialogs().ShowErrorRegesterToast(
            errNum,
            context,
          );
        }
      }
    }

    print(userinfo);

    return userinfo;
  }

  Future<usermodel> registerNewUser({
    context,
    ginder,
    Flag,
    city,
    image,
    name,
    phone_number,
    year,
    month,
    day,
  }) async {
    var map;

    try {
      if (Gmail == null) {
        map = {
          "name": name.toString(),
          "phone_number":
              phone_number.toString(),
          "year": year.toString(),
          "month": month.toString(),
          "day": day.toString(),
          "image":
              await MultipartFile.fromFile(
            image?.path,
            filename:
                image?.path?.split('/')?.last,
          ),
          "notifi_token":
              notifitoken.toString(),
          "city": city.toString(),
          "Flag": Flag.toString(),
          "ginder": ginder.toString(),
        };
      } else {
        map = {
          "name": name.toString(),
          "phone_number": phone_number.toString(),
          "year": year.toString(),
          "month": month.toString(),
          "day": day.toString(),
          "image":
              await MultipartFile.fromFile(
            image?.path,
            filename:
                image?.path?.split('/')?.last,
          ),
          "notifi_token":
              notifitoken.toString(),
          "city": city.toString(),
          "Flag": Flag.toString(),
          "ginder": ginder.toString(),
          'email': Gmail.toString(),
        };
      }

      FormData formData =
          FormData.fromMap(map);

      Response response2 = await dio.post(
        '/api/SignUpaccount',
        data: formData,
      );

      if (response2.statusCode == 200) {
        userinfo =
            usermodel.fromJson(
          response2.data['users'],
        );

        SharedPreferences prefs =
            await SharedPreferences
                .getInstance();

        final tokenStr =
            (userinfo.rememperToken ?? '')
                .toString();

        await prefs.setString(
          'token',
          tokenStr,
        );

        await prefs.setString(
          'UserData',
          jsonEncode(
            response2.data['users'],
          ),
        );

        print(
          userinfo.rememperToken,
        );

        Token = tokenStr;
        UserId =
            userinfo.id.toString();

        if (userinfo.music != null &&
            userinfo.music != '' &&
            Gmail != null) {
          Helper().PlaylinkMusic(
            path: userinfo.music,
          );
        }

        Navigator.pushNamed(
          context,
          AppConstants.Buttom_Navigation,
        );
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
