import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/views/TRA_Timetables//tra_timetables.dart';
import 'package:tra/views/TRA_SearchPage/tra_searchpage_viewmodel.dart';

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
    required this.timeOfDay,
  });

  List<dynamic> trainTimeTables = [];
  final Map<int, GlobalKey> _itemKeys = {};

  int closetIndex = 0;
  final GlobalKey _scrollViewKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  String currentTime = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";

  String trainTypeName(BuildContext context, int code) {
    final l10n = AppLocalizations.of(context)!;
    switch (code) {
      case 1:
        return l10n.tarokoExpress;
      case 2:
        return l10n.puyumaExpress;
      case 3:
        return l10n.tzeChiang;
      case 4:
        return l10n.chuKuangExpress;
      case 5:
        return l10n.fuHsing;
      case 6:
        return l10n.localTrain;
      case 7:
        return l10n.ordinaryTrain;
      case 10:
        return l10n.localTrainFast;
      case 11:
        return l10n.tzeChiangEMU3000;
      default:
        return code.toString(); // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ViewModelBuilder<TRASearchPageViewModel>.reactive(
      viewModelBuilder: () => TRASearchPageViewModel(),
      onViewModelReady: (vm) => vm.fetchTrain(
        context,
        startStation["StationID"],
        desStation["StationID"],
        dateTime.toString().split(' ')[0],
      ),
      builder: (context, vm, child) {
        final locale = vm.getLanguageCode(Localizations.localeOf(context));

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 200.0,
                      floating: false,
                      pinned: true,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainer,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 8.0,
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              localizations.routeDescription(
                                startStation["StationName"][locale],
                                desStation["StationName"][locale],
                              ),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.color,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              vm.isBusy
                                  ? localizations.loading
                                  : localizations.searchResultsFound(
                                      vm.trainTimeTables.length,
                                    ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.displayMedium?.color,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                },
            body: vm.isBusy
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    controller: vm.scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Material(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: vm.trainTimeTables.asMap().entries.map((
                          entry,
                        ) {
                          int index = entry.key;
                          var train = entry.value;

                          int Direction = train["TrainInfo"]['Direction'];
                          int TrainType = int.parse(
                            train["TrainInfo"]["TrainTypeCode"],
                          );
                          bool missed =
                              vm.toMinutes(
                                    train['StopTimes'][0]['DepartureTime'],
                                  ) -
                                  vm.toMinutes(vm.currentTime) <
                              0;

                          return Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                key: vm.itemKeys[index],
                                child: TrainStatusCard(
                                  recommended: index == vm.closetIndex,
                                  timeDes:
                                      train['StopTimes'][1]["DepartureTime"],
                                  timeStart:
                                      train['StopTimes'][0]['DepartureTime'],
                                  price: vm
                                      .pricesByDirection[Direction]![TrainType]
                                      .toString(),
                                  trainNo: train["TrainInfo"]["TrainNo"],
                                  trainType: trainTypeName(
                                    context,
                                    int.parse(
                                      train["TrainInfo"]["TrainTypeCode"],
                                    ),
                                  ),
                                  missed: missed,
                                ),
                              ),
                              SizedBox(height: 3),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
          ),
        );
      },
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

  const TrainStatusCard({
    super.key,
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
    final localizations = AppLocalizations.of(context)!;

    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: recommended ? Theme.of(context).colorScheme.primary : Colors.transparent,
          width: 2.0,
        ),
      ),
      borderRadius: BorderRadius.circular(4),
      splashColor: Theme.of(context).colorScheme.surfaceContainer,
      onTap: () async {
        context.push("/TRA/train/$trainNo");
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
                            localizations.durationMinutes(
                              toMinutes(timeDes) - toMinutes(timeStart),
                            ),
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
                        missed ? localizations.passed : localizations.onTime,
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
    );
  }
}
