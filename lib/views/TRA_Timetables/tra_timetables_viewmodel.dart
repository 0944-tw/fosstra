import 'dart:convert';
import 'dart:ui';

import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class TRATimetablesViewmodel extends BaseViewModel {
  List<dynamic> stopTimes = [];
  Map<String, dynamic>? trainInfo = {};

  Future<void> fetchTimetables(int trainTypeID) async {
    setBusy(true);
    final response = await http.get(
      Uri.parse(
        "https://raw.githubusercontent.com/0944-tw/TaiwanRailwayData/refs/heads/main/TRA/DailyTrainTimetables/$trainTypeID.json",
      ),
    );
    final Map<String, dynamic> dailyTrainTimetables = json.decode(response.body);
    stopTimes = dailyTrainTimetables["StopTimes"];
    trainInfo = dailyTrainTimetables["TrainInfo"];
    setBusy(false);
  }

  String getLanguageCode(Locale locale) {
    if (locale.languageCode == 'zh') {
      return "Zh_tw";
    }
    return "En";
  }
}
