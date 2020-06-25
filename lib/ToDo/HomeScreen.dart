import 'dart:developer';

import 'package:TODO_APP/ToDo/EditTask.dart';
import 'package:TODO_APP/ToDo/NewTask.dart';
import 'package:TODO_APP/auth/login.dart';
import 'package:TODO_APP/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController scrollController = ScrollController();
  String done = 'true';
  bool _bottom = false;
  IconData box;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
      floatingActionButton: AddBtn(_bottom, scrollController),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return _loading();
                break;

              case ConnectionState.none:
                return internetConnectionPeoblem();
                break;
              case ConnectionState.done:
                if (snapshot.error != null) {
                  return internetConnectionPeoblem();
                } else {
                  if (snapshot.hasData) {
                    _body(context, snapshot.data);
                  } else {
                    return _noData();
                  }
                }
                break;
            }

            return _body(context, snapshot.data);
          }),
    );
  }

  Widget _body(BuildContext context, QuerySnapshot data) {
    if (data.documents.length == 0) {
      return _noData();
    } else {
      return Stack(
        children: <Widget>[
          ListView.builder(
              controller: scrollController,
              itemCount: data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                done = data.documents[index]['done'].toString();

                if (done == 'true') {
                  box = Icons.check_box;
                } else {
                  box = Icons.check_box_outline_blank;
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Card(
                    elevation: 3,
                    child: ExpansionTile(
                      leading: Transform.translate(
                        offset: Offset(-10, 0),
                        child: IconButton(
                          icon: Icon(box),
                          onPressed: () {
                            done = data.documents[index]['done'].toString();

                            if (done == 'true') {
                              done = 'false';
                              Firestore.instance
                                  .collection(data.documents[index]['uid'])
                                  .document(data.documents[index].documentID)
                                  .updateData({'done': done});
                            } else {
                              done = 'true';
                              Firestore.instance
                                  .collection(data.documents[index]['uid'])
                                  .document(data.documents[index].documentID)
                                  .updateData({'done': done});
                            }
                          },
                        ),
                      ),
                      title: Transform.translate(
                          offset: Offset(-15, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(data.documents[index]['body']
                                      .toString())),
                            ],
                          )),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, bottom: 4, right: 24),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child:
                                Text(data.documents[index]['done'].toString()),
                          ),
                        ),
                      ],
                      trailing: Stack(children: <Widget>[
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: -12,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          EditTask(data, index)));
                                }),
                            IconButton(
                                icon: Icon(Icons.offline_pin),
                                onPressed: () {}),
                          ],
                        ),
                      ]),
                    ),
                  ),
                );
              }),
        ],
      );
    }
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _noData() {
    return Center(child: Text('No Tasks ToDo yet'));
  }
}

Widget internetConnectionPeoblem() {
  return Center(
    child: Column(
      children: <Widget>[
        Text('Internet connection problem..'),
        RaisedButton(
          onPressed: () {},
          child: Text('Refresh'),
        )
      ],
    ),
  );
}

class CheckBox extends StatefulWidget {
  CheckBox(
    this.done,
    this.index,
    this.data,
  );
  bool done;
  int index;
  QuerySnapshot data;
  @override
  CheckBoxState createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: widget.done
            ? Icon(Icons.check_box_outline_blank)
            : Icon(Icons.check_box),
        onPressed: () {
          widget.done = !widget.done;
          Firestore.instance
              .collection(widget.data.documents[widget.index]['uid'])
              .document(widget.data.documents[widget.index].documentID)
              .updateData({'done': widget.done});
        });
  }
}

class AddBtn extends StatefulWidget {
  AddBtn(this.bottom, this.scrollController);
  bool bottom;
  ScrollController scrollController;
  @override
  _AddBtnState createState() => _AddBtnState();
}

class _AddBtnState extends State<AddBtn> {
  @override
  Widget build(BuildContext context) {
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >=
          widget.scrollController.position.maxScrollExtent - 100) {
        setState(() {
          widget.bottom = true;
        });
      } else {
        setState(() {
          widget.bottom = false;
        });
      }
    });
    return widget.bottom
        ? Container()
        : FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => NewTask()));
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 40,
            ),
          );
  }
}
