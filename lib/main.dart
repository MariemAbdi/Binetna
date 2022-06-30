import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mae_application/Services/LanguageChoice.dart';
import 'package:mae_application/translations/codegen_loader.g.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'HomePage/Home.dart';
import 'Login_Registration/LoginPage.dart';
import 'Services/MyThemes.dart';
import 'Services/My_Services.dart';
import 'Services/Theme_Service.dart';

final rememberMe = GetStorage();

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
  await GetStorage.init();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await EasyLocalization.ensureInitialized();

  timeago.setLocaleMessages('FR', timeago.FrMessages());
  timeago.setLocaleMessages('fr_short', timeago.FrShortMessages());

  //MAKE THE APP FULL SCREEN => HIDES THE STATUS AND NAVIGATION BAR OF THE PHONE
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);

  runApp(EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
      ],
      //fallbackLocale: Locale('fr'),
      assetLoader: CodegenLoader(),
      child: MyApp()
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        themeMode: ThemeService().theme,

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

        home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    rememberMe.writeIfNull('isLogged', false);


    Timer(const Duration(seconds: 3), (){(rememberMe.read("onboarding")==null)?Get.to(Lang_Choice()):
      rememberMe.read('isLogged') ? Get.to(HomePage()) : Get.to(Login());});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: LoginBackgroundImage(Theme.of(context),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/logo-only.png",
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
            ),

            CircularProgressIndicator(
              valueColor:  AlwaysStoppedAnimation<Color>(Colors.green),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Text("ببعضنا مأمّنين",textAlign:TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF408454),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

