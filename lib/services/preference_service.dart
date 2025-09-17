
import 'package:shared_preferences/shared_preferences.dart';
class PreferenceService {
  static final PreferenceService _instance = PreferenceService._internal();

  PreferenceService._internal();

  factory PreferenceService(){
    return _instance;
  }

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  SharedPreferences get instance => _prefs;

}