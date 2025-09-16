import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tra/l10n/app_localizations.dart';
import 'package:tra/route.dart';
import 'package:tra/services/LocaleProvider.dart';
import 'package:tra/services/PreferenceService.dart';
import 'package:provider/provider.dart';
import 'package:tra/views/HomePage/home_page.dart';

// 2. Make main async to await SharedPreferences
Future<void> main() async {
  // Required before runApp if you are doing async work in main
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceService().init();

  final bool useMaterialYou =
      PreferenceService().instance.getBool('enableMaterialYou') ?? true;
  String? localeString = PreferenceService().instance.getString("locale");
  Locale? locale;
  if (localeString != null) {
    locale = Locale.fromSubtags(languageCode: localeString);
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(locale),
      child: MainApp(useMaterialYou: useMaterialYou),
    ),
  );
}

class MainApp extends StatelessWidget {
  final bool useMaterialYou;
  final Locale? locale;

  const MainApp({super.key, required this.useMaterialYou, this.locale});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final localeProvider = context.watch<LocaleProvider>();
        ColorScheme lightColorScheme = ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 37, 111, 160),
          brightness: Brightness.light,
        );
        ColorScheme darkColorScheme = ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 37, 111, 160),
          brightness: Brightness.dark,
        );

        if (useMaterialYou && lightDynamic != null && darkDynamic != null) {
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: lightDynamic.primary,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: lightDynamic.primary,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp.router(
          title: 'FossTRA',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeProvider.locale,
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
            // fontFamily: "Noto Sans TC",
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
            //
          ),
          themeMode: ThemeMode.system,
          routerConfig: AppRouter().router,
        );
      },
    );
  }
}
