import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'global_variable.dart';
import 'theme.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Настройки', style: TextStyle(color: colorText)),
      ),
      body: Column(
        children: <Widget>[
          Row(
            // настройка 1
            children: <Widget>[
              Text('Темная тема ', style: TextStyle(color: colorText)),
              Switch(
                value: isSwitched,
                onChanged: switchOnChanged,
              )
            ],
          ),
          Row(
            // настройка 2
            children: <Widget>[
              Observer(
                  builder: (_) => Text(
                        '${isEnable.isEnable}',
                        style: const TextStyle(fontSize: 20),
                      )),
            ],
          ),
          Row(
            // настройка 3
            children: <Widget>[],
          )
        ],
      ),
    );
  }

  void switchOnChanged(bool switchValue) async {
    print('switchOnChanged');
    dispose;

    if (switchValue == true) {
      await prefs.setString('theme', 'dark');
      isEnable.getTrue();
      setState(() {
        isSwitched = true;

        bottomNavBarColor = bottomNavBarColorDark;
        backgroundColorNavBar = backgroundColorDarkNavBar;
        buttonBackgroundColor = buttonBackgroundColorDark;
        appBarColor = appBarColorDark;
        backgroundColor = backgroundColorDark;
        colorText = colorTextDark;
        iconColor = iconColorDark;
      });
    } else {
      await prefs.setString('theme', 'light');
      isEnable.getFalse();
      setState(() {
        isSwitched = false;

        bottomNavBarColor = bottomNavBarColorLight;
        backgroundColorNavBar = backgroundColorLightNavBar;
        buttonBackgroundColor = buttonBackgroundColorLight;
        appBarColor = appBarColorLight;
        backgroundColor = backgroundColorLight;
        colorText = colorTextLight;
        iconColor = iconColorLight;
      });
    }
  }
}
