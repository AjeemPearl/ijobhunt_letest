import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:ijobhunt/core/models/employerlikedjobs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/routes/api.routes.dart';
import '../models/get_fev_jobs.dart';

class FebJobs {
  static Future saveFebJobs(String token, int jobid) async {
    Map data = {'token': token, 'job_id': jobid.toString()};
    final response = await http.post(
      Uri.parse(
        ApiRoutes.favJobs,
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
    } else {
      throw Exception();
    }
  }

  static Future removeFavJobs(String token, int jobid) async {
    Map data = {'token': token, 'job_id': jobid.toString()};
    final response = await http.post(
      Uri.parse(
        ApiRoutes.removefavjobs,
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );
    if (response.statusCode == 201) {
      print("job saved");
    } else {
      throw Exception();
    }
  }

  static Future<List<FevJobsGetModel>> getFavJobs(String token) async {
    Map data = {'token': token};
    final response = await http.post(
      Uri.parse(
        ApiRoutes.getfavJobs,
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 201) {
      print(response.body);
      final List favjob = json.decode(response.body);
      return favjob.map((e) => FevJobsGetModel.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }

  static Future<List<EmployerLikedJob>?> employerLikedJobs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {'token': pref.getString(AppKeys.userData)};
    final response = await http.post(
      Uri.parse(
        ApiRoutes.getemployerlikedjobs,
      ),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 201) {
      print(response.body);
      final List likedjob = json.decode(response.body);
      return likedjob.map((e) => EmployerLikedJob.fromJson(e)).toList();
    } else {
      throw Exception();
    }
  }
}
