import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tra/Dialog/UnexpectedError.dart';

class TRATimeTablesState extends StatefulWidget {
  final dynamic TrainNo;
  final dynamic TrainType;

  const TRATimeTablesState({
    Key? key,
    required this.TrainNo,
    required this.TrainType,
  }) : super(key: key);
  @override
  State<TRATimeTablesState> createState() => _TRATimeTablesState();
}

int toMinutes(String time) {
  final parts = time.split(':');
  final hours = int.parse(parts[0]);
  // Pad minutes with leading zero if necessary
  final minutesStr = parts[1].padLeft(2, '0');
  final minutes = int.parse(minutesStr);
  return hours * 60 + minutes;
}

class _TRATimeTablesState extends State<TRATimeTablesState> {
  final Map<int, GlobalKey> _itemKeys = {};

  int ClosestIndex = 0;
  final GlobalKey _scrollViewKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.TrainNo} ${widget.TrainType}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
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
                Card(
                  elevation: 0,

                  child: Padding(
                    padding: EdgeInsetsGeometry.all(15),
                    child: Row(
                      children: [
                        Expanded(flex: 5, child: Row(children: [Text("基隆",style: TextStyle(fontSize: 18),)])),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("11:00",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              Icon(Icons.arrow_right),
                              Text("11:05",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                       Card(
                  elevation: 0,

                  child: Padding(
                    padding: EdgeInsetsGeometry.all(15),
                    child: Row(
                      children: [
                        Expanded(flex: 5, child: Row(children: [Text("基隆",style: TextStyle(fontSize: 18),)])),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("11:00",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              Icon(Icons.arrow_right),
                              Text("11:05",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                       Card(
                  elevation: 0,

                  child: Padding(
                    padding: EdgeInsetsGeometry.all(15),
                    child: Row(
                      children: [
                        Expanded(flex: 5, child: Row(children: [Text("基隆",style: TextStyle(fontSize: 18),)])),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("11:00",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              Icon(Icons.arrow_right),
                              Text("11:05",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              : Color.fromARGB(0, 0, 0, 0), // or Colors.grey
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),

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
                          color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
