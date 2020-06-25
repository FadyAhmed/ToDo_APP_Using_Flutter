import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'ToDo/HomeScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  Future<String> id = FirebaseAuth.instance.currentUser().then((user) {
          return user.uid.toString();
        });
  Widget homeScreen = HomeScreen();

  if (user == null) {
    homeScreen = LoginScreen();
  }
  runApp(ToDoApp(homeScreen, user));
}

class ToDoApp extends StatelessWidget {
  final Widget home;
  final FirebaseUser user;
  ToDoApp(this.home, this.user);
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseUser>.value(
      value: user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: this.home,
      ),
    );
  }
}
