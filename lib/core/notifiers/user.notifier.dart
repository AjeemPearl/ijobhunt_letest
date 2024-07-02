import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/user.model.dart';
import 'package:ijobhunt/core/utils/snackbar.util.dart';
import 'package:ijobhunt/screens/homescreens/jobdetails.dart';
import 'package:ijobhunt/screens/loginScreen/login.view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProFile {
  static bool isloading = false;
  static Future<UserModel> getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    isloading = true;
    Map data = {'token': pref.getString(AppKeys.userData) ?? ''};
    final response = await http.post(
      Uri.parse(
        ApiRoutes.getuserdata,
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      isloading = false;
      if (response.body.isNotEmpty) {
        Map<String, dynamic> jsondecoded = jsonDecode(response.body);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('uname', jsondecoded['user']['name'] ?? '');
        pref.setString('uemail', jsondecoded['user']['email'] ?? '');
        pref.setString('udob', jsondecoded['user']['dateofbirth'] ?? '');
        pref.setString('uphone', jsondecoded['user']['phone'] ?? '');
        pref.setString('uproff', jsondecoded['user']['profession'] ?? '');
        pref.setString('uaddress', jsondecoded['user']['address'] ?? '');
        pref.setString('uabout', jsondecoded['user']['aboutyourself'] ?? '');
        pref.setString('uimage', jsondecoded['user']['image'] ?? '');
        pref.setInt('pstatus', jsondecoded['user']['payment_status'] ?? 0);
        pref.setString('degreetitle', jsondecoded['user']['degreetitle'] ?? '');
        pref.setString(
            'institutename', jsondecoded['user']['institutename'] ?? '');
        pref.setString(
            'degreestartdate', jsondecoded['user']['degreestartdate'] ?? '');
        pref.setString(
            'degreeenddate', jsondecoded['user']['degreeenddate'] ?? '');
        pref.setString(
            'degreepercent', jsondecoded['user']['degreepercent'] ?? '');
        pref.setString('degreegrade', jsondecoded['user']['degreegrade'] ?? '');
        pref.setString(
            'degreedetails', jsondecoded['user']['degreedetails'] ?? '');
        pref.setString(
            'organizationname', jsondecoded['user']['organizationname'] ?? '');
        pref.setString('job_title', jsondecoded['user']['job_title'] ?? '');
        pref.setString(
            'jobstartDate', jsondecoded['user']['jobstartDate'] ?? '');
        pref.setString('jobendDate', jsondecoded['user']['jobendDate'] ?? '');
        pref.setString(
            'stillWorking', jsondecoded['user']['stillWorking'] ?? '');
        pref.setString('yourole', jsondecoded['user']['yourole'] ?? '');
        pref.setString('jobdetails', jsondecoded['user']['jobdetails'] ?? '');
        pref.setString(
            'usercountry', jsondecoded['user']['country'] ?? 'United States');
       // pref.setString('keyword', jsondecoded['keywords']);
        return UserModel.fromJson(
          jsonDecode(response.body),
        );
      } else {
        throw Exception();
      }
    } else {
      throw Exception();
    }
  }

  static Future<UserModel> updateuser({
    required name,
    required phone,
    required email,
    required token,
    required dateofbirth,
    required profession,
    required address,
    required aboutyourself,
    required image,
    required imageext,
    required degreetitle,
    required institutename,
    required degreestartdate,
    required degreeenddate,
    required degreepercent,
    required degreegrade,
    required degreedetails,
    required organizationname,
    required jobstartDate,
    required jobendDate,
    required stillWorking,
    required yourole,
    required jobdetails,
    required job_title,
    required usercountry,
    required keywords,
    required BuildContext context,
  }) async {
    Map data = {
      'token': token,
      'phone': phone,
      'email': email,
      'name': name,
      'dateofbirth': dateofbirth,
      'profession': profession,
      'address': address,
      'aboutyourself': aboutyourself,
      'image': image,
      'image_ext': imageext,
      'degreetitle': degreetitle,
      'institutename': institutename,
      'degreestartdate': degreestartdate,
      'degreeenddate': degreeenddate,
      'degreepercent': degreepercent,
      'degreegrade': degreegrade,
      'degreedetails': degreedetails,
      'organizationname': organizationname,
      'jobstartDate': jobstartDate,
      'jobenddate': jobendDate,
      'stillWorking': stillWorking,
      'yourole': yourole,
      'jobdetails': jobdetails,
      'job_title': job_title,
      'country': usercountry,
    };
    final response = await http.post(
      Uri.parse(
        ApiRoutes.updateuser,
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
          text: "Details Updated sucessfully", context: context));
      return UserModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception();
    }
  }

  static Future deleteAccount({required BuildContext context}) async {
    SharedPreferences token = await SharedPreferences.getInstance();
    Map data = {'token': token.getString(AppKeys.userData)};
    final response = await http.post(
      Uri.parse(ApiRoutes.deleteaccount),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 204) {
      token.remove('token').whenComplete(() {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackUtil.stylishSnackBar(
            text: "Account Deleted Sucessfully", context: context));
      });
    } else {
      throw Exception();
    }
  }
}
