import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:nia/models/app_settings.dart';
import 'package:nia/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*

  S E T U P 

  */

  //INITIALIZE - DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
  }

  //save first date of app startup  - for heatmap
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //get first date of app startup - for heatmap
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*
  
  C R U D X O P E R A T I O N S

  */

  //list of habits
  final List<Habit> currentHabits = [];

  //CREATE - add a new habit
  Future<void> addHabit(String habitName) async {
    //create new habit
    final newHabit = Habit()..name = habitName;

    //save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));
  }

  //READ - read saved habit from database
  Future<void> readHabits() async {
    //fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    //update UI
    notifyListeners();
  }

  //UPDATE - check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find the specific habit
    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completeDays.contains(DateTime.now())) {
          //today
          final today = DateTime.now();

          //add the current date if it's not already in the list
          habit.completeDays.add(DateTime(
            today.year,
            today.month,
            today.day,
          ));
        }
        //if habit is NOT completted -> remove the current date from the list
        else {
          //remove the current date if the habit is marked as not compelete
          habit.completeDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        //save the updated habits back to the db
        await isar.habits.put(habit);
      });
    }
    //re-read from db
    readHabits();
  }

  //UPDATE - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    //find the specific habit
    final habit = await isar.habits.get(id);

    //update habit name
    if (habit != null) {
      //update name
      await isar.writeTxn(() async {
        habit.name = newName;
        //save updated habit back to db
        await isar.habits.put(habit);
      });
    }
    //reread from db
    readHabits();
  }

  //DELETE - delete habit
  Future<void> deleteHabit(int id) async {
    //perfom the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    //reread
    readHabits();
  }
}
