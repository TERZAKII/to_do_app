import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';
import '../utilities/dialog_box.dart';
import '../utilities/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference the box
  final myBox = Hive.box('mybox');
  ToDoDatabase database = ToDoDatabase();

  final _controller = TextEditingController();

  @override
  void initState() {
    //if it is 1time ever opening app
    if(myBox.get("ToDoList") == null) {
      database.createInitialData();
    }
    //there is already exists datas from database
    else {
      database.loadData();
    }
    super.initState();
  }


  //checking CheckBox
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      database.to_do_list[index][1] = value ?? false;
    });
    database.updateDatabase();
  }

  //save a new Task
  void saveNewTask(){
    setState(() {
      database.to_do_list.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    database.updateDatabase();
  }

  //create a new Task
  void createNewTask() {
    showDialog(context: context, builder: (context){
      return DialogBox(
        contoller: _controller,
        onSave: saveNewTask,
        onCancel: () {
          return Navigator.of(context).pop();
        },
      );
    });
    database.updateDatabase();
  }

  //delete a Task
  void deleteTask(int index) {
    setState(() {
      database.to_do_list.removeAt(index);
    });
    database.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('TO DO'),
        centerTitle: true,
        elevation: 0.25,
      ),
      body: ListView.builder(
        itemCount: database.to_do_list.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: database.to_do_list[index][0],
            taskCompleted: database.to_do_list[index][1],
            onChanged: (bool? value) {
              return checkBoxChanged(value, index);
            },
            deleteFunction: (context) {
              return deleteTask(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          return createNewTask();
        },

      ),
    );
  }
}
