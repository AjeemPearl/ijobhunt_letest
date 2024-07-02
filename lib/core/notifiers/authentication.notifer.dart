// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:io';
import 'package:cache_manager/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:ijobhunt/app/preferences/app_preferences.dart';
import 'package:ijobhunt/screens/companyscreen/add.company.dart';
import 'package:ijobhunt/screens/homescreens/home_page.dart';
import 'package:ijobhunt/screens/loginScreen/widget/showdialogbox.dart';
import 'package:ijobhunt/widgets/bottomnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/constants/app.keys.dart';
import '../../screens/ProfileScreen/profile_page.dart';
import '../api/authentication.api.dart';
import '../utils/snackbar.util.dart';

class AuthenticationNotifier with ChangeNotifier {
  final AuthenticationAPI _authenticationAPI = AuthenticationAPI();
  bool issiginin = false;
  bool isauthonticate = true;
  String? _passwordLevel = "";
  String? get passwordLevel => _passwordLevel;

  String? _passwordEmoji = "";
  String? get passwordEmoji => _passwordEmoji;

  void checkPasswordStrength({required String password}) {
    String mediumPattern = r'^(?=.*?[!@#\$&*~]).{8,}';
    String strongPattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    if(password == ''){
      _passwordEmoji = '';
      _passwordLevel = '';
      notifyListeners();
    }else if (password.contains(RegExp(strongPattern))) {
      _passwordEmoji = '🚀';
      _passwordLevel = 'Strong';
      notifyListeners();
    } else if (password.contains(RegExp(mediumPattern))) {
      _passwordEmoji = '🔥';
      _passwordLevel = 'Medium';
      notifyListeners();
    } else if (!password.contains(RegExp(strongPattern))) {
      _passwordEmoji = '😢';
      _passwordLevel = 'Weak';
      notifyListeners();
    }
  }

  static Future<String> setuserid(String userId) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString(AppKeys.userData, userId);
    AppPreferences.setUserData(userId);
    return userId;
  }

  static Future<dynamic> setusertoken(String userToken) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString(AppKeys.userData, userToken);
    AppPreferences.setUserData(userToken);
  }

  static Future<dynamic> setusername(String uname) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('string', uname);
    AppPreferences.setUserName(uname);
  }

  static Future<dynamic> setcompdata(String compdata) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString(AppKeys.companyStatus, compdata);
    AppPreferences.setCompanyData(compdata);
  }

  static Future<dynamic> setusertype(String usertype) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('usertype', usertype);
    AppPreferences.setUserType(usertype);
  }

  Future createAccount({
    required String useremail,
    required BuildContext context,
    required String username,
    required String userpassword,
    required String usermobileno,
    required String usertype,
    required String device_token,
  }) async {
    try {
      var userData = await _authenticationAPI.createAccount(
        useremail: useremail,
        username: username,
        usermobileno: usermobileno,
        userpassword: userpassword,
        usertype: usertype,
        device_token: device_token,
      );
      if (userData != null) {
        final Map<String, dynamic> parseData = await jsonDecode(userData);
        bool isAuthenticated = isauthonticate;
        if (isAuthenticated) {
          WriteCache.setString(key: AppKeys.userData, value: "authData")
              .whenComplete(
            () => ShowForgotPassword.buildSignUpPopup(context),
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => LoginScreen(),
            //   ),
            // ),
          );
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              text: "Account created Sucessfully ", context: context));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            text: "The email or Phone number you entered already exist",
            context: context));
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    }
  }

  Future userLogin(
      {required String useremail,
      required BuildContext context,
      required String userpassword,
      required token,
      required name}) async {
    try {
      var userData = await _authenticationAPI.userLogin(
          useremail: useremail,
          userpassword: userpassword,
          token: token,
          name: name);
      if (userData != null) {
        final Map<String, dynamic> parseData = await jsonDecode(userData);
        var isAuthenticated = parseData['success'];
        dynamic authData = parseData['token'];
        var comapnydata = parseData['company'].toString();
        var employeetype = parseData['user']['user_type'].toString();

        if (isAuthenticated != null) {
          setuserid(parseData['user']['id'].toString());
          setusername(parseData['user']['name'].toString());
          setcompdata(comapnydata);
          setusertoken(authData.toString());
          setusertype(employeetype.toString());
          WriteCache.setString(key: AppKeys.userData, value: authData)
              .whenComplete(() {
            if (employeetype == 'EMPLOYEE') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            } else if (employeetype == 'EMPLOYER' && comapnydata == '1') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
              );
            } else if (employeetype == 'EMPLOYER' && comapnydata == '0') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCompany(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(),
                ),
              );
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
              text: "Sucessfully login ", context: context));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            text: "Wrong Email or Password", context: context));
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: 'Oops No You Need A Good Internet Connection',
          context: context));
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
