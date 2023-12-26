import 'package:fex_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  // void goToHomePage() {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => HomePage(),
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Fex",
                style: GoogleFonts.dmSerifDisplay(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              //const SizedBox(height: 25),
              //icon
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Image.asset('lib/icons/heart.png'),
              ),
              //
              Text(
                "Your Workout Companion",
                style: GoogleFonts.dmSerifDisplay(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              //subtitle
              Text(
                "Track your daily workouts and watch your progress",
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              //button
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ))
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.all(25),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Get Started",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
