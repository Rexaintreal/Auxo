import 'package:flutter/material.dart';
import 'package:auxo/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auxo/data/theme_provider.dart';

late ThemeNotifier themeNotifier;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox("Habit_Database");
  final themeBox = await Hive.openBox("Theme_Box");

  themeNotifier = ThemeNotifier(themeBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color githubGreen = Color.fromARGB(255, 0, 200, 0);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final ThemeData lightTheme = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: githubGreen,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        );

        final ThemeData darkTheme = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: githubGreen,
            brightness: Brightness.dark,
          ),
        );

        return AnimatedTheme(
          data: mode == ThemeMode.dark ? darkTheme : lightTheme,
          duration: const Duration(milliseconds: 500), // smooth transition
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: mode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const HomePage(),
          ),
        );
      },
    );
  }
}