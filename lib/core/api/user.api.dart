import 'package:http/http.dart' as http;
import '../../app/routes/api.routes.dart';

class UserAPI {
  final client = http.Client();

  Future getUserData({required String token}) async {
    final Uri uri = Uri.parse(ApiRoutes.signupurl);
    final http.Response response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Access-Control-Allow-Origin': "*",
      },
    );
    final dynamic body = response.body;
    //print(body);
    return body;
  }

  // Future getUserDetails({required String userEmail}) async {
  //   final Uri uri = Uri.parse(ApiRoutes.loginapi);
  //   final http.Response response = await client.get(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Access-Control-Allow-Origin': "*",
  //     },
  //   );
  //   final dynamic body = response.body;
  //   return body;
  // }
}
