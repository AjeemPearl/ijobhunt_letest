


import 'package:ijobhunt/app/constants/app.keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences{

  static late SharedPreferences _preferences;
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }



  static bool getOnBoardDone() {
    return _preferences.getBool(AppKeys.onBoardDone) ?? false;
  }

  static void setOnBoardDone() {
    _preferences.setBool(AppKeys.onBoardDone, true);
  }
  static String getUserType() {
    return _preferences.getString(AppKeys.userType) ?? '';
  }

  static void setUserType(String userType) {
    _preferences.setString(AppKeys.userType, userType);
  }

  static String getCountry() {
    return _preferences.getString(AppKeys.country) ?? '';
  }

  static void setCountry(String country) {
    _preferences.setString(AppKeys.country, country);
  }

  static String getUserData() {
    return _preferences.getString(AppKeys.userData) ?? '';
  }

  static void setUserData(String userData) {
    _preferences.setString(AppKeys.userData, userData);
  }


  static String getCompanyData() {
    return _preferences.getString(AppKeys.companyData) ?? '0';
  }

  static void setCompanyData(String companyData) {
    _preferences.setString(AppKeys.companyData, companyData);
  }

  static String getCompanyStatus() {
    return _preferences.getString(AppKeys.companyStatus) ?? '0';
  }

  static void setCompanyStatus(String companyStatus) {
    _preferences.setString(AppKeys.companyStatus, companyStatus);
  }

  static void clearCredential(){
    String country = getCountry();
    _preferences.clear();
    setOnBoardDone();
    setCountry(country);
  }


  static String getUserName() {
    return _preferences.getString(AppKeys.userName) ?? '';
  }

  static void setUserName(String uname) {
    _preferences.setString(AppKeys.userName, uname);
  }
}