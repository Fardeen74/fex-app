import 'package:fex_app/components/exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  //Text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  //create new exercise
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey.shade900,
              title: const Text(
                "Add a new exercise",
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //exercise name
                  TextField(
                    controller: exerciseNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Exercise name",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                  const SizedBox(height: 15),
                  //weight
                  TextField(
                    controller: weightController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Weight (kg)",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                  const SizedBox(height: 15),
                  //reps
                  TextField(
                    controller: repsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Reps",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                  const SizedBox(height: 15),
                  //sets
                  TextField(
                    controller: setsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Sets",
                        hintStyle: TextStyle(color: Colors.white60),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  color: Colors.black,
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  onPressed: cancel,
                  color: Colors.black,
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExercises(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    //pop the dialog box
    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              backgroundColor: Colors.blueGrey[100],
              appBar: AppBar(
                title: Text(widget.workoutName),
                backgroundColor: Colors.black,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewExercise,
                backgroundColor: Colors.black,
                child: const Icon(Icons.add),
              ),
              body: ListView.builder(
                  itemCount: value.numOfExercisesInWorkout(widget.workoutName),
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: ExerciseTile(
                          exerciseName: value
                              .getRevelantWorkout(widget.workoutName)
                              .exercises[index]
                              .name,
                          weight: value
                              .getRevelantWorkout(widget.workoutName)
                              .exercises[index]
                              .weight,
                          reps: value
                              .getRevelantWorkout(widget.workoutName)
                              .exercises[index]
                              .reps,
                          sets: value
                              .getRevelantWorkout(widget.workoutName)
                              .exercises[index]
                              .sets,
                          isCompleted: value
                              .getRevelantWorkout(widget.workoutName)
                              .exercises[index]
                              .isCompleted,
                          onCheckBoxChanged: (val) => onCheckBoxChanged(
                              widget.workoutName,
                              value
                                  .getRevelantWorkout(widget.workoutName)
                                  .exercises[index]
                                  .name),
                        ),
                      )),
            ));
  }
}
