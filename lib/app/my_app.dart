import 'package:flutter/material.dart';
import 'package:flutter_assiment/providers/color_notifier_provider.dart';
import 'package:flutter_assiment/providers/theme_notifier_provider.dart';
import 'package:flutter_assiment/screens/detail_screen.dart';
import 'package:flutter_assiment/screens/main_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<Color> colorList = [
  Colors.yellow,
  Colors.lime,
  Colors.green,
  Colors.orange,
  Colors.deepOrange,
  Colors.pinkAccent,
  Colors.pink,
  Colors.red,
  Colors.deepPurple,
  Colors.cyanAccent,
  Colors.cyan,
  Colors.lightBlue,
  Colors.blue,
  Colors.indigo,
  Colors.grey,
];


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(themeNotifierProvider);
    final index = ref.watch(colorNotifierProvider);
    final seedColor = colorList[index];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
      ),
      // home: const MainScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(builder: (context) => MainScreen());
          case "/detail":
            return MaterialPageRoute(
              builder: (context) => DetailScreen(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => Text("No Screen Found!!"),
            );
        }
      },
    );
  }
}
