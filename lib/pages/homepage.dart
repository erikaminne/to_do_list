import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_list/util/dialog_box.dart';

import '../util/todo_tile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = TextEditingController();
  List toDoList = [];

  @override
  void initState() {
    super.initState();
    initHive();
  }

  void initHive() async {
    await Hive.initFlutter();
    await Hive.openBox('taskBox');
    setState(() {
      loadTasks();
    });
  }

  void loadTasks() {
    final taskBox = Hive.box('taskBox');
    for (var i = 0; i < taskBox.length; i++) {
      final task = taskBox.getAt(i);
      toDoList.add([task[0], task[1]]);
    }
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      toDoList[index][1] = !toDoList[index][1];
      Hive.box('taskBox')
          .putAt(index, [toDoList[index][0], toDoList[index][1]]);
    });
  }

  void saveTask(String title, bool isCompleted) {
    Hive.box('taskBox').add([title, isCompleted]);
  }

  void saveNewTask() {
    setState(() {
      toDoList.add([_controller.text, false]);
      saveTask(_controller.text, false);
    });
    _controller.clear();
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          // onCancel: () => Navigator.of(context).pop(),
          onCancel: () {
            Navigator.of(context).pop();
            _controller.clear();
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      Hive.box('taskBox').deleteAt(index);
      toDoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To-Do-List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: toDoList[index][0],
            taskCompleted: toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
