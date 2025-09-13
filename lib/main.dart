import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/route.dart';
import 'package:tra/services/PreferenceService.dart';

import 'package:tra/views/HomePage/home_page.dart';

// 2. Make main async to await SharedPreferences
Future<void> main() async {
  // Required before runApp if you are doing async work in main
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService().init();

  final bool useMaterialYou = PreferenceService().instance.getBool('enableMaterialYou') ?? true;
  String? localeString = PreferenceService().instance.getString("locale");
  Locale? locale;
  if (localeString != null) {
    locale =  Locale.fromSubtags(
        languageCode: localeString

    );
  }
  runApp(MainApp(useMaterialYou: useMaterialYou,locale: locale));
}


class MainApp extends StatelessWidget {
  final bool useMaterialYou;
  final Locale? locale;
  const MainApp({super.key, required this.useMaterialYou,this.locale});

  @override
  Widget build(BuildContext context) {

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme = ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 37, 111, 160),
          brightness: Brightness.light,
        );
        ColorScheme darkColorScheme = ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 37, 111, 160),
          brightness: Brightness.dark,
        );

        if (useMaterialYou && lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic;
          darkColorScheme = darkDynamic;
        }

        return MaterialApp.router(
          title: 'FossTRA',
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          supportedLocales: [
            const Locale('en'),
             Locale.fromSubtags(languageCode: 'zh'),
          ],
          locale: locale,
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          routerConfig: AppRouter().router,
        );
      },
    );
  }
}