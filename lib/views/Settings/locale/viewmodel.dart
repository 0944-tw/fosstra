import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/services/locale_provider.dart';
import 'package:tra/services/preference_service.dart';

class SettingsLocalePageViewModel extends BaseViewModel {
  final SharedPreferences _prefs = PreferenceService().instance;

  late Locale _locale;

  Locale get locale => _locale;

  void updateLocale(BuildContext context, Locale locale) {
    _locale = locale;
    _prefs.setString("locale", locale.languageCode);
    notifyListeners();
    context.read<LocaleProvider>().setLocale(locale);
  }

  Future<void> init(context) async {
    setBusy(true);
    String? localeString = _prefs.getString("locale");
    if (localeString == null) {
      _locale = Localizations.localeOf(context);
    } else {
      _locale = Locale.fromSubtags(languageCode: localeString);
    }
    setBusy(false);
  }
}
