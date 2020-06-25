import 'dart:developer';

import 'package:TODO_APP/ToDo/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:TODO_APP/auth/register.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  var _loginFormKey = GlobalKey<FormState>();
  bool _autoValidation = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: _isLoading
          ? _loadingScreen()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Form(
                  key: _loginFormKey,
                  autovalidate: _autoValidation,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (value) {
                          log(_email.text);
                          log(_password.text);
                          if (value.isEmpty) {
                            return 'Email is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'password is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: _onLoginClikced,
                            child: Text('Login'),
                          )),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: <Widget>[
                          Text('Don\'t have an account? '),
                          InkWell(
                            child: Text(
                              'Rigester now',
                              style: TextStyle(color: Colors.blue[800]),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _loadingScreen() {
    return Center(child: CircularProgressIndicator());
  }

  void _onLoginClikced() async {
    if (!_loginFormKey.currentState.validate()) {
      setState(() {
        _autoValidation = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _autoValidation = false;
        _isLoading = true;
      });
      AuthResult user;
      try {
        user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _email.text, password: _password.text);
        log(_email.text);
      } on PlatformException catch (error) {
        log(error.toString());
      }
      if (user == null) {
        return _alert();
      } else {

        
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    }
  }

  void _alert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('You\'re not signed in'),
            actions: <Widget>[
              FlatButton(
                child: Text('Register'),
                onPressed: () {
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => RegisterScreen()));
                },
              ),
              FlatButton(
                child: Text('Try again'),
                onPressed: () {
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
