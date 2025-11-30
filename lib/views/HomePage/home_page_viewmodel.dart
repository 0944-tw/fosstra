import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/models/TDX.dart';
import 'package:tra/services/preference_service.dart';
import 'package:tra/views/LocationSelect/location_select.dart';

class HomePageViewModel extends BaseViewModel {
  final SharedPreferences _prefs = PreferenceService().instance;

  Station? stationStart;
  Station? stationDestination;

  String? stationStartName;
  String? stationDestinationName;

  DateTime? selectedDate;
  TimeOfDay? selectedTimeOfDay;

  Future<void> updateDateTime(dynamic context) async {
    DateTime? time = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
      initialDate: DateTime.now(),
    );
    selectedDate = time;
    notifyListeners();
  }

  Future<void> updateTimeOfDay(dynamic context) async {
    TimeOfDay? td = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (td != null) {
      selectedTimeOfDay = td;
    }
    notifyListeners();
  }

  Future<void> selectCity(dynamic context, String type) async {
    final loc = Localizations.localeOf(context);

    dynamic result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (context) => LocationSelectView(title: type == "start" ? "出發點" : "目的地")),
    );

    if (result != null) {
      if (type == "start") {
        stationStart = Station.fromJson(result);
        // stationStartName = result["StationName"][localizedName(loc)];
      } else {
        stationDestination = Station.fromJson(result);
        // stationDestinationName = result["StationName"][localizedName(loc)];
      }
      if (Localizations.localeOf(context).languageCode == "zh") {
        stationStartName = stationStart?.stationName.zhTw;
        stationDestinationName = stationDestination?.stationName.zhTw;
      } else {
        stationStartName = stationStart?.stationName.en;
        stationDestinationName = stationDestination?.stationName.en;
      }
    }
    notifyListeners();
  }

  void init(BuildContext context) async {
    String? lastStationStart = _prefs.getString("lastStationStart");
    String? lastStationDestination = _prefs.getString("lastStationDestination");

    if (lastStationStart != null) {
      stationStart = Station.fromJson(json.decode(lastStationStart));
    }
    if (lastStationDestination != null) {
      stationDestination = Station.fromJson(json.decode(lastStationDestination));
    }
    if (Localizations.localeOf(context).languageCode == "zh") {
      stationStartName = stationStart?.stationName.zhTw;
      stationDestinationName = stationDestination?.stationName.zhTw;
    } else {
      stationStartName = stationStart?.stationName.en;
      stationDestinationName = stationDestination?.stationName.en;
    }
  }

  void swap() {
    var temp = stationStart;
    // var temp2 = stationStartName;
    stationStart = stationDestination;
    stationStartName = stationDestinationName;

    stationDestination = temp;
    stationDestinationName = stationStartName;
    // stationStartName = stationDestinationName;
    notifyListeners();
  }

  Future<void> search(BuildContext context) async {
    _prefs.setString("lastStationStart", json.encode(stationStart?.toJson()));
    _prefs.setString("lastStationDestination", json.encode(stationDestination?.toJson()));
    context.push(
      "/TRA/search",
      extra: {
        "date": selectedDate ?? DateTime.now(), // "yy
        "time": selectedTimeOfDay ?? TimeOfDay.now(), // yy-MM-dd" format
        "start": stationStart,
        "destination": stationDestination,
      },
    );
  }
}
