import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  final Box _box;

  ThemeNotifier(this._box)
      : super(_box.get('isDarkMode', defaultValue: false)
            ? ThemeMode.dark
            : ThemeMode.light);

  void toggleTheme() {
    final isDark = value == ThemeMode.dark;
    value = isDark ? ThemeMode.light : ThemeMode.dark;
    _box.put('isDarkMode', value == ThemeMode.dark);
  }
}
