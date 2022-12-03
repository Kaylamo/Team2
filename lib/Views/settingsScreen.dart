import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Themes.light, // Provide light theme.
      darkTheme: Themes.dark, // Provide dark theme.
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Center(
              child: SwitchScreen()
        ),
        ),
      //),
    );
  }
}

class Themes{
  static final light = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(),
  );
  static final dark = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(),
  );
}

class CurrentTheme extends ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;
}

class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  bool isSwitched = false;
  var textValue = 'Light Mode';

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        isSwitched = true;
        textValue = 'Dark Mode';
      });
      print('Light Mode');
    }
    else
    {
      setState(() {
        isSwitched = false;
        textValue = 'Light Mode';
      });
      print('Dark Mode');
    }
  }
  @override
  Widget build(BuildContext context) {
    //final currentTheme = Provider.of<CurrentTheme>(context);
    return //Switch.adaptive(value: currentTheme.isDarkMode, onChanged: (bool value) {  },);
    Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[ Transform.scale(
            scale: 2,
            child: Switch(
              onChanged: toggleSwitch,
              value: isSwitched,
              activeColor: Colors.black,
              activeTrackColor: Colors.grey,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.black,
            )
        ),
          Text('$textValue', style: TextStyle(fontSize: 20),)
        ]);
  }
}