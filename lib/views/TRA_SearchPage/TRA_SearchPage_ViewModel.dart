import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TRASearchPageViewModel extends BaseViewModel {
  List<dynamic> trainTimeTables = [];
  Map<int, GlobalKey> itemKeys = {};
  Map<int, Map<int, int>> pricesByDirection = {};
  int closetIndex = 0;

  final ScrollController scrollController = ScrollController();

  String currentTime = "${TimeOfDay
      .now()
      .hour}:${TimeOfDay
      .now()
      .minute}";

  int toMinutes(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1].padLeft(2, '0'));
    return hours * 60 + minutes;
  }

  int getTrainPrice(int TrainType) {
    return 0;
  }

  // shit shan!!!
  Future<void> fetchTrain(startID, endID, dateString) async {
    final response = await http.get(
      Uri.parse(
        "http://btr-tra-api.vercel.app/api/v3/Rail/TRA/DailyTrainTimetable/OD/$startID/to/$endID/$dateString",
      ),
      headers: {
        "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0",
      },
    );
    final priceResponse = await http.get(Uri.parse(
        'https://raw.githubusercontent.com/0944-tw/TaiwanRailwayData/refs/heads/main/TRA/ODFare/$startID/$endID.json'));
    if (priceResponse.statusCode == 200) {
      final Map<String, dynamic> priceData = json.decode(priceResponse.body);
      for (int i = 0; i < priceData["TrainFares"].length; i++) {
        var Fare = priceData["TrainFares"][i];
        var Direction = Fare["Direction"] as int;
    if (!pricesByDirection.containsKey(Direction)) {
      pricesByDirection[Direction] = {};
    }
    pricesByDirection[Direction]![Fare["TrainType"]] = Fare["Fares"][0]["Price"];
    }


    }
    if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    trainTimeTables = data["TrainTimetables"];
    trainTimeTables.sort((item1, item2) {
    int d1 = toMinutes(item1["StopTimes"][0]["DepartureTime"]);
    int d2 = toMinutes(item2["StopTimes"][0]["DepartureTime"]);
    return d1.compareTo(d2);
    });
    itemKeys = {
    for (int i = 0; i < trainTimeTables.length; i++) i: GlobalKey(),
    };
    dynamic closestTrain;
    for (int i = 0; i < trainTimeTables.length; i++) {
    int trainDepartureMinutes = toMinutes(
    trainTimeTables[i]["StopTimes"][0]["DepartureTime"],
    );
    int nowMinutes = toMinutes(
    "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
    );
    if (trainDepartureMinutes < nowMinutes) {
    continue;
    }
    if (closestTrain != null) {
    int closestDepartureMinutes = toMinutes(
    closestTrain["StopTimes"][0]["DepartureTime"],
    );
    if ((trainDepartureMinutes - nowMinutes) <
    (closestDepartureMinutes - nowMinutes)) {
    closestTrain = trainTimeTables[i];
    closetIndex = i;
    }
    } else {
    closestTrain = trainTimeTables[i];
    closetIndex = i;
    }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = itemKeys[closetIndex]?.currentContext;
    if (context != null) {
    Scrollable.ensureVisible(
    context,
    duration: Duration(milliseconds: 650),
    alignment: 0.5,
    curve: Curves.easeOutExpo,
    );
    }
    });

    setBusy(false);
    } else {
    setError('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}
