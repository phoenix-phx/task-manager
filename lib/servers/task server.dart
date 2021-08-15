import 'package:flutter/material.dart';
import 'package:tasks/servers/Task.dart';

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