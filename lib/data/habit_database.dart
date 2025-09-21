import 'package:auxo/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// reference our box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {

  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // create initial default data
  void createDefaultData() {
    todaysHabitList =[
      ["Run", false],
      ["Read", false],
      ["Code", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load data if already exists
  void loadData() {
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    } else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  // update database
  void updateDatabase() {
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
    calculatePercentage();
    loadHeatMap();
  } 

  void calculatePercentage() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) { 
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty 
      ? '0.0' 
      : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i <= daysInBetween; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i))
      );

      double strengthAsDouble = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? '0.0'
      );

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month; 
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsDouble).toInt()
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }

  // streaks calculation
  int calculateCurrentStreak() {
    int streak = 0;
    DateTime today = DateTime.now();

    while (true) {
      String yyyymmdd = convertDateTimeToString(today);
      String? percent = _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd");

      if (percent != null && double.parse(percent) > 0) {
        streak++;
        today = today.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}
