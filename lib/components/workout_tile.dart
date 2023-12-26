import 'package:flutter/material.dart';

class WorkoutTile extends StatelessWidget {
  final String workoutName;

  const WorkoutTile({super.key, required this.workoutName});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: SizedBox(
            height: 45,
            child: Image.asset('lib/icons/dumbell.png'),
          ),
          tileColor: Colors.grey[900],
          contentPadding: const EdgeInsets.all(20.0),
          title: Center(
            child: Text(
              workoutName,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            color: Colors.white,
            onPressed: () => (),
          ),
        ));
  }
}
