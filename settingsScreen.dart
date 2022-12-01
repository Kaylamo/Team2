import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.light(), // Provide light theme.
      darkTheme: Themes.dark(), // Provide dark theme.
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(),
        body: Container(),
      ),
    );
  }
}

class Themes{
  static final light = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.light(),
  );
  static final dark = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.dark(),
  );
}

class CurrentTheme extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;
  bool get isLightMode => themeMode == ThemeMode.light;
}