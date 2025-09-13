import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/services/PreferenceService.dart';

class SettingsLocalePageViewModel extends BaseViewModel {
  final SharedPreferences _prefs = PreferenceService().instance;

  late Locale _locale;

  Locale get locale => _locale;

  void updateLocale(Locale locale) {
    _locale = locale;
    _prefs.setString("locale", "${locale.languageCode}");
    notifyListeners();
  }
  Future<void> init(context) async {
    setBusy(true);
    String? localeString = _prefs.getString("locale");
    if (localeString == null) {
      _locale = Localizations.localeOf(context);
    } else {
      _locale = Locale.fromSubtags(
        languageCode: localeString

      );
    }
    setBusy(false);
  }
}
