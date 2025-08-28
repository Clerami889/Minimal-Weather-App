import 'package:flutter/material.dart';
import 'package:weather/Screen/home.dart';

void main() async {
  runApp(
    MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
    ),
  );
}
