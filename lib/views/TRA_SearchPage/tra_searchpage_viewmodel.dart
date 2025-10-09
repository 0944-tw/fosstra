import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class TRASearchPageViewModel extends BaseViewModel {
  List<dynamic> trainTimeTables = [];
  Map<int, GlobalKey> itemKeys = {};

  Map<int, Map<int, int>> pricesByDirection = {};
  Map<String, int> delayTime = {};
  int closetIndex = 0;

  final ScrollController scrollController = ScrollController();

  String currentTime = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";

  int toMin(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1].padLeft(2, '0'));
    return hours * 60 + minutes;
  }

  int getTrainPrice(int trainType) {
    return 0;
  }

  // shit shan!!!
  Future<void> fetchTrain(context, startID, endID, dateString) async {
    setBusy(true);
    // 獲取時刻表
    final timetablesResponse = await http.get(
      Uri.parse("http://btr-tra-api.vercel.app/api/v3/Rail/TRA/DailyTrainTimetable/OD/$startID/to/$endID/$dateString"),
      headers: {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0"},
    );

    // 獲取價格
    final priceResponse = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/0944-tw/TaiwanRailwayData/refs/heads/main/TRA/ODFare/$startID/$endID.json',
      ),
    );

    //
    if (priceResponse.statusCode != 200) setError("Error when requesting the price");
    if (timetablesResponse.statusCode != 200) setError("Error when requesting the timetables");
    //
    final Map<String, dynamic> priceData = json.decode(priceResponse.body);
    final Map<String, dynamic> timetablesData = json.decode(timetablesResponse.body);
    //
    String trainNo = (timetablesData['TrainTimetables'] as List)
        .map((t) => t['TrainInfo']['TrainNo'].toString())
        .join(',');
    dynamic closestTrain;
    trainTimeTables = timetablesData["TrainTimetables"];

    final delayResponse = await http.get(
      Uri.parse("https://btr-tra-api.vercel.app/api/v3/Rail/TRA/TrainLiveBoard/TrainNo/$trainNo"),
    );
    if (delayResponse.statusCode != 200) setError("Failed to fetch delay time");
    final Map<String, dynamic> delayData = json.decode(delayResponse.body);

    // 設定誤點資料
    for (int i = 0; i < delayData["TrainLiveBoards"].length; i++) {
      if (delayData["TrainLiveBoards"][i]["DelayTime"] == 0) {
        continue;
      }
      delayTime[delayData["TrainLiveBoards"][i]["TrainNo"]] = delayData["TrainLiveBoards"][i]["DelayTime"];
    }
    // 價格
    for (int i = 0; i < priceData["TrainFares"].length; i++) {
      var fare = priceData["TrainFares"][i];
      var direction = fare["Direction"] as int;
      if (!pricesByDirection.containsKey(direction)) {
        pricesByDirection[direction] = {};
      }
      pricesByDirection[direction]![fare["TrainType"]] = fare["Fares"][0]["Price"];
    }

    // 以時間排列整理
    trainTimeTables.sort((item1, item2) {
      int d1 = toMin(item1["StopTimes"][0]["DepartureTime"]);
      int d2 = toMin(item2["StopTimes"][0]["DepartureTime"]);
      return d1.compareTo(d2);
    });

    itemKeys = {for (int i = 0; i < trainTimeTables.length; i++) i: GlobalKey()};

    // 搜尋最近列車
    for (var i = 0; i < trainTimeTables.length; i++) {
      final train = trainTimeTables[i];
      final trainDeparture = toMin(train["StopTimes"][0]["DepartureTime"]);
      final now = toMin("${TimeOfDay.now().hour}:${TimeOfDay.now().minute}");

      // 跳過之前的列車
      if (trainDeparture < now) continue;

      final closestDeparture = closestTrain == null ? null : toMin(closestTrain["StopTimes"][0]["DepartureTime"]);

      if (closestDeparture == null || trainDeparture < closestDeparture) {
        closestTrain = train;
        closetIndex = i;
      }
    }

    // 滑動到距離時間最近的列車
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
  }

  String getLanguageCode(Locale locale) {
    if (locale.languageCode == 'zh') {
      return "Zh_tw";
    }
    return "En";
  }
}
