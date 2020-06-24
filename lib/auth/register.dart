import 'dart:developer';
import 'package:TODO_APP/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:TODO_APP/ToDo/HomeScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirmation = TextEditingController();

  var _formKey = GlobalKey<FormState>();
  bool _autoValidation = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: _isLoading
          ? _loadingScreen()
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                child: Form(
                  autovalidate: _autoValidation,
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: (value) {
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
                      TextFormField(
                        controller: _passwordConfirmation,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                        ),
                        validator: (value) {
                          log(value);
                          log(_password.value.text);

                          if (value.isEmpty) {
                            return 'Confirmation is required';
                          } else if (value != _password.value.text) {
                            return 'don\'t match';
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
                            onPressed: _onRegisterClick,
                            child: Text('Register'),
                          )),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              'OR login',
                              style: TextStyle(color: Colors.blue[800]),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
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
    return Center(
        child: Container(
      child: CircularProgressIndicator(),
    ));
  }

  void _onRegisterClick() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidation = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _autoValidation = false;
        _isLoading = true;
      });

//Firebase Codes
      AuthResult result;
      try {
        result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);
      } catch (error) {
        log(error.toString());
      }

      if (result == null) {
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
            content: Text('Wrong email format'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  setState(() {
                    _isLoading = false;
                  });
                  return Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
