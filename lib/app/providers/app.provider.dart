
import 'package:ijobhunt/screens/loginScreen/AuthenticationLogin/applesignin.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../core/notifiers/authentication.notifer.dart';
import '../../core/notifiers/langaugeChangeprovider.dart';
import '../../core/notifiers/size.notifier.dart';
import '../../core/notifiers/theme.notifier.dart';

class AppProvider {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider(create: (_) => SizeNotifier()),
    ChangeNotifierProvider(create: (_) => AuthenticationNotifier()),
    ChangeNotifierProvider(create: (_) => LanguageChangeProvider()),
  ];
}
