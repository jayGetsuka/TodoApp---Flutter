import 'package:flutter/material.dart';
import 'package:todoapp/pages/ListTodo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  /*
  final database = await openDatabase(
    join(await getDatabasesPath(), 'todo_app.db'),
    onCreate: (db, version) {
      // สร้างตาราง todos
      return db.execute(
        'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, complete INTEGER DEFAULT 0, date TEXT, time TEXT)',
      );
    },
    version: 1,
  );
  */
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ListTodo(),
    );
  }
}
