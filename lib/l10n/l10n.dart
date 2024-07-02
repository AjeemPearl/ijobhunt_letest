import 'dart:ui';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('es'),
    const Locale('fr'),
    const Locale('ar'),
    const Locale('zh'),
    const Locale('de'),
    const Locale('sv'),
  ];
  static String getlangauge(String val) {
    switch (val) {
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      case 'ar':
        return 'Arabic';
      case 'zh':
        return 'Chinese';
      case 'de':
        return 'german';
      case 'sv':
        return 'Swedish';
      case 'en':
      default:
        return 'English';
    }
  }
}
