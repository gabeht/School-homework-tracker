import 'package:flutter/material.dart';
//Loading Screen Animation exteneral package used for aesthetic
import 'package:loading_animation_widget/loading_animation_widget.dart';

//Local Project files (views)
import 'views/main_navigation.dart';
import 'views/login_screen.dart';

//Package Import/Manager for Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HomeworkTrackerApp());
}

//HomeworkTrackerApp Widget, first chunk of code used in project
class HomeworkTrackerApp extends StatelessWidget {
  const HomeworkTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LoadingAnimationWidget.inkDrop(color: Colors.white, size: 60)
                ],
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return const MainNavigationScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

//ARCHIVED CODE AS OF 9/25/2026
//LAB 4 NEW MAIN LOGIC INTRODUCED
// class _SplashScreenState extends State<SplashScreen>{
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds:3),(){
//       Navigator.of(
//         context,
//         ).pushReplacement(MaterialPageRoute(builder:
//          (_) => const MainNavigationScreen()));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Homework Tracker',
//               style: TextStyle(
//               fontSize: 28,
//               color: Colors.white,
//               fontWeight:FontWeight.bold,
//             ),
//             ),
//             const SizedBox(height: 24),
//             LoadingAnimationWidget.inkDrop(
//               color: Colors.white,
//               size: 60,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }
