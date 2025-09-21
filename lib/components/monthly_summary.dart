import 'package:auxo/datetime/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MonthlySummary extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final String startDate;

  const MonthlySummary({
    super.key,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: HeatMap(
        startDate: createDateTimeObject(startDate),
        endDate: DateTime.now(),
        datasets: datasets,
        colorMode: ColorMode.color,
        // background of empty days
        defaultColor: isDark
            ? Colors.grey[850]   // darker grey for dark mode
            : Colors.grey[300],  // softer grey for light mode
        // text inside each square
        textColor: isDark
            ? Colors.white
            : Colors.grey[900],
        showColorTip: false,
        showText: true,
        size: 30,
        // intensity shades of green that look good in both modes
        colorsets: const {
          1: Color.fromARGB(30, 0, 200, 0),
          2: Color.fromARGB(60, 0, 200, 0),
          3: Color.fromARGB(90, 0, 200, 0),
          4: Color.fromARGB(120, 0, 200, 0),
          5: Color.fromARGB(150, 0, 200, 0),
          6: Color.fromARGB(180, 0, 200, 0),
          7: Color.fromARGB(200, 0, 200, 0),
          8: Color.fromARGB(220, 0, 200, 0),
          9: Color.fromARGB(240, 0, 200, 0),
          10: Color.fromARGB(255, 0, 200, 0),
        },
      ),
    );
  }
}
