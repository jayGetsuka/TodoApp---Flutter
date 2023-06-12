import 'dart:math';
import 'package:flutter/material.dart';
import 'AddTodo.dart';
import 'EditTodo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:todoapp/models/DatabaseHelper.dart';
import 'ListTodo.dart';

class HistoryTodo extends StatefulWidget {
  const HistoryTodo({super.key});

  @override
  State<HistoryTodo> createState() => _HistoryTodoState();
}

class _HistoryTodoState extends State<HistoryTodo> {
  int _selectedIndex = 2;
  final List<Color> colors = [
    Color(0xFFF9ACC0),
    Color(0xFF86A5C4),
    Color(0xFFC4B3C3),
    Color(0xFFEEB189),
    Color(0xFFD9DEBB),
    Color(0xFFFAAE9F),
    Color(0xFFAAD4E0),
    Color(0xFFF9EEB6)
  ];

  final Random random = Random();

  Color getRandomColor() {
    final int randomIndex = random.nextInt(colors.length);
    return colors[randomIndex];
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final database = await DatabaseHelper().database;
    List<Map<String, dynamic>> todos =
        await database!.query('todos', where: 'complete = ?', whereArgs: [1]);
    return todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo App'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> todos = snapshot.data ?? [];

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> todo = todos[index];

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    color: getRandomColor(),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            child: Text(
                              todo['title'],
                              style: const TextStyle(
                                fontFamily: 'Sarabun',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 8),
                            child: Text(
                              todo['description'],
                              style: const TextStyle(fontFamily: 'Sarabun'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(13, 8, 5, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.access_time,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  todo['time'] + ' ' + todo['date'],
                                  style: const TextStyle(fontFamily: 'Sarabun'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'เพิ่มสิ่งที่ต้องทำ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: 'ประวัติสิ่งที่ทำแล้ว',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 16, fontFamily: 'Sarabun'),
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListTodo()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTodo()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryTodo()),
              );
          }
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}
