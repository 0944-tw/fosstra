import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tra/services/PreferenceService.dart';

class SettingsViewModel extends BaseViewModel {
  final SharedPreferences _prefs = PreferenceService().instance;

  bool _useTestData = false;
  bool _enableMaterialYou = true;
  bool _debugMode = false;
  late Locale _locale;
  bool get useTestData => _useTestData;
  bool get enableMaterialYou => _enableMaterialYou;
  bool get debugMode => _debugMode;
  Locale get locale => _locale;

  Future<void> init(context) async {
    setBusy(true);
     _useTestData = _prefs.getBool("useTestData") ?? false;
    _enableMaterialYou = _prefs.getBool("enableMaterialYou") ?? true;
    _debugMode = _prefs.getBool("debugMode") ?? false;
    String? localeString = _prefs.getString("locale");
    if (localeString == null) {
      _locale = Localizations.localeOf(context);
    } else {
      _locale = Locale.fromSubtags(
          languageCode: localeString

      );
    }
    notifyListeners();
    setBusy(false);
  }

  void setUseTestData(bool value) {
    _useTestData = value;
    _prefs.setBool("useTestData", value);
    notifyListeners();
  }

  void setEnableMaterialYou(bool value) {
    _enableMaterialYou = value;
    _prefs.setBool("enableMaterialYou", value);
    notifyListeners();
  }

  void setDebugMode(bool value) {
    _debugMode = value;
    _prefs.setBool("debugMode", value);
    notifyListeners();
  }

  void resetData(){
    _prefs.clear();
  }
  Future<void> changeLanguage(context){
      return showDialog<void>(
        context: context,
        barrierDismissible: false, //
        builder: (BuildContext context) {
          Locale? SelectedLocale;
          return AlertDialog(
            title: const Text('Select Language'),
            content: SingleChildScrollView(
              child: ListBody(
                children:  <Widget>[
                  RadioListTile<Locale>(
                    title: const Text('English'),
                    value: Locale.fromSubtags(countryCode: "us"),
                    onChanged: (Locale? value) {
                      SelectedLocale = value;
                      Navigator.of(context).pop();
                    },
                    groupValue: SelectedLocale,
                  ),
                  RadioListTile<Locale>(
                    title: const Text('繁體中文'),
                    value: Locale.fromSubtags(countryCode: "zh"),
                    onChanged: (Locale? value) {
                      SelectedLocale = value;
                      Navigator.of(context).pop();
                    },
                    groupValue: SelectedLocale,
                  ),
                ],
              ),
            ),
            actions: <Widget>[

            ],
          );
        },
      );

  }
}
