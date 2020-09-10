import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider extends ChangeNotifier {
  double _fontSize;
  String _fontFamily;
  final kFontSizePref = 'font_size_pref';
  final kFontFamilyPref = 'font_family_pref';

  double get fontSize {
    if (_fontSize == null) {
      _fontSize = 15;
    } else if (_fontSize == 0.0) {
      _fontSize = 15;
    }
    return _fontSize;
  }

  String get fontFamily {
    if (_fontFamily == null) {
      _fontFamily = 'NotoSerif';
    }
    return _fontFamily;
  }

  changeFontSize(double size) async {
    _fontSize = size;
    var prefs = await SharedPreferences.getInstance();
    prefs.setDouble(kFontSizePref, _fontSize);
    notifyListeners();
  }

  changeFontFamily(String ff) async {
    _fontFamily = ff;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(kFontFamilyPref, _fontFamily);
    notifyListeners();
  }

  void loadFontSizePref() {
    debugPrint("Entered loadFontSizePref()");
    SharedPreferences.getInstance().then((prefs) {
      double preferredTheme = prefs.getDouble(kFontSizePref) ?? 0;
      _fontSize = preferredTheme;

      notifyListeners();
    });
  }

  void loadFontFamilyPref() {
    debugPrint("Entered loadFontFamilyPref()");
    SharedPreferences.getInstance().then((prefs) {
      String preferredTheme = prefs.getString(kFontFamilyPref) ?? 0;
      _fontFamily = preferredTheme;

      notifyListeners();
    });
  }
}
