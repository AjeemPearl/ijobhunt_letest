import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ijobhunt/screens/loginScreen/AuthenticationLogin/applesignin.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/screens/signUpScreen/signup.screen.dart';
import 'package:ijobhunt/screens/splashScreen/splash.screen.dart';
import 'package:ijobhunt/app/preferences/app_preferences.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'app/constants/app.theme.dart';
import 'app/providers/app.provider.dart';
import 'app/routes/app.routes.dart';

import 'core/notifiers/langaugeChangeprovider.dart';
import 'core/notifiers/theme.notifier.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xfffececec),
      statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light
      // status bar color
    ),
  );
  // configureApp();
  WidgetsFlutterBinding.ensureInitialized();
  // Set up a deep link stream subscription
  StreamSubscription<String?> deepLinkStream;
  const platform = const MethodChannel('app.channel.shared.data');
  deepLinkStream = getLinksStream().listen((String? deepLink) {
    handleDeepLink(deepLink);
  }, onError: (err) {
    // Handle any errors that occur during deep link handling
  });
  await Firebase.initializeApp(
    //name: 'ijobhut',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppPreferences.init();
//AppPreferences.clearCredential();
  final appleSignInAvailable = await AppleSignInAvailable.check();

  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: MyThemeData(),
  ));
}

void handleDeepLink(String? deepLink) {
  if (deepLink != null && deepLink.isNotEmpty) {
    // Parse and handle the deep link
    // Example: you can use Uri.parse(deepLink) to extract scheme and host
    // and then decide which screen to navigate to based on the deep link data.
    // For example:
    // if (uri.host == 'your_host') {
    //   if (uri.path == '/screen1') {
    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => YourScreen()));
    //   } else if (uri.path == '/screen2') {
    //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnotherScreen()));
    //   }
    // }
  }
}
class MyThemeData extends StatelessWidget {
  const MyThemeData({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: const MyApp(),
    );
  }
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, _) {
        // SystemChrome.setSystemUIOverlayStyle(
        //   const SystemUiOverlayStyle(
        //     statusBarColor: Color(0xff0c1c3d),
        //     statusBarBrightness: Brightness.light,
        //   ),
      //  );
        return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
          useInheritedMediaQuery: true,
          builder: (context, child) {
            return MaterialApp(
              locale: Provider.of<LanguageChangeProvider>(context).currentLocale,
              title: 'iJobhunt',
              // supportedLocales: AppLocalization.all,
              theme: notifier.darkTheme ? darkTheme : lightTheme,
              debugShowCheckedModeBanner: false,
              //onGenerateRoute: AppRouter.generateRoute,
              //initialRoute: AppRouter.splashRoute,
              supportedLocales: L10n.all,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                AppLocalizations.delegate,
              ],
              home: SplashScreen(),
              //home: SignUpScreen(),
              builder: EasyLoading.init(),
            );
          }
        );
      },
    );
  }
}
