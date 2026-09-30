import 'package:ahlachat/util/Localization.dart';
import 'package:ahlachat/util/Router.dart';
import 'package:ahlachat/util/app_constants.dart';
import 'package:ahlachat/util/notification.dart';
import 'package:ahlachat/util/styles.dart';
import 'package:ahlachat/viewmodels/Agora_ViewModel/AgoraViewmodel.dart';
import 'package:ahlachat/viewmodels/Animated_Viewmodel/ElementViewModel.dart';
import 'package:ahlachat/viewmodels/Chat_Viewmodel/ChatViewmodel.dart';
import 'package:ahlachat/viewmodels/Family_ViewModel/Family_ViewModel.dart';
import 'package:ahlachat/viewmodels/Follow_ViewModel/Follow_ViewModel.dart';
import 'package:ahlachat/viewmodels/Games_ViewModel/Games_ViewModel.dart';
import 'package:ahlachat/viewmodels/Gifts_Viewmodel/Gifts_Viewmodel.dart';
import 'package:ahlachat/viewmodels/InboxRooms_Viewmodel/InboxRoomsViewmodel.dart';
import 'package:ahlachat/viewmodels/Levels_ViewModel/Level_ViewModel.dart';
import 'package:ahlachat/viewmodels/Moment_Viewmodel/Moment_ViewModel.dart';
import 'package:ahlachat/viewmodels/Music_Viewmodel/MusicViewmodel.dart';
import 'package:ahlachat/viewmodels/Relations_ViewModel/RelationsViewModel.dart';
import 'package:ahlachat/viewmodels/Room_Viewmodel/Room_Viewmodel.dart';
import 'package:ahlachat/viewmodels/Shop_ViewModel/Shop_ViewModel.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/GlopelSocketModelView.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/SocketUserModelView.dart';
import 'package:ahlachat/viewmodels/Socket_ViewModel/Socketviewmodel.dart';
import 'package:ahlachat/viewmodels/Vip_ViewModel/Vip_ViewModel.dart';
import 'package:ahlachat/viewmodels/Wallet_ViewModel/Wallet_ViewModel.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'Repositores/Wallet_repositores/Wallet_api.dart';
import 'viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'viewmodels/Language_Viewmodel/LanguageViewmodel.dart';
import 'viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PurchasaApi.init();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  checklanguage();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  getnotifitoken();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) async {
    WakelockPlus.enable();
    runApp(MyApp());
    //await SentryReporter.setup(MyApp());
  });
}

getnotifitoken() async {
  notifitoken = await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(message.data);
    LocalNotificationService().showNotification(
      body: ';asd',
      id: 1,
      title: 'asdasdasd',
    );
    // RoomViewmodel Room=  Provider.of<RoomViewmodel>(context,listen: false);
    // Room.Leaveroom(context:context);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  // RoomViewmodel Room=Provider.of<RoomViewmodel>(context3,listen: false);
  // Room.Leaveroom(context:context3);
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // var token=prefs.getString('token');
  // print(token);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginViewmodel()),
        ChangeNotifierProvider(create: (context) => MusicViewModel()),
        ChangeNotifierProvider(create: (context) => ChatViewmodel()),
        ChangeNotifierProvider(create: (context) => GiftsViewModel()),
        ChangeNotifierProvider(create: (context) => RoomPlayViewModel()),
        ChangeNotifierProvider(create: (context) => AgoraViewmodel()),
        ChangeNotifierProvider(create: (context) => RoomViewmodel()),
        ChangeNotifierProvider(create: (context) => SocketViewmodel()),
        ChangeNotifierProvider(create: (context) => SvgViewmodel()),
        ChangeNotifierProvider(create: (context) => ShopViewmodel()),
        ChangeNotifierProvider(create: (context) => SocketuserViewmodel()),
        ChangeNotifierProvider(create: (context) => MomentViewModel()),
        ChangeNotifierProvider(create: (context) => InboxroomViewModel()),
        ChangeNotifierProvider(create: (context) => languageViewmodel()),
        ChangeNotifierProvider(create: (context) => FollowViewModel()),
        ChangeNotifierProvider(create: (context) => VipViewmodel()),
        ChangeNotifierProvider(create: (context) => LevelViewModel()),
        ChangeNotifierProvider(create: (context) => AagencyViewModel()),
        ChangeNotifierProvider(create: (context) => WalletViewmodel()),
        ChangeNotifierProvider(create: (context) => GamesViewModel()),
        ChangeNotifierProvider(create: (context) => GlopelViewmodel()),
        ChangeNotifierProvider(create: (context) => RelationsViewModel()),
        ChangeNotifierProvider(create: (context) => FamilyViewModel()),
      ],
      child: Consumer<languageViewmodel>(builder: (context, mainModel, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.APP_NAME,
          navigatorKey: NavigationService.navigatorKey,
          restorationScopeId: "root",
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(),
          onGenerateRoute: generateRoute,
          initialRoute: AppConstants.Splash_Screan,
          theme: ThemeData(
              fontFamily: 'cairo',
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: whitecolor,
              appBarTheme: AppBarTheme(
                  backgroundColor: whitecolor,
                  centerTitle: false,
                  titleTextStyle:
                      style1.copyWith(fontSize: 20, letterSpacing: 2),
                  elevation: 0.0)),
          locale: Lang == 'En'
              ? Locale(
                  AppConstants.languages[0].languageCode,
                  AppConstants.languages[0].countryCode,
                )
              : Locale(
                  AppConstants.languages[1].languageCode,
                  AppConstants.languages[1].countryCode,
                ),
          supportedLocales: [
            Locale(
              AppConstants.languages[0].languageCode,
              AppConstants.languages[0].countryCode,
            ),
            Locale(
              AppConstants.languages[1].languageCode,
              AppConstants.languages[1].countryCode,
            ),
          ],
          localizationsDelegates: const [
            AppLocale.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      }),
    );
  }
}
