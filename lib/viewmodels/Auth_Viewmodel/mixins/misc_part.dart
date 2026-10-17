
import 'package:ahlachat/main.dart';
import 'package:ahlachat/util/Localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../Repositores/user_repositores/user_api.dart';
import '../../../util/Dialogs.dart';
import '../../../util/app_constants.dart';
import 'login_state.dart';
import '../LoginViewModel.dart';


mixin MiscMixin on LoginState {
// Check login/kind, gender/age, sign-out, register
  checklogin(context) async {
    await userapi().checklogin(context);
  }

  checkuserkind({
    id,
    context,
  }) {
    LoginViewmodel user = Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    if (id.toString() == user.userinfo?.id.toString()) {
      return true;
    } else {
      return false;
    }
  }

  selectginder() {
    gender = !gender;
    print(gender);
    notifyListeners();
  }

  selectage({
    day,
    month,
    year,
  }) {
    Selectedday = day.toString();
    Selectedmonth = month.toString();
    Selectedyear = year.toString();
    notifyListeners();
  }

  Signout({context}) async {
    showSpinner10();

    await userapi().SignOut(context: context).then((value) async {
      if (value == true) {
        final googleuser = GoogleSignIn();

        await googleuser.signOut();

        await firebaseAuth.signOut();

        LoginPhonenumber.clear();

        Code2 = null;

        day = 0;
        year = 0;
        month = 0;

        Name2 = null;

        Comimage = null;

        Navigator.pushNamed(
          context,
          AppConstants.Login_Screan,
        );

        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Done_Succ",
          ),
        );
      } else {
        Dialogs().showtoast(
          getLang(
            context: NavigationService.navigatorKey.currentContext,
            key: "Sorry",
          ),
        );
      }

      hideSpinner10();
    });

    notifyListeners();
  }

  
Future<void> registerNewUser({
  required BuildContext context,
  String? phoneNumber,
}) async {
  SmartDialog.showLoading();

  try {
    final enteredPhone = phoneNumber?.trim() ?? '';
    final existingPhone = '${Code ?? ''}${LoginPhonenumber.text}'.trim();

    final value = await userapi().registerNewUser(
      context: context,
      image: Comimage,
      year: year,
      month: month,
      day: day,
      name: UsernameComp,
      city: Name2,
      Flag: Flag2,
      ginder: ginder,
      phone_number: enteredPhone.isNotEmpty
          ? enteredPhone
          : existingPhone,
    );

    if (value.id != null) {
      userinfo = value;
    } else {
      Dialogs().showtoast(
        getLang(
          context: NavigationService.navigatorKey.currentContext,
          key: 'Sorry',
        ),
      );
    }
  } catch (e) {
    debugPrint('Registration failed: $e');
    rethrow;
  } finally {
    SmartDialog.dismiss();
    notifyListeners();
  }
}


  // Future<User?> signInWithFacebook({context}) async {
  //   final fb = FacebookLogin();
  //
  //   final response = await fb.logIn();
  //
  //   if (response.status ==
  //       FacebookLoginStatus.success) {
  //     final accessToken =
  //         response.accessToken;
  //
  //     final userCredential =
  //         await firebaseAuth.signInWithCredential(
  //       FacebookAuthProvider.credential(
  //         accessToken!.token,
  //       ),
  //     );
  //
  //     print(
  //       userCredential.user?.uid,
  //     );
  //
  //     // Provider.of<LoginViewmodel>(
  //     //   context,
  //     //   listen: false,
  //     // ).UserSocialRegester(
  //     //   context: context,
  //     //   uuid: userCredential.user?.uid,
  //     //   social: "1",
  //     // );
  //
  //     return userCredential.user;
  //   } else if (response.status ==
  //       FacebookLoginStatus.cancel) {
  //     throw FirebaseAuthException(
  //       code:
  //           'ERROR_ABORTED_BY_USER',
  //       message:
  //           'Sign in aborted by user_repositores',
  //     );
  //   } else if (response.status ==
  //       FacebookLoginStatus.error) {
  //     throw FirebaseAuthException(
  //       code:
  //           'ERROR_FACEBOOK_LOGIN_FAILED',
  //       message:
  //           response.error?.developerMessage,
  //     );
  //   } else {
  //     throw UnimplementedError();
  //   }
}
