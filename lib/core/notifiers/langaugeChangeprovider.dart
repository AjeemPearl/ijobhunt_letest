import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/l10n.dart';

class LanguageChangeProvider with ChangeNotifier {
  Locale? currentLocale;
  Locale? get locale => currentLocale;

  LanguageChangeProvider() {
    loadFromPrefs();
  }

  void changeLocale(Locale locale) {
    if (L10n.all.contains(locale)) {
      currentLocale = locale;
      saveLanguage();
    }
    currentLocale;
    return notifyListeners();
  }

  void clearLocale() {
    currentLocale = null;
    notifyListeners();
  }

  changeLanguage() async {
    currentLocale = currentLocale;
  }

  saveLanguage() async {
    saveLocal(language: currentLocale!.toLanguageTag());
  }

  loadFromPrefs() async {
    var val = await getLocal();
    currentLocale = Locale(val);
    return notifyListeners();
  }

  Future saveLocal({required String language}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString("code", language);
  }

  Future getLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("code") ?? "en";
  }
}
