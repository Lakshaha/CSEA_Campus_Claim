import 'package:campus_commute/Screens/requesting_ride.dart';
import 'package:campus_commute/Screens/wrapper_screen.dart';
import 'package:flutter/material.dart';
import 'Screens/signin_screen.dart';
import 'Screens/signup_screen.dart';
import 'Screens/home_screen.dart';
import 'Screens/edit_user_screen.dart';
import 'Screens/upload_request_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'sign_in',
      routes: {
        '/': (context) => WrapperScreen(),
        'home': (context) => homeScreen(),
        'sign_in': (context) => signIn(),
        'sign_up': (context) => signUp(),
        'upload_request': (context) => uploadRequest(),
        'edit_user': (context) => editUserInfo(),
        //'request_ride': (context) => RequestingRide(),
      },
    );
  }
}
