import 'package:fex_app/datetime/date_time.dart';
import 'package:fex_app/models/exercise.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout.dart';

class HiveDatabase {
  final _myBox = Hive.box("workout_database");

  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data does not exist");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data exists");
      return true;
    }
  }

  void clearData() {
    _myBox.clear();
  }

  void setStartDate() {
    _myBox.delete("START_DATE");
    _myBox.put("START_DATE", todaysDateYYYYMMDD());
  }

  String getStartDate() {
    return _myBox.get("START_DATE");
  }

  //write
  void saveToDatabase(List<Workout> workouts) {
    //convert workout objects into a lists of strings to save in hive database
    final workoutList = convertObjectToWorkouList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /*
      check if any exercises have been done
      put a 0 or 1 for each yyyymmdd date
    */

    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _myBox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    //save into hive
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  //read
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");

    //create workout object
    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exerciseInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //add each exercise to the list
        exerciseInEachWorkout.add(Exercise(
          name: exerciseDetails[i][j][0],
          weight: exerciseDetails[i][j][1],
          reps: exerciseDetails[i][j][2],
          sets: exerciseDetails[i][j][3],
          isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
        ));

        //create individual workout
        Workout workout =
            Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);

        //add individual workout to the overall list
        mySavedWorkouts.add(workout);
      }
    }
    return mySavedWorkouts;
  }

  //checks if any exercises are done
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletionStatus(String yyyymmdd) {
    int completionStatus = _myBox.get("COMPLETION_STATUS_${yyyymmdd}") ?? 0;
    return completionStatus;
  }
}

//convert workout object to lists
List<String> convertObjectToWorkouList(List<Workout> workouts) {
  List<String> workoutList = [
    //eg. [upper body, lower body]
  ];

  for (int i = 0; i < workouts.length; i++) {
    //in each workout, add the name, followed by the list of exercise
    workoutList.add(
      workouts[i].name,
    );
  }

  return workoutList;
}

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    /* Upperbody
        [[biceps, 10kg, 10, 5]]
     */
  ];

  //going throug each workout
  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exerciseInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [];

    //go through each exercise in the exerciseList
    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [
        // [biceps, 10kg, 10, 5]
      ];
      individualExercise.addAll(
        [
          exerciseInWorkout[j].name,
          exerciseInWorkout[j].weight,
          exerciseInWorkout[j].reps,
          exerciseInWorkout[j].sets,
          exerciseInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
