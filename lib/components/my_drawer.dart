import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //logo
              Container(
                  height: 200,
                  padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: Center(
                    child: Image.asset(
                      "lib/images/icons/nia_logo.png",
                      height: 150,
                    ),
                  )),

              //home list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);

                    //navigate to home page
                    Navigator.pushNamed(context, '/homepage');
                  },
                ),
              ),

              //IEs list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("D E A D L I N E S"),
                  leading: const Icon(Icons.calendar_month_outlined),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);

                    //navigate to settings page
                    Navigator.pushNamed(context, '/deadlinespage');
                  },
                ),
              ),

              //settings list tile
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("N O T E S"),
                  leading: const Icon(Icons.edit_document),
                  onTap: () {
                    //pop the drawer
                    Navigator.pop(context);

                    //navigate to notespage page
                    Navigator.pushNamed(context, '/notespage');
                  },
                ),
              ),
            ],
          ),

          //help list tile
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: const Text("H E L P"),
              leading: const Icon(Icons.help),
              onTap: () {
                //pop the drawer
                Navigator.pop(context);

                //navigate to helppage page
                Navigator.pushNamed(context, '/helppage');
              },
            ),
          ),
        ],
      ),
    );
  }
}
