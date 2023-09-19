import 'package:fex_app/components/heat_map.dart';
import 'package:fex_app/data/workout_data.dart';
import 'package:flutter/material.dart';
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

  //text controller
  final newWorkoutNameController = TextEditingController();

  //create new workout
  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Create new workout"),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                MaterialButton(onPressed: save, child: Text("Save")),
                MaterialButton(onPressed: cancel, child: Text("Cancel")),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(title: Text("Workout Tracker")),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewWorkout,
              child: const Icon(Icons.add),
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
                    itemBuilder: (context, index) => ListTile(
                          title: Text(value.getWorkoutList()[index].name),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () => goToWorkoutPage(
                                value.getWorkoutList()[index].name),
                          ),
                        )),
              ],
            )));
  }
}
