import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushNamed(context, '/homepage'),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.help))],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //intro text
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(
              height: 25.0,
            ),
            //question
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              child: Row(
                children: [
                  Text(
                    "How do I delete or edit a habit?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Each habit on your habit list is a slidable tile. To delete or edit a habit, swipe from right to left and two icons will appear. Click on the bin icon to delete a habit and click on the pen icon to update your habit",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            //question
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.secondary),
              child: Row(
                children: [
                  Text(
                    "How does the habit heat map work?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "The heat map on the habit page is a habit-tracking mechanism that shows the progression of habit completion. The heatmap gives an appealing visual representation of your ability to lock in!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "For more information contact us at opensystechs@gmail.com",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
