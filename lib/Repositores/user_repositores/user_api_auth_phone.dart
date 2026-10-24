part of 'user_api.dart';

// Phone verification and OTP code send/enter
mixin UserApiAuthPhone on _UserApiBase {
  Future<bool> verifyUserPhoneNumber(
    String phoneNumber,
  ) async {
    final completer =
        Completer<AuthCredential>();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted:
          completer.complete,
      verificationFailed:
          completer.completeError,
      codeAutoRetrievalTimeout:
          (verificationId) {},
      codeSent: (
        verificationId,
        [code]
      ) {},
    );

    try {
      final credential =
          await completer.future;

      return true;
    } catch (e) {
      return false;
    }
  }

  SendCodeRlogin({
    context,
    phonenumber,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    user.updatesendcodestate(
      value: 1,
    );

    try {
      Dialogs().showtoast(
        phonenumber.toString(),
      );

      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phonenumber,
        timeout: Duration(seconds: 30),
        verificationCompleted:
            (AuthCredential credential) async {
          print(credential);
        },
        verificationFailed:
            (exception) {
          user.hideSpinner();

          print(exception.code);

          print(
            'Code Is missing-client-identifier',
          );

          Dialogs().showtoast(
            'identifier',
          );
        },
        codeSent: (
          String verificationId,
          [int? forceResendingToken]
        ) {
          verificationid = verificationId;

          DismissGlopalLoading();

          Provider.of<LoginViewmodel>(
            context,
            listen: false,
          ).hideSpinner();

          navigateTo(
            context: context,
            screen: EnterCodeScrean(
              PhoneNumber: phonenumber,
            ),
          );
        },
        codeAutoRetrievalTimeout:
            (message) {
          if (user.sendcodestate == 1) {
            print(
              'Code Is missing-client-identifier',
            );

            user.hideSpinner();

            Dialogs().showtoast(
              getLang(
                context: context,
                key: "code_expired",
              ),
            );

            user.updatesendcodestate(
              value: 0,
            );
          }
        },
      );
    } catch (error) {
      Dialogs().showtoast(
        getLang(
          context: context,
          key: "Phone_valid",
        ),
      );
    }
  }

  ReSendCodelogin({
    context,
    phonenumber,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    user.updatesendcodestate(
      value: 1,
    );

    try {
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phonenumber,
        timeout: Duration(seconds: 30),
        verificationCompleted:
            (AuthCredential credential) async {
          print(credential);
          print('Code Is Recived');
        },
        verificationFailed:
            (exception) {
          print(exception.code);

          Dialogs().showtoast(
            getLang(
              context: context,
              key: "Phone_valid",
            ),
          );
        },
        codeSent: (
          String verificationId,
          [int? forceResendingToken]
        ) {
          verificationid = verificationId;

          Provider.of<LoginViewmodel>(
            context,
            listen: false,
          ).hideSpinner();

          Provider.of<LoginViewmodel>(
            context,
            listen: false,
          ).hideSpinner9();
        },
        codeAutoRetrievalTimeout:
            (message) {
          if (user.sendcodestate == 1) {
            Dialogs().showtoast(
              getLang(
                context: context,
                key: "code_expired",
              ),
            );

            user.updatesendcodestate(
              value: 0,
            );
          }
        },
      );
    } catch (error) {
      Provider.of<LoginViewmodel>(
        context,
        listen: false,
      ).hideSpinner();

      Dialogs().showtoast(
        getLang(
          context: context,
          key: "Phone_valid",
        ),
      );
    }
  }

  EnterCodelogin({
    context,
    code,
    Phonenumber,
  }) async {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    AuthCredential credential =
        await PhoneAuthProvider.credential(
      verificationId: verificationid ?? '',
      smsCode: code,
    );

    _firebaseAuth
        .signInWithCredential(
      credential,
    )
        .then((result) {
      Provider.of<LoginViewmodel>(
        context,
        listen: false,
      ).UserLoginVerify(
        context: context,
        Parimater: Phonenumber,
      );

      user.updatesendcodestate(
        value: 0,
      );

      print(
        'Goooooooooooooooooooooooooooooooooo',
      );
    }).catchError((e) {
      user.updatesendcodestate(
        value: 1,
      );

      Dialogs().showtoast(
        getLang(
          context: context,
          key: "rowng_code",
        ),
      );

      print(e);

      print(
        'Noooooooooooooooooooooooooooooooooo',
      );
    });
  }

  EnterCodeSignUp({
    context,
    code,
  }) async {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    print(verificationid);
    print(code);

    AuthCredential credential =
        await PhoneAuthProvider.credential(
      verificationId: verificationid ?? '',
      smsCode: code,
    );

    _firebaseAuth
        .signInWithCredential(
      credential,
    )
        .then((result) {
      Navigator.pushReplacementNamed(
        context,
        AppConstants.CompleteSignUp_Screan,
      );

      user.updatesendcodestate(
        value: 0,
      );
    }).catchError((e) {
      user.updatesendcodestate(
        value: 1,
      );

      Dialogs().showtoast(
        getLang(
          context: context,
          key: "rowng_code",
        ),
      );

      print(e);
    });
  }

  SendCodeSignUp({
    context,
    phonenumber,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    user.updatesendcodestate(
      value: 1,
    );

    try {
      _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phonenumber,
        timeout: Duration(seconds: 30),
        verificationCompleted:
            (AuthCredential credential) async {
          print(credential);
          print('Code Is Recived');
        },
        verificationFailed:
            (exception) {
          print(exception.code);

          if (exception.code ==
              'missing-client-identifier') {
            Dialogs().showtoast(
              'Something went wrong, try again later',
            );
          } else {
            Dialogs().showtoast(
              getLang(
                context: context,
                key: "Phone_valid",
              ),
            );
          }

          user.hideSpinner();
        },
        codeSent: (
          String verificationId,
          [int? forceResendingToken]
        ) {
          verificationid = verificationId;

          DismissGlopalLoading();

          Provider.of<LoginViewmodel>(
            context,
            listen: false,
          ).hideSpinner();

          Navigator.pushNamed(
            context,
            AppConstants.EnterCodeSignUp_Screan,
          );
        },
        codeAutoRetrievalTimeout:
            (message) {
          if (user.sendcodestate == 1) {
            user.hideSpinner();

            print('print www');

            Dialogs().showtoast(
              getLang(
                context: context,
                key: "code_expired",
              ),
            );

            user.updatesendcodestate(
              value: 0,
            );
          }
        },
      );
    } catch (error) {
      print('rwtvasd');

      Provider.of<LoginViewmodel>(
        context,
        listen: false,
      ).hideSpinner();

      Dialogs().showtoast(
        getLang(
          context: context,
          key: "Phone_valid",
        ),
      );
    }
  }

  SendPhoneCodeResetPassword({
    context,
    phonenumber,
  }) {
    LoginViewmodel user =
        Provider.of<LoginViewmodel>(
      context,
      listen: false,
    );

    user.updatesendcodestate(
      value: 1,
    );

    try {
      print(
        'phone number $phonecode$phonenumber',
      );

      _firebaseAuth.verifyPhoneNumber(
        phoneNumber:
            "$phonecode$phonenumber",
        timeout:
            Duration(seconds: 30),
        verificationCompleted:
            (AuthCredential credential) async {
          print(credential);
          print('Code Is Recived');
        },
        verificationFailed:
            (exception) {
          print(exception.code);

          Dialogs().showtoast(
            getLang(
              context: context,
              key: "Phone_valid",
            ),
          );
        },
        codeSent: (
          String verificationId,
          [int? forceResendingToken]
        ) {
          verificationid =
              verificationId;

          Provider.of<LoginViewmodel>(
            context,
            listen: false,
          ).hideSpinner();

          Navigator.pushNamed(
            context,
            AppConstants.OTP_Screan,
          );
        },
        codeAutoRetrievalTimeout:
            (message) {
          if (user.sendcodestate == 1) {
            Navigator.pop(context);

            Dialogs().showtoast(
              getLang(
                context: context,
                key: "code_expired",
              ),
            );

            user.updatesendcodestate(
              value: 0,
            );
          }
        },
      );
    } catch (error) {
      Dialogs().showtoast(
        getLang(
          context: context,
          key: "Phone_valid",
        ),
      );
    }
  }

}
