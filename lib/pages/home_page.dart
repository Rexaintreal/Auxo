import 'package:auxo/data/habit_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:auxo/components/habit_tile.dart';
import 'package:auxo/components/monthly_summary.dart';
import 'package:auxo/components/my_alert_box.dart';
import 'package:auxo/components/my_fab.dart';
import '../main.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");
  final _newHabitNameController = TextEditingController();
  double getTodayProgress() {
    if (db.todaysHabitList.isEmpty) return 0.0;
    int completed = db.todaysHabitList.where((h) => h[1] == true).length;
    return completed / db.todaysHabitList.length;
  }

  @override
  void initState() {
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }
    db.updateDatabase();
    super.initState();
  }

  
  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  // create a new habit


  void createNewHabit() {
    // show alert dialog for user to enter the new habit details
    showDialog(context: context, builder: (context){
      return MyAlertBox(
        controller: _newHabitNameController,
        hintText: 'Enter Habit Name!',
        onSave: saveNewHabit,
        onCancel: cancelDialogBox,
      );
    });
  }

  // save new habit
void saveNewHabit() {
  String newHabit = _newHabitNameController.text.trim(); 

  if (newHabit.isNotEmpty) {
    // add new habit to today's habit list
    setState(() {
      db.todaysHabitList.add([newHabit, false]);
    });
    db.updateDatabase();
  }

  // clear textfield
  _newHabitNameController.clear();

  // pop dialog box
  Navigator.of(context).pop();
}

  // cancel new habit

  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();
    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(context: context, builder: (context) {
      return MyAlertBox(
        controller: _newHabitNameController, 
        hintText: db.todaysHabitList[index][0],
        onCancel: cancelDialogBox, 
        onSave: () => saveExistingHabit(index),
        );
      }
    );
  }


  // save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    db.updateDatabase();
    _newHabitNameController.clear();
    Navigator.pop(context);
  }

  // delete habit
  void deleteHabit(int index){
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT: Streak icon + number with padding
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: getTodayProgress()),
                          duration: const Duration(milliseconds: 800), // smooth animation
                          builder: (context, value, child) {
                            return CircularProgressIndicator(
                              value: value,
                              strokeWidth: 2.5,
                              color: Colors.green,
                              // ignore: deprecated_member_use
                              backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            );
                          },
                        ),
                      ),
                      Icon(
                        Icons.bolt,
                        size: 24,
                        color: db.calculateCurrentStreak() > 0
                            ? Colors.orange
                            // ignore: deprecated_member_use
                            : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    " ${db.calculateCurrentStreak()}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // CENTER: App name
            Text(
              "Auxo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 1.2,
              ),
            ),

            // RIGHT: Theme toggle with padding
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: IconButton(
                  key: ValueKey<bool>(themeNotifier.value == ThemeMode.dark),
                  icon: Icon(
                    themeNotifier.value == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    themeNotifier.toggleTheme();
                  },
                ),
              ),
            ),

          ],
        ),
      ),



      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.get("START_DATE"),
          ),

          // Check if there are habits
          db.todaysHabitList.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 50,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No habits yet!\nTap + to start your streak",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: db.todaysHabitList.length,
                  itemBuilder: (context, index) {
                    return HabitTile(
                      habitName: db.todaysHabitList[index][0],
                      habitCompleted: db.todaysHabitList[index][1],
                      onChanged: (value) => checkBoxTapped(value, index),
                      settingsTapped: (context) => openHabitSettings(index),
                      deleteTapped: (context) => deleteHabit(index),
                    );
                  },
                ),
        ],
      ),

    );
  }
}