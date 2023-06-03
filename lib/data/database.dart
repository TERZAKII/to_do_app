import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  //reference the box
  final myBox = Hive.box('mybox');
  //list of to do Tasks
  List to_do_list = [];

  //run this method when if it is first time
  void createInitialData() {
    to_do_list = [
      ["Do Exercise", false],
      ["Watch Video", false],
    ];
  }

  //load the data from database
  void loadData(){
    to_do_list = myBox.get("ToDoList");
  }

  //update the database
  void updateDatabase() {
    myBox.put("ToDoList", to_do_list);
  }

}