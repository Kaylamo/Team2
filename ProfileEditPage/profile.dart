import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_gas/page/profile_page.dart';
import 'package:my_gas/themes.dart';
import 'package:my_gas/utils/user_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'User Profile';
  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;
    return ThemeProvider(
      initTheme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'MyTitle',
          theme: user.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
          home: ProfilePage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
