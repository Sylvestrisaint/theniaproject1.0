import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const HabitTile({
    super.key,
    required this.text,
    required this.isCompleted,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            const SizedBox(
              width: 5.0,
            ),
            //edit option
            SlidableAction(
              onPressed: editHabit,
              backgroundColor: Colors.red.shade800,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(8.0),
            ),

            const SizedBox(
              width: 5.0,
            ),

            //delete option
            SlidableAction(
              onPressed: deleteHabit,
              backgroundColor: Colors.grey.shade800,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              //toggle completion status
              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.shade900
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(
                text,
                style: isCompleted
                    ? const TextStyle(color: Colors.white)
                    : const TextStyle(),
              ),
              leading: Checkbox(
                checkColor: isCompleted ? Colors.white : Colors.black,
                activeColor: Colors.green.shade900,
                onChanged: onChanged,
                value: isCompleted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
