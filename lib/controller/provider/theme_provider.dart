import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool check = false;
  final kThemePref = "theme_pref";
  ThemeData _theme;

  bool get checker {
    return check;
  }

  ThemeData get theme {
    if (_theme == null) {
      _theme = themeData[AppTheme.Light];
    }
    return _theme;
  }

  changeTheme() async {
    if (check) {
      print('light');
      check = false;
      _theme = themeData[AppTheme.Light];
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool(kThemePref, check);
    } else {
      print('dark');
      check = true;
      _theme = themeData[AppTheme.Dark];
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool(kThemePref, check);
    }
    notifyListeners();
  }

  void loadTheme() {
    debugPrint("Entered loadTheme()");
    SharedPreferences.getInstance().then((prefs) {
      bool preferredTheme = prefs.getBool(kThemePref) ?? 0;
      check = preferredTheme;
      if (preferredTheme) {
        print('loadedDark');
        _theme = themeData[AppTheme.Dark];
      } else {
        print('loadedLight');

        _theme = themeData[AppTheme.Light];
      }
      // Once theme is loaded - notify listeners to update UI
      notifyListeners();
    });
  }
}
