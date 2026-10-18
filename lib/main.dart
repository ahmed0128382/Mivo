
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
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'Repositores/Wallet_repositores/Wallet_api.dart';
import 'viewmodels/Agency_ViewModel/Agency_ViewModel.dart';
import 'viewmodels/Auth_Viewmodel/LoginViewModel.dart';
import 'viewmodels/Language_Viewmodel/LanguageViewmodel.dart';
import 'viewmodels/RoomPlay_ViewModel/RoomPlayViewModel.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the saved language before the first widget is built.
  await checklanguage();

  await PurchasaApi.init();

  // Keep your existing Firebase initialization.
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  getnotifitoken();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  WakelockPlus.enable();

  debugPrint('APP LANGUAGE: $lang');
  debugPrint(
    'APP LOCALE: ${lang?.toLowerCase() == 'en' ? 'en' : 'ar'}',
  );

  runApp(const MyApp());
}

Future<void> getnotifitoken() async {
  try {
    notifitoken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM token: $notifitoken');
  } catch (e) {
    debugPrint('FCM token unavailable: $e');
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('${message.data}');

    LocalNotificationService().showNotification(
      body: ';asd',
      id: 1,
      title: 'asdasdasd',
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {},
  );
}

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  debugPrint('${message.data}');
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
      child: Consumer<languageViewmodel>(
        builder: (context, mainModel, child) {
          final String languageCode =
              lang?.toLowerCase() == 'en' ? 'en' : 'ar';

          final Locale appLocale = Locale(languageCode);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppConstants.APP_NAME,
            navigatorKey: NavigationService.navigatorKey,
            restorationScopeId: 'root',
            navigatorObservers: [
              FlutterSmartDialog.observer,
            ],
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
                titleTextStyle: style1.copyWith(
                  fontSize: 20,
                  letterSpacing: 2,
                ),
                elevation: 0.0,
              ),
            ),
            locale: appLocale,
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              AppLocale.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
