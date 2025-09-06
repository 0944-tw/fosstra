import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/views/LocationSelect.dart';
import 'package:tra/views/TRA_SearchPage/TRA_SearchPage.dart';

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
      lastDate: DateTime.now().add(
        Duration(days: 30),
      ),
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
    dynamic result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LocationSelectPage(title: type == "start" ? "出發點" : "目的地"),
      ),
    );

    if (result != null) {

        if (type == "start") {
          stationStart = result;
          stationStartName = result["StationName"]["Zh_tw"];
        } else {
          stationDestination = result;
          stationDestinationName = result["StationName"]["Zh_tw"];
        }

    }
    notifyListeners();
  }
  void Swap(){
    var temp = stationStart;
    var temp2 = stationStartName;
    stationStart = stationDestination;
    stationDestination = temp;
    stationStartName = stationDestinationName;
    stationDestinationName = temp2;
    notifyListeners();
  }
  Future<void> Search(dynamic context) async {
   await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => TRASearchPage(
          startStation: stationStart,
          desStation: stationDestination,
          dateTime: selectedDate ?? DateTime.now(), // "yy
          timeOfDay: selectedTimeOfDay ?? TimeOfDay.now(), // yy-MM-dd" format
        ),
      ),
    );
  }
}