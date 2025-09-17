
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/views/TRA_Timetables//tra_timetables_viewmodel.dart';

int toMinutes(String time) {
  final parts = time.split(':');
  final hours = int.parse(parts[0]);
  // Pad minutes with leading zero if necessary
  final minutesStr = parts[1].padLeft(2, '0');
  final minutes = int.parse(minutesStr);
  return hours * 60 + minutes;
}

class DailyTrainScheduleTRA extends StatelessWidget {
  final Map<int, GlobalKey> _itemKeys = {};
  final dynamic trainTypeID;

  DailyTrainScheduleTRA({super.key, required this.trainTypeID});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ViewModelBuilder<DailyTrainScheduleTRA_ViewModel>.reactive(
      viewModelBuilder: () => DailyTrainScheduleTRA_ViewModel(),
      onViewModelReady: (vm) => vm.fetchTimetables(int.parse(trainTypeID)),
      builder: (context, vm, child) {
        final locale = vm.getLanguageCode(Localizations.localeOf(context));

        return vm.isBusy
            ? Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                body: const Center(child: CircularProgressIndicator()),
              )
            : Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                body: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                          titlePadding: EdgeInsets.only(
                            bottom: 8.0,
                            left: 16.0,
                            right: 16.0,
                          ), // Example
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '$trainTypeID ${vm.trainInfo?["TrainTypeName"]?[locale] ?? ""}',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.color,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                localizations.routeDescription(
                                  vm.trainInfo?["StartingStationName"]?[locale] ??
                                      "",
                                  vm.trainInfo?["EndingStationName"]?[locale] ??
                                      "",
                                ),
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.color,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: SingleChildScrollView(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      children: vm.stopTimes.asMap().entries.map((entry) {
                        var info = entry.value;
                        return Card(
                          elevation: 0,
                          color: Theme.of(context).colorScheme.surface,
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(15),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      Text(
                                        info["StationName"][locale],
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        info["ArrivalTime"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      Icon(Icons.arrow_right),
                                      Text(
                                        info["DepartureTime"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
