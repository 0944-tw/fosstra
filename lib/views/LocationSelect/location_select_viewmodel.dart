// location_select_viewmodel.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import 'package:tra/main.dart';

class LocationSelectViewModel extends BaseViewModel {

  Map<String, List> _stations = {};
  List<MapEntry<String, dynamic>> _stationsList = [];
  List<dynamic> _selectedStations = [];

  List<MapEntry<String, dynamic>> get cities => _stationsList;
  List<dynamic> get selectedStations => _selectedStations;

  Future<void> init() async {
    setBusy(true);
    await _fetchFormattedStations();
    setBusy(false);
  }

  // 3. 業務邏輯 (Business Logic)
  Future<void> _fetchFormattedStations() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://raw.githubusercontent.com/0944-tw/TaiwanRailwayData/refs/heads/main/TestingData/TRA_Stations.json',
        ),
        headers: {
          "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0",
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final Map<String, List> tempStations = {};
        for (var item in data) {
          var city = item["LocationCityCode"];
          if (!tempStations.containsKey(city)) {
            tempStations[city] = [];
          }
          tempStations[city]!.add(item);
        }
        _stations = tempStations;
        _stationsList = _stations.entries.toList();

      } else {
      /*
        await _dialogService.showDialog(
          title: '請求錯誤',
          description: '狀態碼: ${response.statusCode}\n內容: ${response.body}',
        );

       */

      }
    } catch (err) {
       /*
       await _dialogService.showDialog(
        title: '發生預期外的錯誤',
        description: err.toString(),
      );

        */
    }
     notifyListeners();
  }

  void selectCity(int index) {
    _selectedStations = _stationsList[index].value;
    notifyListeners();
  }

  void stationSelected(dynamic context,dynamic station) {
    Navigator.pop(context, station);
  }

  String getLocalizedStationName(dynamic station, Locale locale) {
    if (locale.languageCode == 'zh') {
      return station["StationName"]["Zh_tw"];
    }
    return station["StationName"]["En"];
  }
}