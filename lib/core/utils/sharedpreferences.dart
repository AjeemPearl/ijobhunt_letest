import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggedInUserBloc {
  // ignore: constant_identifier_names
  static const _USERID_KEY = "__user_id__";
  static const _token_ = "__token__";

  Future<String> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString(_USERID_KEY) ?? "0";

    return userId;
  }

  Future<String> getUserToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userToken = pref.getString(_token_) ?? "0";

    return userToken;
  }

  Future<String> setUserId(String userToken) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(_token_, userToken);
    return userToken;
  }

  Future<String> setUserToken(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(_USERID_KEY, userId);
    return userId;
  }

  Future logout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(
      _USERID_KEY,
    );
    return;
  }
}
