import 'package:flutter/material.dart';
import 'package:nia/database/tasks_database.dart';
import 'package:nia/models/deadlines.dart';

class DeadlinesData extends ChangeNotifier {
  //tasks database
  final db = TasksDatabase();

  //overall list of Deadlines
  List<Deadline> allDeadlines = [];

  //initialize list
  void initializeDeadlines() {
    allDeadlines = db.loadTasks();
  }

  //get deadlines
  List<Deadline> getAllDeadlines() {
    return allDeadlines;
  }

  //add a new Deadline
  void addNewDeadline(Deadline deadline) {
    allDeadlines.add(deadline);
    db.savedTasks(allDeadlines);
    notifyListeners();
  }

  //update Deadline
  void updateDeadline(Deadline deadline, DateTime date) {
    //go through list of all deadlines
    for (int i = 0; i < allDeadlines.length; i++) {
      //find the relevant deadline
      if (allDeadlines[i].title == deadline.title) {
        allDeadlines[i].dueTime = date;
      }
    }
    db.savedTasks(allDeadlines);
    notifyListeners();
  }

  //delete Deadline
  void deleteDeadline(Deadline deadline) {
    allDeadlines.remove(deadline);
    db.savedTasks(allDeadlines);
    notifyListeners();
  }
}
