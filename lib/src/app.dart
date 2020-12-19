import 'package:flutter/material.dart';
import 'package:todolistapp/screens/home_screen.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(primarySwatch: Colors.purple),
      home: HomeScreen(),
    );
  }
}