import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/task.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _taskController;
  List<Task> _tasks;
  List<bool> _tasksDone;

  void _getTask() async {
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasks = prefs.getString("task");
    List list = (tasks == null) ? [] : json.decode(tasks);
    for (dynamic d in list) {
      _tasks.add(Task.fromMap(json.decode(d)));
    }
    print(_tasks);

    _tasksDone = List.generate(_tasks.length, (index) => false);
    setState(() {});
  }

  void saveDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(_taskController.text);
    String tasks = prefs.getString("task");
    List list = (tasks == null) ? [] : json.decode(tasks);
    print(list);
    list.add(json.encode(t.getMap()));
    print(list);
    prefs.setString('task', json.encode(list));
    _taskController.text = "";
    Navigator.of(context).pop();
    _getTask();
  }

  void updatePendingTaskList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList = [];
    for (var i = 0; i < _tasks.length; i++) {
      if (!_tasksDone[i]) pendingList.add(_tasks[i]);
    }
    var pendingListEncoded = List.generate(
      pendingList.length,
      (i) => json.encode(
        pendingList[i].getMap(),
      ),
    );

    prefs.setString('task', json.encode(pendingListEncoded));

    _getTask();
  }

  @override
  void initState() {
    super.initState();

    _getTask();

    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.save,
                color: Colors.greenAccent,
              ),
              onPressed: () {
                updatePendingTaskList();
              }),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('task', json.encode([]));
                _getTask();
              }),
        ],
        title: Text("Daily Task Manager"),
      ),
      body: (_tasks == null)
          ? Center(
              child: Text("No Tasks Added Yet!"),
            )
          : SingleChildScrollView(
              child: Column(
                children: _tasks
                    .map(
                      (e) => Container(
                        height: 70.0,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0,
                        ),
                        padding: const EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black,
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              e.task,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Checkbox(
                              value: _tasksDone[_tasks.indexOf(e)],
                              key: GlobalKey(),
                              onChanged: (val) {
                                setState(() {
                                  _tasksDone[_tasks.indexOf(e)] = val;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blue,
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(10.0),
            // height: 500.0,
            color: Colors.blueAccent[200],
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add a Task",
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
                Divider(thickness: 3.2),
                SizedBox(height: 20.0),
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    hintText: "Enter your task",
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.9),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _taskController.text = "",
                      child: Text("RESET"),
                    ),
                    ElevatedButton(
                      onPressed: () => saveDate(),
                      child: Text("ADD"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
