import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends BaseViewModel {
  SharedPreferences? _prefs;

  bool _useTestData = false;
  bool _enableMaterialYou = true;
  bool _debugMode = false;

  bool get useTestData => _useTestData;
  bool get enableMaterialYou => _enableMaterialYou;
  bool get debugMode => _debugMode;

  Future<void> init() async {
    setBusy(true);
    _prefs = await SharedPreferences.getInstance();
    _useTestData = _prefs!.getBool("useTestData") ?? false;
    _enableMaterialYou = _prefs!.getBool("enableMaterialYou") ?? true;
    _debugMode = _prefs!.getBool("debugMode") ?? false;
    setBusy(false);
  }

  void setUseTestData(bool value) {
    _useTestData = value;
    _prefs?.setBool("useTestData", value);
    notifyListeners();
  }

  void setEnableMaterialYou(bool value) {
    _enableMaterialYou = value;
    _prefs?.setBool("enableMaterialYou", value);
    notifyListeners();
  }

  void setDebugMode(bool value) {
    _debugMode = value;
    _prefs?.setBool("debugMode", value);
    notifyListeners();
  }
}
