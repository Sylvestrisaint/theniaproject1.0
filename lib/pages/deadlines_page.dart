import 'package:flutter/material.dart';
import 'package:nia/components/my_drawer.dart';
import 'package:nia/models/deadlines.dart';
import 'package:nia/models/deadlines_data.dart';
import 'package:provider/provider.dart';

class DeadlinesPage extends StatefulWidget {
  const DeadlinesPage({super.key});

  @override
  State<DeadlinesPage> createState() => _DeadlinesPageState();
}

class _DeadlinesPageState extends State<DeadlinesPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<DeadlinesData>(context, listen: false).initializeDeadlines();
  }

  // //tasks list
  // List<Deadline> tasks = Provider.of<DeadlinesData>(context, listen: false).getAllDeadlines();

  //initialize with the current date
  DateTime _selectedDate = DateTime.now();
  late String _taskTitle;

  //function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeadlinesData>(
      builder: (context, value, child) => Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          elevation: 0,
          title: const Center(
            child: Text(
              "Deadlines",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.calendar_month_sharp))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          //add new task
          onPressed: () => _addDeadline(),
          elevation: 0,
          shape: const CircleBorder(
            eccentricity: 0,
          ),
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          foregroundColor: Colors.grey.shade900,
          child: const Icon(Icons.add_circle_outline_outlined),
        ),
        body: ListView(children: [
          //build tasks list
          _buildTaskList(),
        ]),
      ),
    );
  }

  //add task
  void _addDeadline() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Add Task"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: "Task Title"),
                  onChanged: (value) {
                    setState(() {
                      //update the task title when text changes
                      _taskTitle = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                    "Due on: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                const SizedBox(
                  height: 8.0,
                ),
                TextButton(
                    onPressed: () {
                      //show the date picker when the button is pressed
                      _selectDate(context);
                    },
                    child: const Text("Select Due Date"))
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    //add the task to the list if the title is not empty
                    if (_taskTitle.isNotEmpty) {
                      setState(() {
                        //add the new note
                        Provider.of<DeadlinesData>(context, listen: false)
                            .addNewDeadline(Deadline(
                                title: _taskTitle, dueTime: _selectedDate));
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add"))
            ],
          );
        });
  }

  //delete task
  void deleteTask(Deadline deadline) {
    Provider.of<DeadlinesData>(context, listen: false).deleteDeadline(deadline);
  }

  //build tasks list
  Widget _buildTaskList() {
    //get list of all tasks
    List<Deadline> tasks =
        Provider.of<DeadlinesData>(context, listen: false).getAllDeadlines();

    //return list of tasks UI
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
                height: 10.0,
              ),
          itemCount: Provider.of<DeadlinesData>(context, listen: false)
              .getAllDeadlines()
              .length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).colorScheme.secondary),
              child: ListTile(
                title: Text(tasks[index].title),
                subtitle: Text(
                    "Due on: ${tasks[index].dueTime.day}-${tasks[index].dueTime.month}-${tasks[index].dueTime.year}"),
                trailing: IconButton(
                    onPressed: () => deleteTask(
                        Provider.of<DeadlinesData>(context, listen: false)
                            .getAllDeadlines()[index]),
                    icon: const Icon(Icons.delete)),
              ),
            );
          }),
    );
  }
}
