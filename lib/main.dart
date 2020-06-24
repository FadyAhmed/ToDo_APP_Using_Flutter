import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'ToDo/HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Widget homeScreen = HomeScreen();
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  if (user == null) {
    homeScreen = LoginScreen();
  }
  runApp(ToDoApp(homeScreen));
}

class ToDoApp extends StatelessWidget {
  final Widget home;
  ToDoApp(this.home);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: this.home,
    );
  }
}
