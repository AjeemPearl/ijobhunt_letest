// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:ijobhunt/app/preferences/app_preferences.dart';
import 'package:ijobhunt/screens/splashScreen/select_countary.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constants/app.colors.dart';
import '../../app/constants/app.keys.dart';
import '../ProfileScreen/profile_page.dart';
import '../companyscreen/add.company.dart';
import '../homescreens/home_page.dart';
import '../loginScreen/login.view.dart';
import '../onBoardingScreen/onBoarding.screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /*var usertype = '';
  var compdata = '';
  var country = '';

  Future getInitialData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    usertype = pref.getString(AppKeys.appMode) ?? '';
    country = pref.getString(AppKeys.country) ?? '';
    compdata = pref.getString(AppKeys.companyStatus) ?? '0';

    if (mounted) {
      setState(() {});
    }
  }*/

  @override
  void initState() {
    //getInitialData();
    Timer(const Duration(seconds: 2), (){

      //print(AppPreferences.getCompanyStatus());
      if(!AppPreferences.getOnBoardDone()){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnBoardingScreen(),));
      }else if(AppPreferences.getCountry() == ''){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SelectCountry(),));
      }else if(AppPreferences.getUserData() == ''){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }else if(AppPreferences.getUserType() == 'EMPLOYEE'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else if (AppPreferences.getUserType() == 'EMPLOYER' && AppPreferences.getCompanyData() == '0' || AppPreferences.getCompanyData() == '0') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddCompany()));
      } else if (AppPreferences.getUserType() == 'EMPLOYER' && AppPreferences.getCompanyData() == '1' || AppPreferences.getCompanyData() == '1') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomNavBar()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
      }

    });
    super.initState();
  }

  /*Future _initiateCache() async {
    return CacheManagerUtils.conditionalCache(
      key: AppKeys.onBoardDone,
      valueType: ValueType.StringValue,
      actionIfNull: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnBoardingScreen(),
          ),
        ).whenComplete(() => {
              WriteCache.setString(key: AppKeys.onBoardDone, value: 'Something')
            });
      },
      actionIfNotNull: () {
        country.isEmpty
            ? Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectCountry(),
                ),
              )
            : CacheManagerUtils.conditionalCache(
                key: AppKeys.userData,
                valueType: ValueType.StringValue,
                actionIfNull: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                actionIfNotNull: () {
                  if (usertype == 'EMPLOYEE') {

                  }
                },
              );
      },
    );

  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/logo/logo2.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
