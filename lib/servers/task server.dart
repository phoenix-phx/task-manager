import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasks/servers/Task.dart';
import 'package:http/http.dart' as http;

class TaskServer extends ChangeNotifier{
  int _currentPosition = 0;
  List<String> _title = ['Sample Task'];
  List<String> _description = ['The tasks will be displayed like this one. Start being productive!'];
  List<String> _originalDescription = ['The tasks will be displayed like this one. Start being productive!'];
  List<bool> _finished = [true];

  List<Task> _task = [Task('Sample Task', 'The tasks will be displayed like this one. Start being productive!', 'The tasks will be displayed like this one. Start being productive!', true), ];

  // Manage current index
  int getCurrentPosition(){
    return _currentPosition;
  }

  void setCurrentPosition(int position){
    this._currentPosition = position;
    notifyListeners();
  }

  // Manage tasks
  Future<List<Task>> apiGetTasks() async{
    List<Task> tasks = [];
    final response = await http.get('http://10.0.2.2:3000/tasks');
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    print(response.body);
    print(jsonData[0]['title']);
    for(var item in jsonData){
      tasks.add(Task(item['title'], item['detail'], item['detail'], (item['status'] == 'pending') ? true : false));
    }
    _task = tasks;
  }

  List<Task> getTasks(){
    return _task;
  }

  Task getTaskAt(int i){
    return _task[i];
  }

  void addTask(Task task){
    this._task.add(task);
    notifyListeners();
  }

  void editTitleAt(String newTitle, int index){
    this._task[index].title = newTitle;
    notifyListeners();
  }

  void editDescriptionAt(String newDescription, int index){
    this._task[index].description = newDescription;
    this._task[index].originalDescription = newDescription;
    notifyListeners();
  }

  void editStateAt(int index, bool state){
    this._task[index].state = state;
    notifyListeners();
  }

  void deleteTaskAt(int index){
    print("estoy elimininando $index");
    this._task.removeAt(index);
    notifyListeners();
  }
}