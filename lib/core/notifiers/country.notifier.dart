import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/core/models/company_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/routes/api.routes.dart';

class CountriesData {
  static Future<List> getcountries() async {
    final response = await http.get(
      Uri.parse(
        ApiRoutes.getcocountriesapi,
      ),
    );
    print('Country' + response.body);
    if (response.statusCode == 201) {
      //print(response.body);
      var country = json.decode(response.body) as List;
      return country;
    } else {
      throw Exception();
    }
  }
  static Future<List> getPhoneCodes() async {
    final response = await http.get(
      Uri.parse(
        ApiRoutes.countryCodes,
      ),
    );
    if (response.statusCode == 201) {
      print(response.body);
      var country = json.decode(response.body) as List;
      return country;
    } else {
      throw Exception();
    }
  }


  static Future<List<Company>?> editGetData() async {
    List<Company> compnay = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {'token': pref.getString(AppKeys.userData) ?? ''};
    final response = await http.post(
      Uri.parse(ApiRoutes.getcompanydata),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      print('profile: ' + response.body);
      var responseJson = json.decode(response.body)['company'] as List;
      compnay = responseJson.map((e) => Company.fromJson(e)).toList();
      return compnay;
    } else {
      throw Exception();
    }
  }
}
