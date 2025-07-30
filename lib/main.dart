import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:tra/HomePage.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // Define your fallback color schemes
        ColorScheme lightColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.deepPurple, // Your default primary color
          brightness: Brightness.light,
        );
        ColorScheme darkColorScheme = ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        );

        // If dynamic colors are available, use them
        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic;
          darkColorScheme = darkDynamic;
        }

        return MaterialApp(
          title: 'OpenTRA',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true, // Crucial for Material You
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system, // Respects system light/dark mode
          home: HomePage(),
        );
      },
    );
  }
}
