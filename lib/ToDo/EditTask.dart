import 'package:TODO_APP/ToDo/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTask extends StatefulWidget {
  EditTask(this.data, this.index);
  QuerySnapshot data;
  int index;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  var _formKey = GlobalKey<FormState>();
  bool _autoValidate = true;
  TextEditingController _taskController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _taskController.text =
        widget.data.documents[widget.index]['body'].toString();
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.red,
              child: Icon(Icons.delete),
              onPressed: _delete,
            ),
            SizedBox(width: 15),
            FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.save),
              onPressed: _sumbit,
            ),
          ],
        ),
        appBar: AppBar(
          title: Text('Edit Task'),
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

  void _sumbit() async {
   FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autoValidate = true;
      });
    } else {
      Firestore.instance
          .collection(user.uid.toString())
          .document(widget.data.documents[widget.index].documentID)
          .updateData({
        'body': _taskController.text,
        'date': DateTime.now(),
      }).then((_) {
        Future<String> id = FirebaseAuth.instance.currentUser().then((user) {
          return user.uid.toString();
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }
  }

  void _delete() async{
   FirebaseUser user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection(user.uid.toString())
        .document(widget.data.documents[widget.index].documentID)
        .delete()
        .then((_) {
          Future<String> id = FirebaseAuth.instance.currentUser().then((user) {
          return user.uid.toString();
        });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }
}
