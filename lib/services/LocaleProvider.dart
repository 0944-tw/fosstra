import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/services/PreferenceService.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale; LocaleProvider(this._locale);
  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
