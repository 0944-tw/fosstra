import 'package:flutter/material.dart';
import 'package:modern_dialog/modern_dialog.dart';
import 'package:tra/LocationSelect.dart';
import 'package:tra/Settings.dart';
import 'package:tra/TRA_SearchPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: use_super_parameters
  dynamic stationStart;
  dynamic stationDes;

  DateTime? selectedDate;
  TimeOfDay? selectedTimeOfDay;

  String? stationStartName;
  String? stationDesName;

  int currentPageIndex = 0;

  Future<void> _selectCity(String type) async {
    dynamic result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LocationSelectPage(title: type == "start" ? "出發點" : "目的地"),
      ),
    );

    if (result != null) {
      setState(() {
        if (type == "start") {
          stationStart = result;
          stationStartName = result["StationName"]["Zh_tw"];
        } else {
          stationDes = result;
          stationDesName = result["StationName"]["Zh_tw"];
        }
      });
    }
  }

  Future<void> _Search() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => TRASearchPage(
          startStation: stationStart,
          desStation: stationDes,
          DateTime: selectedDate ?? DateTime.now(), // "yy
          TimeOfDay: selectedTimeOfDay ?? TimeOfDay.now(), // yy-MM-dd" format
        ),
      ),
    );
  }

  Widget _buildLocationTile(
    BuildContext context,
    BorderRadius radius,
    String text,
    String text2,
    IconData icondata,
    Function OnClick,
  ) {
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white10
          : Color.fromARGB(5, 0, 0, 0),
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,

        onTap: () {
          OnClick();
        },
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 12),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Icon(icondata, color: Theme.of(context).iconTheme.color),
          ),
          title: Text(text),
          subtitle: Text(text2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
         selectedIndex: currentPageIndex,
        
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: '首頁',
          ),
          NavigationDestination(
            icon:  Icon(Icons.history),
            label: '紀錄',
          ),
          NavigationDestination(
            icon:  Icon(Icons.favorite),
            label: '收藏',
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'btrTRA 設定',
                  onPressed: () async {
                    await Navigator.push<String>(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "btrTRA",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "BrianThePro TRA",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontSize: 10.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(3),
                child: Material(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: ListTile(
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Icon(
                        Icons.error,
                        color: Theme.of(context).colorScheme.errorContainer,
                      ),
                    ),
                    title: Text(
                      "天然災變",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.labelLarge?.color,
                      ),
                    ),
                    subtitle: Text("初音未來！！！！"),
                  ),
                ),
              ),
              SizedBox(height: 3),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    _buildLocationTile(
                      context,
                      BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      "出發",
                      stationStartName ?? "尚未設定",
                      Icons.flight_takeoff,
                      () {
                        _selectCity("start");
                      },
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.surface,
                      height: 3,
                    ),
                    _buildLocationTile(
                      context,
                      BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      "抵達",
                      stationDesName ?? "尚未設定",
                      Icons.flight_land,
                      () {
                        _selectCity("des");
                      },
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(right: 1),
                            child: _buildLocationTile(
                              context,
                              BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              "日期",
                              '${selectedDate?.toString().split(' ')[0] ?? DateTime.now().toString().split(' ')[0]}',
                              Icons.calendar_today,
                              () async {
                                DateTime? dt = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    Duration(days: 30),
                                  ),
                                  initialDate: DateTime.now(),
                                );
                                if (dt != null) {
                                  selectedDate = dt;
                                }

                                setState(() {
                                  selectedDate = selectedDate;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: EdgeInsetsGeometry.only(left: 1),
                            child: _buildLocationTile(
                              context,
                              BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              "時間",
                              '${selectedTimeOfDay?.hour ?? TimeOfDay.now().hour}:${selectedTimeOfDay?.minute ?? TimeOfDay.now().minute}',
                              Icons.timer,
                              () async {
                                TimeOfDay? td = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (td != null) {
                                  selectedTimeOfDay = td;
                                }
                                setState(() {
                                  selectedTimeOfDay = selectedTimeOfDay;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),

              FilledButton(
                onPressed: () {
                  if (stationDes == null || stationStart == null) {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('到底在？'),
                          content: SingleChildScrollView(
                            child: ListBody(children: <Widget>[Text("不是哥們？")]),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('關閉'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  _Search();
                },
                child: Text("搜尋"),
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    _buildLocationTile(
                      context,
                      BorderRadius.all(Radius.circular(12)),
                      "自強查詢/訂票",
                      "不穩定！好欸！",
                      Icons.train,
                      () {
                        _selectCity("start");
                      },
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
