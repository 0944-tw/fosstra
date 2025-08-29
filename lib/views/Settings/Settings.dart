import 'package:flutter/material.dart';
import 'package:modern_dialog/modern_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:tra/views/LocationSelect.dart';
import 'package:tra/views/Settings/Settings_ViewModel.dart';
import 'package:tra/views/TRA_SearchPage/TRA_SearchPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ignore: use_super_parameters

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(

        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 250.0,
                floating: false,
                pinned: true,
                actions: <Widget>[],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "設定",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            padding: EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  child: ListTile(
                    title: Text('Material You'),
                    subtitle: Text("使用系統配色"),
                    trailing: Switch(
                      // This bool value toggles the switch.
                      value: model.enableMaterialYou,
                      onChanged: (bool value) async {
                        model.setEnableMaterialYou(!model.enableMaterialYou);
                      },
                    ),
                  ),
                ),

                Material(
                  child: ListTile(
                    title: Text('自訂API Key'),
                    subtitle: Text("你可以更改成你的TDX API密鑰"),
                  ),
                ),
                Material(
                  child: ListTile(
                    title: Text('自訂API節點'),
                    subtitle: Text("點擊此連結來使用你自己的btrAPI節點"),
                  ),
                ),
                Material(
                  child: ListTile(
                    title: Text('除錯模式'),
                    subtitle: Text("你可以打開。"),
                    trailing: Switch(
                      // This bool value toggles the switch.
                      value: model.debugMode,
                      onChanged: (bool value) async {
                       model.setDebugMode(!model.debugMode);
                      },
                    ),
                  ),
                ),
                Material(
                  child: ListTile(
                    title: Text('使用測試數據'),
                    subtitle: Text("開啟了此選項將會使用測試數據而不是向TDX請求的數據"),
                    trailing: Switch(
                      // This bool value toggles the switch.
                      value: model.useTestData,
                      onChanged: (bool value) async {
                        model.setUseTestData(!model.useTestData);
                      },
                    ),
                  ),
                ),
                Material(
                  child: ListTile(
                    title: Text('版本'),
                    subtitle: Text("v0.0.1-114514"),
                  ),
                ),
                Material(
                  child: ListTile(
                    title: Text('贊助'),
                    leading: Icon(Icons.favorite),
                    iconColor: Colors.pink,
                    subtitle: Text("這個專案每個月會吃掉200也就是6.5道maimai"),
                  ),
                ),
                SizedBox(height: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
