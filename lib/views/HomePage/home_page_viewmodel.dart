import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/views/LocationSelect/location_select.dart';

class HomePageViewModel extends BaseViewModel {
  dynamic stationStart;
  dynamic stationDestination;
  DateTime? selectedDate;
  TimeOfDay? selectedTimeOfDay;

  String? stationStartName;
  String? stationDestinationName;

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
    TimeOfDay? td = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (td != null) {
      selectedTimeOfDay = td;
    }
    notifyListeners();
  }

  Future<void> selectCity(dynamic context, String type) async {
    final loc = Localizations.localeOf(context);
    String localizedName(Locale locale) {
      if (locale.languageCode == 'zh') return "Zh_tw";
      return "En";
    }

    dynamic result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LocationSelectView(title: type == "start" ? "出發點" : "目的地"),
      ),
    );

    if (result != null) {
      if (type == "start") {
        stationStart = result;
        stationStartName = result["StationName"][localizedName(loc)];
      } else {
        stationDestination = result;
        stationDestinationName = result["StationName"][localizedName(loc)];
      }
    }
    notifyListeners();
  }

  void swap() {
    var temp = stationStart;
    var temp2 = stationStartName;
    stationStart = stationDestination;
    stationDestination = temp;
    stationStartName = stationDestinationName;
    stationDestinationName = temp2;
    notifyListeners();
  }

  Future<void> search(BuildContext context) async {
    context.push(
      "/TRA/search",
      extra: {
        "date": selectedDate ?? DateTime.now(), // "yy
        "time": selectedTimeOfDay ?? TimeOfDay.now(), // yy-MM-dd" format
        "start": stationStart,
        "destination": stationDestination
      },
    );
  }
}
