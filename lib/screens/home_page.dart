import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Task Manager"),
      ),
      body: Center(
        child: Text("No Tasks Added Yet!"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("FAB Added");
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.yellowAccent,
      ),
    );
  }
}
