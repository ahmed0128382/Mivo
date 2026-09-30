import 'dart:async';
import 'dart:convert';

import 'dart:io';
import 'dart:typed_data';
import 'package:ahlachat/Repositores/user_repositores/user_repository.dart';
import 'package:ahlachat/models/Inboxroom.dart';
import 'package:ahlachat/models/UsarImages.dart';
import 'package:ahlachat/models/UserModels.dart';
import 'package:ahlachat/view/Screans/Authentication/EnterCodeScrean/EnterCodeScrean.dart';
import 'package:ahlachat/view/Screans/Authentication/LoginScrean/LoginScrean.dart';
import 'package:ahlachat/view/Screans/RoomScrean/widgets/InBoxsRoom.dart';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

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

class userapi extends UserRepository {
  @override
  final _firebaseAuth = FirebaseAuth.instance;

  usermodel userinfo=usermodel() ;
  var Signupimage;
  MyVipmodel? myvip;
  List<Gifts>  giftssent=[];
  List<Gifts>  giftscollect=[];
  List<usermodel> Searchuser=[];
  List<usergifts> UserGifts=[];
  List<Notificationmodel>Notifications=[];
  final ImagePicker _picker = ImagePicker();
  var dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      headers: { 
        'Accept': 'application/json',
        'Authorization':Token,
        'DeviceId':deviceId,
        'awqeASERQW':'8/325*mAIOEN',
        'userid':UserId.toString(),
        'UserIP':UserIP,
      },
    ),
  );
  UserImages ? ProfileImages;
  Future<UserImages> AddProfileImage({ context,image}) async {


    try {
      FormData formData =   FormData.fromMap({
        "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
        "user_id":UserId.toString(),

      });

      Response response2 = await dio.post(
        'api/AddProfileImage',
        data: formData,
      );

      if (response2.statusCode == 200) {

        ProfileImages=UserImages.fromJson(response2.data['ProfileImages']);

      }
    } catch (e) {
      print(e);


    }

    return ProfileImages!;
  }
  Future<bool>  DeleteProfileImage({context, ImageId})async {
    bool deleted=false;
    try {
      Response response2 = await dio.get(
        '/api/DeleteProfileImage/$ImageId',
      );

      if (response2.statusCode == 200) {
        deleted=true;
      }else{
        deleted=false;
      }
    } catch (e) {

      print(e);
    }

    return deleted;

  }
  Future<int>  GetTimeTarget({context})async {
int target=0;
    try {
      Response response2 = await dio.get(
        '/api/getuserTime/$UserId',
      );

      if (response2.statusCode == 200) {
       


        target=int.parse(response2.data.toString());

      }
    } catch (e) {
      print(e);
     
    }

    return target;

  }
  Future<List<usergifts> >  GetUserGifts({context})async {
    try {
      Response response2 = await dio.get(
        '/api/GetMyUserGifts/$UserId',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['UserGifts'];

        list.forEach((element) {
          UserGifts.add(usergifts.fromJson(element));
        });


      }
    } catch (e) {
      print(e);
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return UserGifts;

  }
  List<usermusic> UserMusic=[];

  Future<List<Notificationmodel>>  UserNotification({context})async {

    try {
      Response response2 = await dio.get(
        '/api/GetUserNotification',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['UserNotifications'];

        list.forEach((element) {
          Notifications.add(Notificationmodel.fromJson(element));
        });


      }
    } catch (e) {
      print(e);
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
        if (e.response!.data['errNum'] == '3500') {

        }
      } else {
        print(e);
      }
    }

    return Notifications;

  }
  InboxRoomModel ? ChatRoom;
  Future<InboxRoomModel?>  ChatInBox({userid})async {

    try {
      Response response2 = await dio.get(
        '/api/ChatWithuser/$UserId/$userid',
      );

      if (response2.statusCode == 200) {
        ChatRoom=InboxRoomModel.fromJson(response2.data);

      }
    } catch (e) {

    }

    return ChatRoom;

  }
  Future<List<usermodel>>  SearchUser( tittle)async {

    try {
      Response response2 = await dio.get(
        '/api/SearchUser/$tittle',
      );

      if (response2.statusCode == 200) {
        List list =response2.data['users'];
        list.forEach((element) {
          Searchuser.add(usermodel.fromJson(element));
        });

      }
    } catch (e) {

    }

    return Searchuser;

  }

  Future<bool> NewGuess({context,Coins,Roomid,Sendergueess}) async {
    bool check=false;
    try {
      FormData formData =   FormData.fromMap({
        "Sender_id": UserId.toString(),
        "Coins": Coins.toString(),
        "Room_id": Roomid.toString(),
        "Sender_gueess": Sendergueess.toString(),
      });

      Response response2 = await dio.post(
        'api/NewGuessgame',
        data: formData,
      );

      if (response2.statusCode == 200) {
         
        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;

    }

    return check;
  }
  Future<bool> NewLuckyPackage({context,Coins,Roomid}) async {
    print(Roomid);
    print(Coins);
    bool check=false;
    try {
      FormData formData =   FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
        "coins": Coins.toString(),
      });

      Response response2 = await dio.post(
        'api/SendLuckybags',
        data: formData,
      );

      if (response2.statusCode == 200) {
         
        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;

    }

    return check;
  }
  Future<bool> AcceptLuckyPackage({context,luckid,Roomid}) async {
    print(Roomid);
    print(luckid);
    bool check=false;
    try {
      FormData formData =   FormData.fromMap({
        "user_id": UserId.toString(),
        "room_id": Roomid.toString(),
        "luck_id": luckid.toString(),
      });

      Response response2 = await dio.post(
        'api/AcceptLuckybags',
        data: formData,
      );

      if (response2.statusCode == 200) {
         check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;

    }

    return check;
  }
  Future<bool>  PlayGuess({context,guessid,Roomid,Sendergueess}) async {
    bool check=false;
    try {
      FormData formData =   FormData.fromMap({
        "Accept_id": UserId.toString(),
        "guess_id": guessid.toString(),
        "Room_id": Roomid.toString(),
        "Accept_gueess": Sendergueess.toString(),
      });

      Response response2 = await dio.post(
        'api/AcceptGuessgame',
        data: formData,
      );

      if (response2.statusCode == 200) {
         
        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;

    }

    return check;
  }
  Future<bool> Removebubbles({context}) async {
    bool check=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),

      });

      Response response2 = await dio.post(
        'api/removebubbles',
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
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }
  Future<List> Exchangecoins({context,jwile}) async {
    bool check=false;
    int coins=0;
    int input=0;
    try {
      FormData formData = FormData.fromMap({
        "user_id": UserId.toString(),
        "beans":jwile.toString()

      });

      Response response2 = await dio.post(
        'api/Exchangecoins',
        data: formData,
      );

      if (response2.statusCode == 200) {
       print(response2.data['Exchangecoins']['UserCoins'].runtimeType);
       print(response2.data['Exchangecoins']['UserInput'].runtimeType);
       coins=response2.data['Exchangecoins']['UserCoins'];
       input=response2.data['Exchangecoins']['UserInput'];
        check=true;

      }else{

        check=false;
      }
    } catch (e) {
      check=false;
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return [check,coins,input];
  }
  Future<bool> Updatebubbles({bubbles,context}) async {
    bool check=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "bubbles": bubbles.toString(),
      });

      Response response2 = await dio.post(
        'api/Setbubbles',
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
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }
  Future<bool> updateColoredMessage({Color,context}) async {
    bool check=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "Color": Color.toString(),
      });

      Response response2 = await dio.post(
        'api/SetColordmessage',
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
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }

  Future<bool> setHidden({Hidden,context}) async {
    bool check=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "Hidden": Hidden.toString(),
      });

      Response response2 = await dio.post(
        'api/SetHidden',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         
        check=true;
         
      }else{
         
        check=false;
      }
    } catch (e) {
      check=false;

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return check;
  }

  Future<User?> Googlesignin({context}) async {
    try {
      final googleuser = GoogleSignIn();
      final signin = await googleuser.signIn();
      if (googleuser != null) {
        final googleAuth = await signin?.authentication;
        if (googleAuth?.idToken != null) {
          ShowGlopalLoading();
          final usercredentioal = await _firebaseAuth
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,

          ));


          Gmail=usercredentioal.user?.email;
          final ByteData imageData = await NetworkAssetBundle(Uri.parse(usercredentioal.user?.photoURL??'')).load("");
          final Uint8List bytes = imageData.buffer.asUint8List();
          ByteData byteData = ByteData.view(bytes.buffer);
          var tempDir = await getTemporaryDirectory();
          File file = await File('${tempDir.path}/img').writeAsBytes(bytes.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
          if(usercredentioal.user!=null){
            Provider.of<LoginViewmodel>(context,listen: false).UpdateUsernameComp(name:usercredentioal.user?.displayName );
            Provider.of<LoginViewmodel>(context,listen: false).updateComimage(image: file);
           UserLoginGoogle(context: context ,email:usercredentioal.user?.email);
          }
          //Provider.of<LoginViewmodel>(context,listen: false).UserSocialRegester(context: context, uuid: usercredentioal.user!.uid,social: "2");

        } else {
//throw FirebaseAuthException(code: 'id tolen is null',message: 'id tolen is null');
          print('=======================> id tolen is null');
        }
      } else {
        //   throw FirebaseAuthException(code: 'id tolen is null',message: 'id tolen is null');
        print('=======================>googleuser empty');
      }
    } catch (e) {
      print(e);
    }
  }


  Future<bool> UpdateNewId({newid,context,myvip_id}) async {
    bool check=false;


    try {
      FormData formData = new FormData.fromMap({

        "user_id": UserId.toString(),
        "newid": newid.toString(),
        "myvip_id":myvip_id.toString(),

      });

      Response response2 = await dio.post(
        'api/SetNewId',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         
        check=true;
         
      }else{
         
        check=false;
      }
    } catch (e) {
      check=false;

      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {

      }
    }

    return check;
  }
  Future<usermodel> UserLogin({Phonenumber, context}) async {


    try {
      FormData formData = FormData.fromMap({
        "phone_number": Phonenumber.toString(),
      });

      Response response2 = await dio.post(
        'api/login',
        data: formData,
      );

      if (response2.statusCode == 200) {
if(response2.data['users']!="E05"){
  UserId=response2.data['users']['id'].toString();
  if(response2.data['users']['ban']==1){
    DismissGlopalLoading();
    Dialogs().showtoast('تم حظر هذا الحساب');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    navigateTo(context: context, screen: LoginScrean());
  }else{
    Provider.of<LoginViewmodel>(context,listen: false).SendCodeRlogin(context: context,phonenumber: Phonenumber);

  }

}else{

  Provider.of<LoginViewmodel>(context,listen: false).SendCodeSignUp(context: context,phonenumber: Phonenumber);


}
       } else {

      }

    } catch (e) {
      print(e);
      DismissGlopalLoading();

    }

    return userinfo;
  }
  Future<usermodel> UserLoginGoogle({email, context}) async {
    try {
      FormData formData =   FormData.fromMap({
        "email": email.toString(),
      });

      Response response2 = await dio.post(
        'api/loginGoogle',
        data: formData,
      );

      if (response2.statusCode == 200) {
        if(response2.data['users']!="E05"){

          UserId=response2.data['users']['id'].toString();
          if(response2.data['users']['ban']==1){
            DismissGlopalLoading();
            Dialogs().showtoast('تم حظر هذا الحساب');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();

          }else{
            DismissGlopalLoading();
            Provider.of<LoginViewmodel>(context,listen: false).UserLoginVerify(context: context,Parimater:email.toString() );

          }
        }else{
          print('Go To SignUp Otp');
          DismissGlopalLoading();
          Navigator.pushNamed(context, AppConstants.CompleteSignUp_Screan);

        }

      } else {
        //Navigator.pushNamed(context, '${AppConstants.Buttom_Navigation}');
      }

    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
      print(e);
    }
    print(userinfo);
    return userinfo;
  }


  Future<usermodel> UserLoginID({ID,Password, context}) async {
    try {
      FormData formData =   FormData.fromMap({
        "id": ID.toString(),
        "password":Password.toString()
      });

      Response response2 = await dio.post(
        'api/loginID',
        data: formData,
      );
print(response2.data);
      if (response2.statusCode == 200) {
        if(response2.data['users']!="E05"){

          UserId=response2.data['users']['id'].toString();
          if(response2.data['users']['ban']==1){
            DismissGlopalLoading();
            Dialogs().showtoast('تم حظر هذا الحساب');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();

          }else{

            Provider.of<LoginViewmodel>(context,listen: false).UserLoginVerify(context: context,Parimater: ID.toString());

          }
        }
      } else {
        DismissGlopalLoading();
        Dialogs().showtoast('الايدي او الرقم السري خطاء');



      }

    } catch (e) {
      DismissGlopalLoading();
      Dialogs().showtoast('الايدي او الرقم السري خطاء');
    }

    return userinfo;
  }
  Future<bool> verifyUserPhoneNumber(String phoneNumber) async {
    final completer = Completer<AuthCredential>();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: completer.complete,
      verificationFailed: completer.completeError,
      codeAutoRetrievalTimeout: (verificationId) {

      },
      codeSent: (verificationId, [code]) {

      },
    );
    try {
      final credential = await completer.future;
      return true;
    } catch (e) {

      return false;
    }
  }
  SendCodeRlogin({context,phonenumber}){
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    user.updatesendcodestate(value: 1);
    try{
      Dialogs().showtoast(phonenumber.toString());
    //  _firebaseAuth.setSettings(appVerificationDisabledForTesting:false  );
      _firebaseAuth.verifyPhoneNumber(phoneNumber: phonenumber,
          timeout: Duration(seconds:30),
          verificationCompleted: (AuthCredential credential) async{
            print(credential);

          },
          verificationFailed: (exception){
            user.hideSpinner();
            print(exception.code);
            print('Code Is missing-client-identifier');
          Dialogs().showtoast('identifier');
          },
          codeSent: (String verificationId, [int? forceResendingToken]){
            verificationid=verificationId;

            DismissGlopalLoading();
            Provider.of<LoginViewmodel>(context,listen: false).hideSpinner();

            navigateTo(context: context, screen: EnterCodeScrean(PhoneNumber:phonenumber ,));
          },
          codeAutoRetrievalTimeout: (message){
            if( user.sendcodestate==1){
              //Navigator.pop(context);
              print('Code Is missing-client-identifier');

              user.hideSpinner();
              Dialogs().showtoast(getLang( context: context, key: "code_expired"));
              user.updatesendcodestate(value: 0);
            }

          }

      );

    }catch(error){
      Dialogs().showtoast(getLang( context: context, key: "Phone_valid"));
      // user.hideSpinner();
      // Provider.of<LoginViewmodel>(context,listen: false).hideSpinner();
      // DismissGlopalLoading();
      // Dialogs().showtoast(getLang( context: context, key: "Phone_valid"));
    };

  }
  ReSendCodelogin({context,phonenumber}){
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    user.updatesendcodestate(value: 1);
   // _firebaseAuth.setSettings(appVerificationDisabledForTesting:false  );

    try{
      _firebaseAuth.verifyPhoneNumber(phoneNumber: phonenumber,
          timeout: Duration(seconds:30),
          verificationCompleted: (AuthCredential credential) async{
            print(credential);
            print('Code Is Recived');
          },
          verificationFailed: (exception){
            print(exception.code);
            Dialogs().showtoast(getLang( context: context, key: "Phone_valid"));
          },
          codeSent: (String verificationId, [int? forceResendingToken]){
            verificationid=verificationId;

            Provider.of<LoginViewmodel>(context,listen: false).hideSpinner();
            Provider.of<LoginViewmodel>(context,listen: false).hideSpinner9();
            // Navigator.pushNamed(context,'${AppConstants.EnterCodeScrean}');
          },
          codeAutoRetrievalTimeout: (message){
            if(user.sendcodestate==1){
             // Navigator.pop(context);
              Dialogs().showtoast(getLang( context: context, key: "code_expired"));
              user.updatesendcodestate(value: 0);
            }

          }

      );

    }catch(error){
      Provider.of<LoginViewmodel>(context,listen: false).hideSpinner();
      Dialogs().showtoast(getLang( context: context, key: "Phone_valid"));
    };

  }

  EnterCodelogin({context,code,Phonenumber})async{
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);

    AuthCredential credential = await PhoneAuthProvider.credential(verificationId:verificationid??'', smsCode:code);
    _firebaseAuth.signInWithCredential(credential).then(( result){
       Provider.of<LoginViewmodel>(context,listen: false).UserLoginVerify(context: context,Parimater: Phonenumber);
       user.updatesendcodestate(value: 0);
   print('Goooooooooooooooooooooooooooooooooo');
    }).catchError((e){
      user.updatesendcodestate(value: 1);
      //user.updatesendcodestate(value: 1);
      Dialogs().showtoast(getLang( context: context, key: "rowng_code"));
      print(e);
        print('Noooooooooooooooooooooooooooooooooo');
    });
  }

  EnterCodeSignUp({context,code})async{
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
    print(verificationid);
    print(code);
    AuthCredential credential = await PhoneAuthProvider.credential(verificationId:verificationid??'', smsCode:code);
    _firebaseAuth.signInWithCredential(credential).then(( result){
      Navigator.pushReplacementNamed(context, AppConstants.CompleteSignUp_Screan);
      user.updatesendcodestate(value: 0);

    }).catchError((e){
      user.updatesendcodestate(value: 1);
      //user.updatesendcodestate(value: 1);
      Dialogs().showtoast(getLang( context: context, key: "rowng_code"));
      print(e);

    });
  }


  SendCodeSignUp({context,phonenumber}){
    LoginViewmodel user=  Provider.of<LoginViewmodel>(context,listen: false);
    user.updatesendcodestate(value: 1);
    try{
   //   _firebaseAuth.setSettings(appVerificationDisabledForTesting:true,forceRecaptchaFlow:false  );

      _firebaseAuth.verifyPhoneNumber(phoneNumber: phonenumber,
          timeout: Duration(seconds:30),
          verificationCompleted: (AuthCredential credential) async{
            print(credential);
            print('Code Is Recived');
          },
          verificationFailed: (exception){
            print(exception.code);

            if(exception.code=='missing-client-identifier'){
              Dialogs().showtoast('Something went wrong, try again later');

            }else{
              Dialogs().showtoast(getLang( context: context, key: "Phone_valid"));

            }
            user.hideSpinner();
          },
          codeSent: (String verificationId, [int? forceResendingToken]){
            verificationid=verificationId;
            DismissGlopalLoading();

            Provider.of<LoginViewmodel>(context,listen: false).hideSpinner();
            Navigator.pushNamed(context,AppConstants.EnterCodeSignUp_Screan);
          },
          codeAutoRetrievalTimeout: (message){
            if( user.sendcodestate==1){
              //Navigator.pop(context);
              user.hideSpinner();
              print('print www');
              Dialogs().showtoast(getLang( context: context, key: "code_expired"));
              user.updatesendcodestate(value: 0);
            }
          }

      );

    }catch(error){
      print('rwtvasd');
      Provider.of<LoginViewmodel>(context,listen: false).hideSpinner();
      Dialogs().showtoast(getLang( context: context, key: "Phone_valid"));
    };

  }



  Future<MyVipmodel?> ByeVip({VipModel? Vip, context}) async {


    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "vip_id": Vip?.id.toString(),
        "days": Vip?.day.toString(),
        "cost": Vip?.cost.toString(),
      });

      Response response2 = await dio.post(
        'api/ByeVip',
        data: formData,
      );
       
      if (response2.statusCode == 200) {


  myvip = MyVipmodel.fromJson(response2.data['MyVip']);

      }
    } catch (e) {
      print(e);
      if (e is DioError) {

        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return myvip;
  }
  Future<MyVipmodel?> UseVip({MyVipmodel? Vip }) async {


    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "Myvip_id": Vip?.id.toString(),
      });

      Response response2 = await dio.post(
        'api/UseVip',
        data: formData,
      );

      if (response2.statusCode == 200) {


        myvip = MyVipmodel.fromJson(response2.data);

      }
    } catch (e) {
      print(e);

    }

    return myvip;
  }
  Future<bool> ByeBackages({coins,cost,kind,context}) async {
   bool Status=false;
    try {
      FormData formData =  FormData.fromMap({
        "user_id": UserId.toString(),
        "coins": coins.toString(),
        "method": kind.toString(),
        "cost": cost.toString(),
      });

      Response response2 = await dio.post(
        'api/shippingccount',
        data: formData,
      );

      if (response2.statusCode == 200) {
        Status=true;
      }
    } catch (e) {
      Status=false;
      if (e is DioError) {

        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    return Status;
  }



  Future<bool?> RemoveVip({MyVipmodel? MyVip}) async {

    bool remove=false;
    try {
      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),
        "Myvip_id": MyVip?.id.toString(),
      });
      Response response2 = await dio.post(
        'api/RemoveVip',
        data: formData,
      );
       print(response2.data);
      if (response2.statusCode == 200) {
         remove=true;
      }
    } catch (e) {
      print(e);
      remove=false;

    }

    return remove;
  }

  Future<usermodel> CheckRegester({name, phone, context}) async {
    try {
      FormData formData = new FormData.fromMap({
        "name": name.toString(),
        "phone_number": phone.toString(),
      });

      Response response2 = await dio.post(
        'api/checkForRegester',
        data: formData,
      );
       
      if (response2.statusCode == 200) {

      }
    } catch (e) {
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }
    print(userinfo);
    return userinfo;
  }
  @override
  Future<usermodel> UserLoginVerify({context,Parimater})async{

    try {
       var map= {
          "user_id":UserId.toString(),
          "notifi_token":notifitoken.toString(),
        };
      FormData formData = new FormData.fromMap(map);
      Response response2 = await dio.post(
        'api/Verifyaccount',
        data: formData,
      );


      if (response2.statusCode == 200 || response2.statusCode == 201) {
        print(notifitoken);

        userinfo = usermodel.fromJson(response2.data['users']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', userinfo.rememperToken.toString());
        prefs.setString('UserData', jsonEncode(userinfo)) ;

        Token=userinfo.rememperToken.toString();
        UserId=userinfo.id.toString();
if(userinfo.music!=null&&userinfo.music!=''&&Gmail==null){
  Helper().PlaylinkMusic(path:userinfo.music );
}

        Navigator.pushNamed(context, AppConstants.Buttom_Navigation);
        DismissGlopalLoading();
      }

    } catch (e) {
      print('ksap');
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
         Dialogs().ShowErrorRegesterToast(e.response?.data['errNum'],context);
      } else {
        print(e);
      }
    }

    print(userinfo);
    return userinfo;

  }
  @override
  Future<bool> SendReport({context,contact,feedback,feedback_type,contact_type,image})async{

    bool data=false;
    try {


      var map;
      if(image!=null){
        map= {
          "user_id": UserId.toString(),
          "feedback":feedback.toString(),
          "contact": contact.toString(),
          "image": await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),

          "feedback_type": feedback_type.toString(),
          "contact_type": contact_type.toString(),
        };
      }else{
        map= {
          "user_id": UserId.toString(),
          "feedback":feedback.toString(),
          "contact": contact.toString(),
          "feedback_type": feedback_type.toString(),
          "contact_type": contact_type.toString(),
        };
      }
      print('2222222222222222222222222222222222');

      FormData formData = new FormData.fromMap(map);
      Response response2 = await dio.post(
        '/api/SendReport',
        data: formData,
      );

      if (response2.statusCode == 200) {
        data=true;
      }else{
        data=false;
      }
    } catch (e) {
      data=false;
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);

      } else {
        print(e);


      }
    }


    return data;
  }


  Future<List> MyGifts({context})async{

  List data=[];
    try {

      FormData formData = new FormData.fromMap({
        "user_id": UserId.toString(),

      });
      Response response2 = await dio.post(
        '/api/mygifts',
        data: formData,
      );
       

      if (response2.statusCode == 200) {

        List list =response2.data['users']['giftssent'];

        list.forEach((element){
          giftssent.add(Gifts.fromJson(element));
        });
        List list2 =response2.data['users']['giftscollect'];
        list2.forEach((element){
          giftscollect.add(Gifts.fromJson(element));
        });


        data.add(giftssent);
        data.add(giftscollect);
      }else{

      }
    } catch (e) {

      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);

      } else {
        print(e);


      }
    }


    return data;
  }
  Future<usermodel> userinfoRoom({id,roomid, context}) async {
    print('=============================>$roomid');
    print('=============================>$id');
    try {

      Response response2 = await dio.get(
        '/api/getuserRoom/$id/$roomid',
      );
       
         print(userinfo);
      if (response2.statusCode == 200) {

        userinfo = usermodel.fromJson(response2.data['users']);


       }
    } catch (e) {

      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);

      } else {
        print(e);


      }
    }
    print(userinfo);

    return userinfo;
  }
  Future<usermodel> UserProfileData({id, context}) async {

    try {

      Response response2 = await dio.get(
        '/api/UserProfileData/$id/$UserId',
      );
       

      if (response2.statusCode == 200) {

        userinfo = usermodel.fromJson(response2.data['users']);

      }
    } catch (e) {

      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);

      } else {
        print(e);


      }
    }
    print(userinfo);

    return userinfo;
  }


  Future<usermodel> Userinfo({ context}) async {


    try {
      FormData formData =   FormData.fromMap({
        "":''
      });

      Response response2 = await dio.post(
        '/api/userinfo',
        data: formData,
      );


      if (response2.statusCode == 200) {
        userinfo = usermodel.fromJson(response2.data['users']);
        Token=userinfo.rememperToken.toString();
        UserId=userinfo.id.toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('UserData', jsonEncode(response2.data['users']) ) ;

        prefs.setString('token', userinfo.rememperToken.toString());

      }
    } catch (e) {


      Navigator.pushNamed(context, AppConstants.Login_Screan);


    }


    return userinfo;
  }
  Future<usermodel> UserinfoID({ID, context}) async {
    LoginViewmodel user = Provider.of<LoginViewmodel>(context, listen: false);
      dio.options.headers = {
        'Authorization': Token,
      };


    try {


      Response response2 = await dio.get(
        '/api/userinformation/${ID.toString()}/${user.userinfo?.id.toString()}',
      );
       
      if (response2.statusCode == 200) {

   userinfo = usermodel.fromJson(response2.data['users']);
      }
    } catch (e) {
      if (e is DioError) {


        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);

      } else {
        print(e);
      }
    }


    return userinfo;
  }



   Future<usermodel> UpdatenormalProfile({Flag,ginder,Password,day,year,month,City,Description ,context,token,name,PhoneNumber,Image}) async {

     print(Password);
     print(name);
     print(City);
     print(ginder);  print(day);  print(year); print(month);print(Password);
    var  map;
    if(Image!=null){
      map={
        "description": Description.toString(),

        //"password":password.toString(),
        "name": name.toString(),
        "image":await MultipartFile.fromFile(Image?.path, filename: Image?.path?.split('/')?.last),
        "City":City,
        "ginder":ginder.toString(),
        "day":day.toString(),
        "year":year.toString(),
        "month":month.toString(),
        "Flag":Flag.toString(),
        "password":Password.toString(),
      };
    }else{
      map={
        "description": Description.toString(),

         "name": name.toString(),
        "City":City,
        "ginder":ginder.toString(),
        "day":day.toString(),
        "year":year.toString(),
        "month":month.toString(),
        "Flag":Flag.toString(),
       "password":Password.toString(),
      };
    }

    map.removeWhere((key, value) => key == null || value == null||value==''||value=='null');

    try {
      FormData formData = new FormData.fromMap(map);

      Response response2 = await dio.post(
        'api/UpdateProfile',
        data: formData,
      );
      print(response2.data);    print(response2.data);
      if (response2.statusCode == 200) {
        userinfo = usermodel.fromJson(response2.data['users']);
        Dialogs().showtoast('Profile Updated');
        //Navigator.pushNamed(context, '${AppConstants.Buttom_Navigation}');
      } else {
        print(response2.statusCode);
      }
    } catch (e) {
      print(e);
      if (e is DioError) {
        print(e.response?.data['errNum']);
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
      } else {

      }
    }
    print(userinfo);
    return userinfo;
  }
  FutureUpdatephoto({photo ,context,token,avatar}) async {

    var map;
    if(photo!=null){
      map={
        "image": await MultipartFile.fromFile(photo?.path, filename: photo?.path?.split('/')?.last),
      };
    }else{
       map={
        "image": avatar,
      };
    }
    String image ='';
    map.removeWhere((key, value) => key == null || value == null);
    try {
      FormData formData = new FormData.fromMap(map);

      Response response2 = await dio.post(
        'api/Updatephoto',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
         image = response2.data['image'];
        Dialogs().showtoast('Photo Updated');
        //Navigator.pushNamed(context, '${AppConstants.Buttom_Navigation}');
      } else {
        print(response2.statusCode);
      }
    } catch (e) {
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
      } else {

      }
    }

    print(userinfo);
    return image;
  }

  @override



  checklogin(context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      Token=prefs.getString('token');

  FlutterNativeSplash.remove();
    if(Token==null){


       Navigator.pushNamed(context,AppConstants.Login_Screan);


    }else{

    var  datauser=  prefs.getString('UserData');
    userinfo = usermodel.fromJson(jsonDecode(datauser!));
    Provider.of<LoginViewmodel>(context,listen: false).waitingConstDate(context);

    // if(userinfo.StarterBanner!=null){
    //   Dialogs().showtoast('Starteranner');
    // }

    //  Navigator.pushNamed(context, AppConstants.Buttom_Navigation);

      Provider.of<LoginViewmodel>(context,listen: false).userinformation( context: context, );
    }

  }

  SendPhoneCodeResetPassword({context,phonenumber}){
    LoginViewmodel user=Provider.of<LoginViewmodel>(context, listen: false);
    user.updatesendcodestate(value: 1);

    try{
      print('phone number $phonecode$phonenumber');
      _firebaseAuth.verifyPhoneNumber(phoneNumber:"$phonecode$phonenumber",
          timeout: Duration(seconds:30),
          verificationCompleted: (AuthCredential credential) async{
            print(credential);
            print('Code Is Recived');
          },
          verificationFailed: (exception){
            print(exception.code);
            Dialogs().showtoast(getLang( context: context, key: "Phone_valid"));
          },
          codeSent: (String verificationId, [int? forceResendingToken]){
            verificationid=verificationId;
            Provider.of<LoginViewmodel>(context,listen: false).hideSpinner();
            Navigator.pushNamed(context,AppConstants.OTP_Screan);
          },
          codeAutoRetrievalTimeout: (message){
            if(user.sendcodestate==1){
              Navigator.pop(context);
              Dialogs().showtoast(getLang( context: context, key: "code_expired"));
              user.updatesendcodestate(value: 0);
            }

          }

      );

    }catch(error){
      Dialogs().showtoast(getLang( context: context, key: "Phone_valid"));
    };

  }

  getAllconstant(context) async {
    try {
      var avatars = await dio.get('api/GetConstData');

      return avatars.data;
    } catch (exception) {
      print('asdasdasdasdasd');
      print(exception);
    }


  }
  Future getReportImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!= null) {
      var  Signupimage = File(pickedFile.path);
      print(Signupimage);
      return Signupimage;
    } else {
      print('No image selected.');
    }
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
  Future<usermodel>
  RegesterNewUser({context,ginder,Flag,city,image,name,phone_number,year,month,day}) async {
    var  map;
    try {

      if(Gmail==null){

        map={
          "name":name.toString(),
          "phone_number": phone_number.toString(),
          "year":year.toString(),
          "month":month.toString(),
          "day": day.toString(),
          "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
          "notifi_token":notifitoken.toString(),
          "city":city.toString(),
          "Flag":Flag.toString(),
          "ginder":ginder.toString(),

        };
      }else{

        map={
          "name":name.toString(),
          "year":year.toString(),
          "month":month.toString(),
          "day": day.toString(),
          "image":await MultipartFile.fromFile(image?.path, filename: image?.path?.split('/')?.last),
          "notifi_token":notifitoken.toString(),
          "city":city.toString(),
          "Flag":Flag.toString(),
          "ginder":ginder.toString(),
          'email':Gmail.toString()

        };
      }

      FormData formData = new FormData.fromMap(map);

      Response response2 = await dio.post(
        '/api/SignUpaccount',
        data: formData,
      );
       
      if (response2.statusCode == 200) {
        userinfo = usermodel.fromJson(response2.data['users']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', userinfo.rememperToken.toString());
        prefs.setString('UserData', jsonEncode(userinfo)) ;
        print(userinfo.rememperToken);
        Token=userinfo.rememperToken.toString();
        UserId=userinfo.id.toString();
        if(userinfo.music!=null&&userinfo.music!=''&&Gmail!=null){
          Helper().PlaylinkMusic(path:userinfo.music );
        }

        Navigator.pushNamed(context, AppConstants.Buttom_Navigation);

      }

    }catch (e) {
      print(e);
      if (e is DioError) {
         
        Dialogs().ShowErrorToast(e.response!.data['errNum'],context);
      } else {

      }
    }


    return userinfo;
  }

  Future<bool> SignOut({context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Token is ======> $Token');
    FormData formData = new FormData.fromMap({
      "user_id":UserId.toString(),
    });

    Response response2 = await dio.post(
      '/api/logout',
      data: formData,
    );
     
    if (response2.statusCode == 200) {
      prefs.remove('token');
      prefs.remove('uuid');
return true;
    }else{
      return false;
    }


  }
}
