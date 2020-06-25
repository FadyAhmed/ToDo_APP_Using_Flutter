import 'package:TODO_APP/ToDo/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewTask extends StatefulWidget {
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  var _formKey = GlobalKey<FormState>();
  bool _done = false;
  bool _autoValidate = true;
  TextEditingController _taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: _sumbit,
        ),
        appBar: AppBar(
          title: Text('New Task'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: Form(
            autovalidate: _autoValidate,
            key: _formKey,
            child: TextFormField(
              focusNode: FocusNode(canRequestFocus: true),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Nothing ToDo';
                } else {
                  return null;
                }
              },
              controller: _taskController,
              decoration: InputDecoration(
                
                hintText: '  ToDo',
              ),
            ),
          ),
        ));
  }

  void _sumbit() {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidate = true;
      });
    }else{
      FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection(user.uid.toString()).document().setData({
        'body': _taskController.text,
        'done': 'false',
        'uid': user.uid,
        'date' : DateTime.now() ,
      }).then((_) {
        
        Navigator.pop(context);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        Navigator.pop(context);
      });
    });
    }
    
  }
}
