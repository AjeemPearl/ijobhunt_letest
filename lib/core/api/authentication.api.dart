import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/routes/api.routes.dart';

class AuthenticationAPI {
  final client = http.Client();
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };

//User Sign Up
  Future createAccount({
    required String useremail,
    required String username,
    required String usermobileno,
    required String userpassword,
    required String usertype,
    required String device_token,
  }) async {
    final Uri uri = Uri.parse(ApiRoutes.signupurl);
    final http.Response response = await client.post(
      uri,
      headers: headers,
      body: jsonEncode({
        "email": useremail,
        "password": userpassword,
        "name": username,
        "phone": usermobileno,
        "user_type": usertype,
        "device_token": device_token,
      }),
    );

    print('UserDetails: '+ response.body.toString());
    if (response.statusCode == 201) {
      final dynamic body = response.body;
      return body;
    } else {
      const dynamic body = null;
      return body;
    }
  }

  Future userLogin(
      {required String name,
      required String token,
      required String useremail,
      required String userpassword}) async {
    final Uri uri = Uri.parse(ApiRoutes.loginapi);
    final http.Response response = await client.post(
      uri,
      headers: headers,
      body: jsonEncode({
        "email": useremail,
        "password": userpassword,
        "token": token,
        "name": name,
      }),
    );
    print('Login response: ' + response.body);
    if (response.statusCode == 201) {
      final dynamic body = response.body;
      return body;
    } else {
      const dynamic body = null;

      return body;
    }
  }
}
