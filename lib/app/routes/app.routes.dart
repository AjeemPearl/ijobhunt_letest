import 'package:flutter/material.dart';
import 'package:ijobhunt/screens/homescreens/home_page.dart';
import 'package:ijobhunt/screens/loginScreen/widget/forgotpass.dart';
import 'package:ijobhunt/screens/signUpScreen/signup.screen.dart';
import '../../screens/loginScreen/login.view.dart';
import '../../screens/onBoardingScreen/onBoarding.screen.dart';
import '../../screens/splashScreen/splash.screen.dart';

class AppRouter {
  static const String splashRoute = "/SplashScreen";
  static const String onBoardRoute = "/onBoard";
  static const String loginRoute = "/login";
  static const String signUpRoute = "/signup";
  static const String appSettingsRoute = "/appSettings";
  static const String homeRoute = "/home";
  static const String searchRoute = "/search";
  static const String profileRoute = "/profile";
  static const String changePassRoute = "/changePassword";
  // static const String

  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case appSettingsRoute:
      // {
      //   return MaterialPageRoute(
      //     builder: (_) => const AppSettings(),
      //   );
      // }

      case splashRoute:
        {
          return MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => const SplashScreen(),
          );
        }
      case onBoardRoute:
        {
          return MaterialPageRoute(
            builder: (_) => OnBoardingScreen(),
          );
        }

      case loginRoute:
        {
          return MaterialPageRoute(
            builder: (_) => LoginScreen(),
          );
        }
      case signUpRoute:
        {
          return MaterialPageRoute(
            builder: (_) => SignUpScreen(),
          );
        }

      case searchRoute:
      // {
      //   return MaterialPageRoute(
      //     builder: (_) => const SearchScreen(),
      //   );
      // }
      case profileRoute:
      // {
      //   return MaterialPageRoute(
      //     builder: (_) => const ProfileScreen(),
      //   );
      // }

      case changePassRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const ForgotPassword(),
          );
        }
      case homeRoute:
        {
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
          );
        }
    }
    return null;
  }
}
