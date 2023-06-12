import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/DatabaseHelper.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/widgets.dart';
import 'HistoryTodo.dart';
import 'ListTodo.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  int _selectedIndex = 1;
  TextEditingController titleInput = TextEditingController();
  TextEditingController descInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  String text = "";

  Future<void> _saveTodo() async {
    final title = titleInput.text;
    final description = descInput.text;
    final date = dateInput.text;
    final time = timeInput.text;

    final database = await DatabaseHelper().database;

    await database!
        .insert(
      'todos',
      {
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'complete': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ListTodo(),
        ),
      );
    });
  }

  Future<void> showTimePickerDialog() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    if (pickedTime != null) {
      DateTime currentTime = DateTime.now();
      DateTime selectedTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      String formattedTime = DateFormat('HH:mm:ss').format(selectedTime);

      setState(() {
        timeInput.text = formattedTime;
      });
    } else {
      print("Time is not selected");
    }
  }

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo App'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                  child: Column(
                children: [
                  Text(
                    'แบบฟอร์ม',
                    style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'สำหรับเพิ่มสิ่งที่ต้องทำ',
                      style:
                          TextStyle(fontFamily: 'Sarabun', color: Colors.grey),
                    ),
                  )
                ],
              )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 15),
              child: TextFormField(
                controller: titleInput,
                style: TextStyle(
                    fontSize: 18, color: Colors.black, fontFamily: 'Sarabun'),
                onChanged: (value) => setState(() {
                  final newText = titleInput.value.text.trimLeft();
                  if (value != newText) {
                    titleInput.value = titleInput.value.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                }),
                decoration: InputDecoration(
                  fillColor: Colors.grey,
                  focusColor: Colors.white,
                  //add prefix icon
                  prefixIcon: Icon(
                    Icons.title,
                    color: Colors.black,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  hintText: "หัวข้อ",

                  //make hint text
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "Sarabun",
                  ),
                  //create lable
                  labelText: 'หัวข้อ',
                  //lable style
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "Sarabun",
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                controller: descInput,
                style: TextStyle(
                    fontSize: 18, color: Colors.black, fontFamily: 'Sarabun'),
                onChanged: (value) => setState(() {
                  final newText = descInput.value.text.trimLeft();
                  if (value != newText) {
                    descInput.value = descInput.value.copyWith(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }
                }),
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  //add prefix icon
                  prefixIcon: Icon(
                    Icons.description,
                    color: Colors.black,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.grey,

                  hintText: "รายละเอียด",

                  //make hint text
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "Sarabun",
                  ),
                  //create lable
                  labelText: "รายละเอียด",
                  //lable style
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontFamily: "Sarabun",
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
                child: Center(
                    child: TextFormField(
                  controller: dateInput, //editing controller of this TextField
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "วันที่",

                    //make hint text
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: "Sarabun",
                    ),
                    //create lable
                    labelText: "วันที่",
                    //lable style
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: "Sarabun",
                    ),
                  ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            2000), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      //you can implement different kind of Date Format here according to your requirement
                      setState(() {
                        dateInput.text = formattedDate;
                        //set output date to TextField value.
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                ))),
            Container(
                margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
                child: Center(
                    child: TextFormField(
                  controller: timeInput, //editing controller of this TextField
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //add prefix icon
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: Colors.black,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "เวลา",

                    //make hint text
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: "Sarabun",
                    ),
                    //create lable
                    labelText: 'เวลา',
                    //lable style
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: "Sarabun",
                    ),
                  ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: showTimePickerDialog,
                ))),
            Container(
              margin: EdgeInsets.fromLTRB(15, 20, 15, 15),
              child: ElevatedButton(
                onPressed: _saveTodo,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(
                    'บันทึก',
                    style: TextStyle(fontFamily: 'Sarabun', fontSize: 16),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 28, 27, 27)),
              ),
            )
          ],
        ),
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
              break;
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
