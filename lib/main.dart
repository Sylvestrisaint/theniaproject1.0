import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nia/database/habit_database.dart';
import 'package:nia/models/deadlines_data.dart';
import 'package:nia/models/note_data.dart';
import 'package:nia/pages/deadlines_page.dart';
import 'package:nia/pages/help_page.dart';
import 'package:nia/pages/notes_page.dart';
import 'package:nia/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:nia/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();

  //initialize hive
  await Hive.initFlutter();

  //open a hive box
  await Hive.openBox('note_database');

  //open hive tasks
  await Hive.openBox('tasks_database');

  runApp(MultiProvider(
    providers: [
      //habit provider
      ChangeNotifierProvider(create: (context) => HabitDatabase()),

      //notes provider
      ChangeNotifierProvider(
        create: (context) => NoteData(),
      ),

      //tasks provider
      ChangeNotifierProvider(
        create: (context) => DeadlinesData(),
      ),

      //theme provider
      ChangeNotifierProvider(create: (context) => ThemeProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/homepage': (context) => const HomePage(),
        '/notespage': (context) => const NotesPage(),
        '/deadlinespage': (context) => const DeadlinesPage(),
        '/helppage': (context) => const HelpPage(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
