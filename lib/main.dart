import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 1, 1, 2),
        highlightColor: Color.fromRGBO(87, 247, 194, 1),
      ),
      home: HomeScreen(),
    );
  }
}
