import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  final fontStyle = const TextStyle(
    fontSize: 20,
    //color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white70,
      ),
      padding: EdgeInsets.all(12.0),
      child: ListTile(
        title: Text(exerciseName, style: fontStyle),
        contentPadding: EdgeInsets.all(12.0),
        selectedTileColor: Colors.green.shade600,
        subtitle: Row(
          children: [
            //weight
            Chip(
              label: Text(
                "$weight kg",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.grey.shade700,
            ),
            SizedBox(width: 5),
            //reps
            Chip(
              label: Text("$reps reps",
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey.shade700,
            ),
            SizedBox(width: 5),
            //sets
            Chip(
              label: Text("$sets sets",
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey.shade700,
            ),
            SizedBox(width: 5),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
        ),
      ),
    );
  }
}
