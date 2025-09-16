import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_dialog/modern_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/views/HomePage/home_page_viewmodel.dart';
import 'package:tra/views/LocationSelect/location_select.dart';
import 'package:tra/views/Settings/settings.dart';
import 'package:tra/views/TRA_SearchPage/tra_searchpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: use_super_parameters

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ViewModelBuilder<HomePageViewModel>.reactive(
      viewModelBuilder: () => HomePageViewModel(),
      builder: (context, model, child) => Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,

          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: const Icon(Icons.home_rounded),
              icon: const Icon(Icons.home_rounded),
              label: localizations.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history),
              label: localizations.history,
              enabled: false,
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: localizations.favorite,
              enabled: false,
            ),
          ],
        ),
        body: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,

          appBar: AppBar(
            title: const Text("fosstra"),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                tooltip: 'btrTRA 設定',
                onPressed: () async {
                  await context.push("/settings");
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 3),
                Material(
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                LocationTile(
                                  name: localizations.startStation,
                                  description:
                                      model.stationStartName ??
                                      localizations.empty,
                                  icon: Icons.flight_takeoff_rounded,
                                  onClick: () {
                                    model.selectCity(context, "start");
                                  },
                                ),
                                SizedBox(height: 3),
                                LocationTile(
                                  name: localizations.destinationStation,
                                  description:
                                      model.stationDestinationName ??
                                      localizations.empty,
                                  icon: Icons.flight_land_rounded,
                                  onClick: () {
                                    model.selectCity(context, "des");
                                  },
                                ),
                              ],
                            ),
                            Positioned(
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(4),
                                child: Material(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1114),
                                  ),
                                  child: InkWell(
                                    onTap: () => model.Swap(),

                                    borderRadius: BorderRadius.all(
                                      Radius.circular(114514),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsGeometry.all(8),
                                      child: Icon(Icons.swap_vert_rounded),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(right: 1),
                              child: LocationTile(
                                radius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                name: localizations.date,
                                description:
                                    '${model.selectedDate?.toString().split(' ')[0] ?? DateTime.now().toString().split(' ')[0]}',
                                icon: Icons.calendar_today,
                                onClick: () => model.updateDateTime(context),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(left: 1),
                              child: LocationTile(
                                radius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                name: localizations.time,
                                description:
                                    '${model.selectedTimeOfDay?.hour ?? TimeOfDay.now().hour}:${model.selectedTimeOfDay?.minute ?? TimeOfDay.now().minute}',
                                icon: Icons.timer,
                                onClick: () => model.updateTimeOfDay(context),
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
                    if (model.stationDestination == null ||
                        model.stationStart == null) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              localizations.stationNotSelectedAlertTitle,
                            ),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                    localizations
                                        .stationNotSelectedAlertDescription,
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(localizations.close),
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

                    model.Search(context);
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(localizations.search),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    children: [
                      LocationTile(
                        radius: BorderRadius.all(Radius.circular(16)),
                        name: localizations.expressTrainTicketOrderTitle,
                        description: "Coming Soon™️ ️",
                        icon: Icons.train,
                        disabled: true,
                      ),
                    ],
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

/*
  Widget _buildLocationTile(
    BuildContext context,
    BorderRadius radius,
    String text,
    String text2,
    IconData icondata,
    Function OnClick,
  ) {

  }


 */
class LocationTile extends StatelessWidget {
  final BorderRadius? radius;
  final String name;
  final String description;
  final IconData icon;
  final Function? onClick;
  final bool? disabled;

  const LocationTile({
    super.key,
    this.radius,
    required this.name,
    required this.description,
    required this.icon,
    this.onClick,
    this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: disabled == true ? 0.5 : 1,
      child: Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white10
            : Color.fromARGB(5, 0, 0, 0),

        borderRadius: radius,
        child: InkWell(
          borderRadius: radius ?? null,


          child: ListTile(
            onTap: onClick != null ? () => onClick!() : null,
            contentPadding: EdgeInsets.only(left: 12),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Icon(this.icon, color: Theme.of(context).iconTheme.color),
            ),
            title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(description),
          ),
        ),
      ),
    );
  }
}
