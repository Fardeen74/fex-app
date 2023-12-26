import 'dart:math';

import 'package:fex_app/components/heat_map.dart';
import 'package:fex_app/components/workout_tile.dart';
import 'package:fex_app/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => __HomePageState();
}

class __HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Provider.of<WorkoutData>(context, listen: false).intializeWorkoutList();
  }

  //style
  final fontStyle = const TextStyle(
      fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);

  //text controller
  final newWorkoutNameController = TextEditingController();

  //create new workout
  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text(
                "Create new workout",
                style: TextStyle(color: Colors.white),
              ),
              content: TextField(
                style: TextStyle(color: Colors.white),
                controller: newWorkoutNameController,
                decoration: const InputDecoration(
                    hintText: "New Workout",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
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

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

  //save changes
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    //pop the dialog box
    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear
  void clear() {
    newWorkoutNameController.clear();
  }

  void settings_Slide() {}

  void delete_Slide(String workoutName) {
    Provider.of<WorkoutData>(context, listen: false).deleteWorkout(workoutName);
    //print(workoutName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: Colors.blueGrey[100],
          floatingActionButton: FloatingActionButton(
            onPressed: createNewWorkout,
            backgroundColor: Colors.black,
            child: const Icon(
              Icons.add,
            ),
          ),
          body: ListView(
            children: [
              //HEAT MAP
              MyHeatMap(
                  datasets: value.heatmapDataset,
                  startDateYYYYMMDD: value.getStartDate()),
              //WORKOUTLIST
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getWorkoutList().length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                    endActionPane:
                        ActionPane(motion: const StretchMotion(), children: [
                      // settings option
                      // SlidableAction(
                      //   onPressed: (context) => settings_Slide(),
                      //   backgroundColor: Colors.grey.shade800,
                      //   icon: Icons.settings,
                      //   borderRadius: BorderRadius.circular(15),
                      // ),

                      // delete option
                      SlidableAction(
                        onPressed: (context) =>
                            delete_Slide(value.getWorkoutList()[index].name),
                        backgroundColor: Colors.red.shade400,
                        icon: Icons.delete,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ]),
                    child: Container(
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        leading: SizedBox(
                          height: 45,
                          child: Image.asset('lib/icons/dumbell.png'),
                        ),
                        tileColor: Colors.grey[900],
                        contentPadding: const EdgeInsets.all(20.0),
                        title: Center(
                          child: Text(
                            value.getWorkoutList()[index].name,
                            style: fontStyle,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          color: Colors.white,
                          onPressed: () => goToWorkoutPage(
                              value.getWorkoutList()[index].name),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
