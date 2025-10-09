import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tra/views/HomePage/home_page.dart';
import 'package:tra/views/Settings/debug/debug.dart';
import 'package:tra/views/Settings/layout.dart';
import 'package:tra/views/Settings/locale/page.dart';
import 'package:tra/views/Settings/settings.dart';
import 'package:tra/views/TRA_Timetables///tra_timetables.dart';
import 'package:tra/views/TRA_SearchPage/tra_searchpage.dart';

class AppRouter {
  // GoRouter configuration
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(
        path: "/TRA/train/:id",
        builder: (context, state) => TRATimetables(trainTypeID: state.pathParameters['id']),
      ),
      GoRoute(
        path: "/TRA/search",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final start = extra?["start"] as dynamic;
          final destination = extra?["destination"] as dynamic;
          final date = extra?["date"] as DateTime?;
          final time = extra?["time"] as TimeOfDay?;
          return TRASearchPage(startStation: start, desStation: destination, dateTime: date, timeOfDay: time);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsLayout(title: "settings", child: SettingsIndex()),
        routes: [
          GoRoute(
            path: 'locale',
            builder: (context, state) => SettingsLayout(title: "langauges", child: SettingsLocalePage()),
          ),
          GoRoute(
            path: 'debug',
            builder: (context, state) => SettingsLayout(title: "Debug", child: SettingsDebugPage()),
          ),
        ],
      ),
    ],
  );
}
