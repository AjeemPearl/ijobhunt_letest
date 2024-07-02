import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:ijobhunt/screens/loginScreen/widget/resetpassword.dart';
import 'package:ijobhunt/screens/loginScreen/widget/showdialogbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotePassrdAuthantication {
  static Future<dynamic> setusertoken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static Future forgotePassword({
    required email,
    required BuildContext context,
  }) async {
    Map data = {'email': email};
    final response = await http.post(
      Uri.parse(ApiRoutes.forgotepassword),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsondecoded = jsonDecode(response.body);
      var status = jsondecoded['status'];
      if (status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(
              text:
                  "OTP sent sucessfully,Please check your email that you enterd ",
              context: context),
        );
        ShowForgotPassword.buildotpdialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            text: "email address does not exist", context: context));
      }
    } else {
      return null;
    }
  }

  static Future veryfiOTP({required OTP, required BuildContext context}) async {
    Map data = {'otp': OTP};
    final response = await http.post(
      Uri.parse(ApiRoutes.veryfiotp),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      print(response.body);
      Map<String, dynamic> decodeddata = jsonDecode(response.body);
      var sucess = decodeddata['success'];
      setusertoken(decodeddata['token']);
      if (sucess == 'Succfully' && sucess != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackUtil.stylishSnackBar(
              text: "OTP Verified sucessfully", context: context),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ResetPassword(),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: "Please Enter Vailed OTP", context: context),
      );
    }
  }

  static Future updatePassword(
      {required password, required BuildContext context}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {
      'token': pref.getString('token') ?? '',
      'password': password,
    };
    final response = await http.post(
      Uri.parse(ApiRoutes.changepassword),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackUtil.stylishSnackBar(
            text: "Password Updated successfully", context: context),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }
  }
}
