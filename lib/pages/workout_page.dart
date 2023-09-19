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
              title: Text("Add a new exercise"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //exercise name
                  TextField(
                    controller: exerciseNameController,
                  ),
                  //weight
                  TextField(
                    controller: weightController,
                  ),
                  //reps
                  TextField(
                    controller: repsController,
                  ),

                  //sets
                  TextField(
                    controller: setsController,
                  ),
                ],
              ),
              actions: [
                MaterialButton(onPressed: save, child: Text("Save")),
                MaterialButton(onPressed: cancel, child: Text("Cancel")),
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
              appBar: AppBar(
                title: Text(widget.workoutName),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewExercise,
                child: const Icon(Icons.add),
              ),
              body: ListView.builder(
                  itemCount: value.numOfExercisesInWorkout(widget.workoutName),
                  itemBuilder: (context, index) => ExerciseTile(
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
                      )),
            ));
  }
}
