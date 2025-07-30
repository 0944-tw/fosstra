import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tra/Dialog/UnexpectedError.dart';

class LocationSelectPage extends StatefulWidget {
  final String title;

  const LocationSelectPage({Key? key, required this.title}) : super(key: key);

  @override
  State<LocationSelectPage> createState() => _LocationSelectPageState();
}

class _LocationSelectPageState extends State<LocationSelectPage> {
  Map<String, List> stations = {};
  List<MapEntry<String, dynamic>> stationsList = [];
  List<dynamic> selected = [];
  @override
  void initState() {
    super.initState();
    try {
       fetchFormattedStations();
    } catch (err) {
      showDialog(
        context: context,
        builder: (context) => UnexpectedErrorDialog(Error: err.toString()),
      );
    }
  }

  Future<void> fetchFormattedStations() async {
    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/0944-tw/TRA_Testing/refs/heads/main/TRA_Stations.json',
      ),
      headers: {
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      for (var item in data) {
        var city = item["LocationCity"];
        if (!stations.containsKey(city)) {
          stations[city] = [];
        }
        stations[city]!.add(item);
      }
      setState(() {
        stations = stations;
        stationsList = stations.entries.toList();
      });
    } else {
      final content = response.body;
      showDialog(
        context: context,
        builder: (context) => UnexpectedErrorDialog(Error: content.toString()),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("選擇")),
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: stationsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(stationsList[index].key),
                    onTap: () {
                      setState(() {
                        selected = stationsList[index].value;
                      });
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: selected.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selected[index]["StationName"]["Zh_tw"]),
                    onTap: () {
                      Navigator.pop(context, selected[index]); // Send city back
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
