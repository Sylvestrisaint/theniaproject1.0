import 'package:flutter/material.dart';
import 'package:nia/components/habit_tile.dart';
import 'package:nia/components/heat_map.dart';
import 'package:nia/components/my_drawer.dart';
import 'package:nia/database/habit_database.dart';
import 'package:nia/models/habit.dart';
import 'package:nia/themes/theme_provider.dart';
import 'package:nia/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    super.initState();
  }

  //text controller
  final TextEditingController textController = TextEditingController();

  //create new habit
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration:
                    const InputDecoration(hintText: "Create a new habit"),
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: () {
                    //get the new habit name
                    String newHabitName = textController.text;

                    //save to db
                    context.read<HabitDatabase>().addHabit(newHabitName);

                    //pop box
                    Navigator.pop(context);

                    //rebuild
                    setState(() {
                      Provider.of<HabitDatabase>(context, listen: false)
                          .readHabits();
                    });

                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Save"),
                ),

                //cancel button
                MaterialButton(
                  onPressed: () {
                    //pop box
                    Navigator.pop(context);

                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  //check habit on and off
  void checkHabitOnOff(bool? value, Habit habit) {
    //update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  //edit habit
  void editHabitBox(Habit habit) {
    //set the controller's text to the habit's current name
    textController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: () {
                    //get the new habit name
                    String newHabitName = textController.text;

                    //save to db
                    context
                        .read<HabitDatabase>()
                        .updateHabitName(habit.id, newHabitName);

                    //pop box
                    Navigator.pop(context);

                    //rebuild
                    setState(() {
                      Provider.of<HabitDatabase>(context, listen: false)
                          .readHabits();
                    });

                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Save"),
                ),

                //cancel button
                MaterialButton(
                  onPressed: () {
                    //pop box
                    Navigator.pop(context);

                    //clear controller
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  //delete habit
  //edit habit
  void deleteHabitBox(Habit habit) {
    //set the controller's text to the habit's current name
    textController.text = habit.name;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Are you sure?",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                //delete button
                MaterialButton(
                  onPressed: () {
                    //save to db
                    context.read<HabitDatabase>().deleteHabit(habit.id);

                    //pop box
                    Navigator.pop(context);

                    //rebuild
                    setState(() {
                      Provider.of<HabitDatabase>(context, listen: false)
                          .readHabits();
                    });
                  },
                  child: const Text("Delete"),
                ),

                //cancel button
                MaterialButton(
                  onPressed: () {
                    //pop box
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //read the updated habit with each build
    Provider.of<HabitDatabase>(context, listen: false).readHabits();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
            child: IconButton(
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
                icon: Icon(Provider.of<ThemeProvider>(context).isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode)),
          )
        ],
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        shape: const CircleBorder(
          eccentricity: 0,
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        foregroundColor: Colors.grey.shade900,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          //heatmap
          _buildHeatMap(),

          //habit list
          _buildHabitList(),
        ],
      ),
    );
  }

  //build heat map
  Widget _buildHeatMap() {
    //habit database
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return heat map UI
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        //once the data is avalaible --> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepareHeatMap(currentHabits));
        }

        //handle case where no data is returned
        else {
          return Container();
        }
      },
    );
  }

  //build habit list
  Widget _buildHabitList() {
    //habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return list of habits UI
    return ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          //get each individual habit
          final habit = currentHabits[index];

          //check if the habit is completed today
          bool isCompletedToday = isHabitCompletedToday(habit.completeDays);

          //return habit tile ui
          return HabitTile(
            text: habit.name,
            isCompleted: isCompletedToday,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (context) => editHabitBox(habit),
            deleteHabit: (context) => deleteHabitBox(habit),
          );
        });
  }
}
