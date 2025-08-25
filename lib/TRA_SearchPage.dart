import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tra/Dialog/UnexpectedError.dart';
import 'package:tra/TRA_TrainTimetables.dart';

class TRASearchPage extends StatefulWidget {
  final dynamic startStation;
  final dynamic desStation;
  final dynamic DateTime;
  final dynamic TimeOfDay;

  const TRASearchPage({
    Key? key,
    required this.startStation,
    required this.desStation,
    required this.DateTime,
    required this.TimeOfDay,
  }) : super(key: key);

  @override
  State<TRASearchPage> createState() => _TRASearchPageState();
}

int toMinutes(String time) {
  final parts = time.split(':');
  final hours = int.parse(parts[0]);
  // Pad minutes with leading zero if necessary
  final minutesStr = parts[1].padLeft(2, '0');
  final minutes = int.parse(minutesStr);
  return hours * 60 + minutes;
}

class _TRASearchPageState extends State<TRASearchPage> {
  List<dynamic> TrainTimeTables = [];
  final Map<int, GlobalKey> _itemKeys = {};

  int ClosestIndex = 0;
  final GlobalKey _scrollViewKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  String CurrentTime = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";

  Future<void> fetchTrain(startID, endID, dateString) async {
    print(startID);
    print(endID);
    print(dateString);
    final response = await http.get(
      Uri.parse(
        //"https://tdx.transportdata.tw/api/basic/v3/Rail/TRA/DailyTrainTimetable/OD/$startID/to/$endID/$dateString?%24top=114514&%24format=JSON",
        // "https://raw.githubusercontent.com/0944-tw/btrTRA_data/refs/heads/main/TestingData/ExampleDailyTimetables.json",
         "http://btr-tra-api.vercel.app/api/v3/Rail/TRA/DailyTrainTimetable/OD/$startID/to/$endID/$dateString"
      ),
      headers: {
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0",
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      TrainTimeTables = data["TrainTimetables"];

      TrainTimeTables.sort((item1, item2) {
        int d1 = toMinutes(item1["StopTimes"][0]["DepartureTime"]);
        int d2 = toMinutes(item2["StopTimes"][0]["DepartureTime"]);
        return d1.compareTo(d2);
      });
      for (int i = 0; i < TrainTimeTables.length; i++) {
        _itemKeys[i] = GlobalKey();
      }
      dynamic closestTrain;
      for (int i = 0; i < TrainTimeTables.length; i++) {
        int trainDepartureMinutes = toMinutes(
          TrainTimeTables[i]["StopTimes"][0]["DepartureTime"],
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
            closestTrain = TrainTimeTables[i];
            ClosestIndex = i;
          }
        } else {
          closestTrain = TrainTimeTables[i];
          ClosestIndex = i;
        }
      }
      if (ClosestIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = _itemKeys[ClosestIndex]?.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: Duration(milliseconds: 650),
              alignment: 0.5,
              curve: Curves.easeOutExpo,
            );
          }
        });
      }
      setState(() {});

      context.loaderOverlay.hide();
    } else {
      final content = response.body;
      showDialog(
        context: context,
        builder: (context) => UnexpectedErrorDialog(Error: content.toString()),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.loaderOverlay.show();
    });

    fetchTrain(
      widget.startStation["StationID"],
      widget.desStation["StationID"],
      widget.DateTime.toString().split(' ')[0],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      "${widget.startStation["StationName"]["Zh_tw"]} 到 ${widget.desStation["StationName"]["Zh_tw"]} ",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "共有 ${TrainTimeTables.length} 個結果",
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
            controller: _scrollController,
            key: _scrollViewKey,
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Column(
              children: [
                // Loop through TrainTimeTables and create a TrainStatusCard for each entry
                ...TrainTimeTables.asMap().entries.map((entry) {
                  int index = entry.key;
                  var train = entry.value;
                  bool missed = false;
                  if ((toMinutes(train['StopTimes'][0]['DepartureTime']) -
                          toMinutes(CurrentTime)) <
                      0) {
                    missed = true;
                  }
                  return Container(
                    key: _itemKeys[index],
                    child: TrainStatusCard(
                      Recommended: index == ClosestIndex,
                      TimeDes: train['StopTimes'][1]["DepartureTime"] ?? '',
                      TimeStart: train['StopTimes'][0]['DepartureTime'] ?? '',
                      Price: train['Price']?.toString() ?? '22',
                      TrainNo: train["TrainInfo"]["TrainNo"],
                      TrainType: train["TrainInfo"]["TrainTypeName"]["Zh_tw"],
                      Missed: missed,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TrainStatusCard extends StatelessWidget {
  final String Price;
  final String TimeStart;
  final String TimeDes;
  final String TrainNo;
  final String TrainType;
  final bool Recommended;
  final bool Missed;

  TrainStatusCard({
    required this.TimeDes,
    required this.TimeStart,
    required this.Price,
    required this.TrainNo,
    required this.TrainType,
    required this.Recommended,
    required this.Missed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Recommended
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
            MaterialPageRoute(builder: (context) => TRATimeTablesState(
              TrainNo: this.TrainNo,
              TrainType: this.TrainType,
            )),
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
                        if (Recommended)
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
                              this.TimeStart,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_right),
                            Text(
                              this.TimeDes,
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
                              "約 ${toMinutes(this.TimeDes) - toMinutes(this.TimeStart)} 分鐘",
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
                          Missed ? "已過站" : "準點",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Missed
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
                          TrainType,
                          style: TextStyle(
                            color: TrainType.contains("區間") ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          TrainNo,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
