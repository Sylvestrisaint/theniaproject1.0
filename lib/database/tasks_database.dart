import 'package:hive/hive.dart';
import 'package:nia/models/deadlines.dart';

class TasksDatabase {
  //reference our hive box
  final _mytasks = Hive.box('tasks_database');

  //load tasks
  List<Deadline> loadTasks() {
    List<Deadline> savedTasksFormatted = [];

    //if there exist tasks return that, otherwise return empty list
    if (_mytasks.get("ALL_TASKS") != null) {
      List<dynamic> savedTasks = _mytasks.get("ALL_TASKS");
      for (int i = 0; i < savedTasks.length; i++) {
        //create individual task
        Deadline individualTask =
            Deadline(title: savedTasks[i][0], dueTime: savedTasks[i][1]);

        //add to list
        savedTasksFormatted.add(individualTask);
      }
    }
    return savedTasksFormatted;
  }

  //save tasks
  void savedTasks(List<Deadline> allTasks) {
    List<List<dynamic>> allTasksFormatted = [];

    //each tasks has a title and date
    for (var task in allTasks) {
      String title = task.title;
      DateTime time = task.dueTime;
      allTasksFormatted.add([title, time]);
    }

    //then store into hive
    _mytasks.put("ALL_TASKS", allTasksFormatted);
  }
}
