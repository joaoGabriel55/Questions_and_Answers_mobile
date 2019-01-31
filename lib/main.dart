import 'package:flutter/material.dart';
import 'package:q_and_a/ui/homeScreen.dart';
import 'package:q_and_a/ui/loginScreen.dart';
import 'package:q_and_a/ui/signupScreen.dart';
import 'package:q_and_a/ui/splashScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  var _splashShown = false;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Questions & Answers',
      theme: new ThemeData(
          primarySwatch: Colors.blue, accentColor: Colors.blueAccent),
      routes: <String, WidgetBuilder>{
        "/HomeScreen": (BuildContext context) => HomeScreen(),
        "/LoginScreen": (BuildContext context) => LoginScreen(),
        "/Signup": (BuildContext context) => SignupScreen(),
      },
      home: SplashScreen(),
    );
  }
}
