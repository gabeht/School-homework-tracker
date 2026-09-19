import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'main_navigation.dart';


void main() {
  runApp(const HomeworkTrackerApp());
}

//HomeworkTrackerApp Widget, first chunk of code used in project
class HomeworkTrackerApp extends StatelessWidget {
  const HomeworkTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Homework Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
      );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override 
  void initState() {
    super.initState();
    Timer(const Duration(seconds:3),(){
      Navigator.of(
        context,
        ).pushReplacement(MaterialPageRoute(builder:
         (_) => const MainNavigationScreen()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Homework Tracker',
              style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight:FontWeight.bold,
            ),
            ),
            const SizedBox(height: 24),
            LoadingAnimationWidget.inkDrop(
              color: Colors.white,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }

}