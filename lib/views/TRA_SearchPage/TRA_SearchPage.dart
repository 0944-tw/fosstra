import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/Dialog/UnexpectedError.dart';
import 'package:tra/views/TRA_SearchPage/TRA_SearchPage_ViewModel.dart';
import 'package:tra/views/TRA_TrainTimetables.dart';


class TRASearchPage extends StatelessWidget {
  final dynamic startStation;
  final dynamic desStation;
  final dynamic dateTime;
  final dynamic timeOfDay;

  TRASearchPage({
    super.key,
    required this.startStation,
    required this.desStation,
    required this.dateTime,
    required this.timeOfDay
  });

  List<dynamic> trainTimeTables = [];
  final Map<int, GlobalKey> _itemKeys = {};

  int closetIndex = 0;
  final GlobalKey _scrollViewKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  String currentTime = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TRASearchPageViewModel>.reactive(
        viewModelBuilder: () => TRASearchPageViewModel(),
        onViewModelReady: (vm) => vm.fetchTrain(
          startStation["StationID"],
          desStation["StationID"],
          dateTime.toString().split(' ')[0],
        ),
        builder: (context,vm,child) {
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 200.0,
                    floating: false,
                    pinned: true,

                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${startStation["StationName"]["Zh_tw"]} 到 ${desStation["StationName"]["Zh_tw"]} ",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.titleLarge?.color,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "共有 ${vm.trainTimeTables.length} 個結果",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.displayMedium?.color,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: LoaderOverlay(
                closeOnBackButton: true,
                disableBackButton: false,
                child: SingleChildScrollView(
                  controller: vm.scrollController,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: vm.trainTimeTables.asMap().entries.map((entry) {
                      int index = entry.key;
                      var train = entry.value;

                      int Direction = train["TrainInfo"]['Direction'];
                      int TrainType = int.parse(train["TrainInfo"]["TrainTypeCode"]);
                      bool missed = vm.toMinutes(train['StopTimes'][0]['DepartureTime']) -
                          vm.toMinutes(vm.currentTime) <
                          0;
                      return Container(
                        key: vm.itemKeys[index],
                        child: TrainStatusCard(
                          recommended: index == vm.closetIndex,
                          timeDes: train['StopTimes'][1]["DepartureTime"] ?? '',
                          timeStart: train['StopTimes'][0]['DepartureTime'] ?? '',
                          price:  vm.pricesByDirection[Direction]![TrainType].toString()  ?? '',
                          trainNo: train["TrainInfo"]["TrainNo"],
                          trainType: train["TrainInfo"]["TrainTypeName"]["Zh_tw"],
                          missed: missed,
                        ),
                      );
                    }).toList(),


                  ),
                ),
              ),
            ),
          );
        }
    );

  }
}

class TrainStatusCard extends StatelessWidget {
  final String price;
  final String timeStart;
  final String timeDes;
  final String trainNo;
  final String trainType;
  final bool recommended;
  final bool missed;

  const TrainStatusCard({super.key,
    required this.timeDes,
    required this.timeStart,
    required this.price,
    required this.trainNo,
    required this.trainType,
    required this.recommended,
    required this.missed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: recommended
              ? Theme.of(context).colorScheme.primary
              : Color.fromARGB(0, 0, 0, 0),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Color.fromARGB(125, 255, 255, 255),
        onTap: () async {
          await Navigator.push<String>(
            context,
            MaterialPageRoute(
              builder: (context) => TRATimeTablesState(
                TrainNo: trainNo,
                TrainType: trainType,
              ),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        if (recommended)
                          Row(
                            children: [
                              Chip(
                                label: Text('推薦'),
                                padding: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Text(
                             timeStart,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_right),
                            Text(
                             timeDes,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "約 ${toMinutes(timeDes) - toMinutes(timeStart)} 分鐘",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          missed ? "已過站" : "準點",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: missed
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          trainType,
                          style: TextStyle(
                            color: trainType.contains("區間")
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          trainNo,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "$price\$",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
