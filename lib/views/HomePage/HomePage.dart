import 'package:flutter/material.dart';
import 'package:modern_dialog/modern_dialog.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/views/HomePage/HomePage_ViewModel.dart';
import 'package:tra/views/LocationSelect.dart';
import 'package:tra/views/Settings/Settings.dart';
import 'package:tra/views/TRA_SearchPage/TRA_SearchPage.dart';
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
   return ViewModelBuilder<HomePageViewModel>.reactive(
      viewModelBuilder:() => HomePageViewModel() ,
      builder: (context, model, child) => Scaffold(
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
            NavigationDestination(icon: Icon(Icons.history), label: '紀錄',enabled: false ),
            NavigationDestination(icon: Icon(Icons.favorite), label: '收藏', enabled: false,),
          ],
        ),
        body: Scaffold(
          appBar: AppBar(
            title: const Text("fosstra"),
            centerTitle: true,
            actions: [
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
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 120),
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
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LocationTile(
                                radius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                name: "出發",
                                description: model.stationStartName ?? "尚未設定",
                                icon: Icons.flight_takeoff,
                                onClick: () {
                                  model.selectCity(context,"start");
                                },
                              ),
                              SizedBox(height: 3),
                              LocationTile(
                                radius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                name: "抵達",
                                description: model.stationDestinationName ?? "尚未設定",
                                icon: Icons.flight_land,
                                onClick: () {
                                  model.selectCity(context,"des");
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
                                    child: Icon(Icons.swap_vert),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                name: "日期",
                                description:
                                    '${model.selectedDate?.toString().split(' ')[0] ?? DateTime.now().toString().split(' ')[0]}',
                                icon: Icons.calendar_today,
                                onClick: () => model.updateDateTime(context)
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
                                name: "時間",
                                description:
                                    '${model.selectedTimeOfDay?.hour ?? TimeOfDay.now().hour}:${model.selectedTimeOfDay?.minute ?? TimeOfDay.now().minute}',
                                icon: Icons.timer,
                                onClick: () => model.updateTimeOfDay(context)
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
                    if (model.stationDestination == null || model.stationStart == null) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('到底在？'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[Text("不是哥們？")],
                              ),
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

                    model.Search(context);
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
                      LocationTile(
                        radius: BorderRadius.all(Radius.circular(12)),
                        name: "自強查詢/訂票",
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
  final BorderRadius radius;
  final String name;
  final String description;
  final IconData icon;
  final Function? onClick;
  final bool? disabled;

  const LocationTile({
    super.key,
    required this.radius,
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
          borderRadius: radius,

          onTap: onClick != null ? () => onClick!() : null,

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
              child: Icon(this.icon, color: Theme.of(context).iconTheme.color),
            ),
            title: Text(name),
            subtitle: Text(description),
          ),
        ),
      ),
    );
  }
}
