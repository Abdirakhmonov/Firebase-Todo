import 'package:flutter/material.dart';
import 'package:homework_47/service/todo_service.dart';
import 'package:homework_47/views/screens/todo_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final abx = TodosHttpService();
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
        home: TodoScreen()
    );
  }
}
