import 'package:daily_task_planner/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Daily Task Planner",
      theme: ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily),
      home: HomeScreen(),
    );
  }
}
