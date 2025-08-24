import 'package:flutter/material.dart';
import 'package:modern_dialog/modern_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tra/LocationSelect.dart';
import 'package:tra/TRA_SearchPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ignore: use_super_parameters
  SharedPreferences? preferences;
  bool useTestData = false;
  bool enableMaterialYou = true;
  Future<void> GetSharedPerfs() async {
    SharedPreferences.setMockInitialValues({});
      SharedPreferences perf = await SharedPreferences.getInstance();
         preferences = perf;
         useTestData = perf.getBool("useTestData") ?? false;
        enableMaterialYou = perf.getBool("enableMaterialYou") ?? true;
  }

  @override
  void initState() {
    super.initState();
    GetSharedPerfs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    value: enableMaterialYou,
                    onChanged: (bool value) async {
                         await preferences?.setBool("enableMaterialYou",value);

                       setState(() {
                       enableMaterialYou = value;
                      });
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
                  title: Text('使用測試數據'),
                  subtitle: Text("開啟了此選項將會使用測試數據而不是向TDX請求的數據"),
                  trailing: Switch(
                    // This bool value toggles the switch.
                    value: useTestData,
                    onChanged: (bool value) async {
                         await preferences?.setBool("useTestData",value);

                       setState(() {
                       useTestData = value;
                      });
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
              SizedBox(height: 3),
            ],
          ),
        ),
      ),
    );
  }
}
