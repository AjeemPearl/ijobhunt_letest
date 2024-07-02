import 'dart:convert';
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/app/routes/api.routes.dart';
import 'package:ijobhunt/core/models/company_model.dart';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/core/models/recomendedcandidates.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployerCompanydata {
  static String? companyname;
  static bool isloading = false;
  static Future<CompanyData?> getCompanydata({required token}) async {
    Map data = {'token': token};
    try {
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
        var jsondecoded = jsonDecode(response.body);
        //for (var i in jsondecoded) {}
        return CompanyData.fromJson(
          jsondecoded,
        );
      }
    } catch (e) {
      print("Error is ${e}");
    }
  }

  static Future<RecomndedCandidates?> getReomndedCandidate() async {
    //isloading = true;
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {'token': pref.getString(AppKeys.userData) ?? ''};
    final response = await http.post(
      Uri.parse(ApiRoutes.getrecomndedcondidates),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      Map<String, dynamic> user = jsonDecode(response.body);

      print(response.body);

      var jsondecoded = jsonDecode(response.body);

      return RecomndedCandidates.fromJson(
        jsondecoded,
      );
    }
    //isloading = false;
    return null;
  }

  static Future<List<User>?> getCandidateDetails({required id}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {'token': pref.getString(AppKeys.userData)};
    final response = await http.post(
      Uri.parse(ApiRoutes.getrecomndedcondidates),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      final List jsondecoded = jsonDecode(response.body)['user'];
      //for (var i in jsondecoded) {}
      return jsondecoded
          .map((e) => User.fromJson(e))
          .where(
            (element) => element.id.toString().contains(id),
          )
          .toList();
    }
    return null;
  }
}
