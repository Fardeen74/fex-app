import 'package:fex_app/data/hive_database.dart';
import 'package:fex_app/datetime/date_time.dart';
import 'package:flutter/material.dart';

import '../models/exercise.dart';
import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  List<Workout> workoutList = [
    //defualt workout
    Workout(
      name: "UPPER BODY",
      exercises: [
        Exercise(name: "Bicep curls", weight: "10", reps: "10", sets: "3"),
      ],
    ),

    Workout(
      name: "LOWER BODY",
      exercises: [
        Exercise(name: "Squats", weight: "10", reps: "10", sets: "3"),
      ],
    )
  ];

  //get lenght of given workout
  int numOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRevelantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  //if there are workouts already in the database, then get
  void intializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }
    //otherwise use default workout list
    else {
      db.saveToDatabase(workoutList);
    }

    //load the heatmap
    loadHeatMap();
  }

  //delete
  void deleteWorkout(String workoutName) {
    //workoutList = db.readFromDatabase();
    //Workout wd = workoutList.firstWhere((w) => w.name == workoutName);

    workoutList.removeWhere((w) => w.name == workoutName);
    db.saveToDatabase(workoutList);
    notifyListeners();
  }

  //get list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //add workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);
  }

  //add exercises to workout
  void addExercises(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    //find the revelant exercise
    Workout revelantWorkout = getRevelantWorkout(workoutName);

    revelantWorkout.exercises.add(
      Exercise(
        name: exerciseName,
        weight: weight,
        reps: reps,
        sets: sets,
      ),
    );
    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);
  }

//check of  exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRevelantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();

    //save to database
    db.saveToDatabase(workoutList);

    //load the heatmap
    loadHeatMap();
  }

  //method to find the revelant workout
  Workout getRevelantWorkout(String workoutName) {
    Workout revelantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return revelantWorkout;
  }

  //get revelant exercise
  Exercise getRevelantExercise(String workoutName, String exerciseName) {
    Workout revelantWorkout = getRevelantWorkout(workoutName);

    Exercise revelantExercise = revelantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return revelantExercise;
  }

  String getStartDate() {
    return db.getStartDate();
  }

  //HEAT MAP
  Map<DateTime, int> heatmapDataset = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    //go from the start date to today, add add each completion status to dataset
    //COMPLETION_STATUS_yyyymmdd will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      //completion status
      int completionStatus = db.getCompletionStatus(yyyymmdd);
      //year
      int year = startDate.add(Duration(days: i)).year;
      //month
      int month = startDate.add(Duration(days: i)).month;
      //day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };
      heatmapDataset.addEntries(percentForEachDay.entries);
    }
  }
}
