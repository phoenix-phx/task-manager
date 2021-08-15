import 'package:flutter/material.dart';

class TaskServer extends ChangeNotifier{
  int _currentPosition = 0;
  List<String> _title = ['Sample Task'];
  List<String> _description = ['The tasks will be displayed like this one. Start being productive!'];
  List<String> _originalDescription = ['The tasks will be displayed like this one. Start being productive!'];
  List<bool> _finished = [true];

  // Manage current index
  int getCurrentPosition(){
    return _currentPosition;
  }

  void setCurrentPosition(int position){
    this._currentPosition = position;
    notifyListeners();
  }

  // Manage task titles
  List<String> getTitles(){
    return _title;
  }

  String getTitleAt(int i){
    return _title[i];
  }

  void addTitle(String title){
    this._title.add(title);
    notifyListeners();
  }

  void editTitle(String newTitle, int index){
    this._title[index] = newTitle;
    notifyListeners();
  }

  // Manage task descriptions
  List<String> getDescriptions(){
    return _description;
  }

  String getDescriptionAt(int i){
    return _description[i];
  }

  void addDescription(String description){
    this._description.add(description);
    this._originalDescription.add(description);
    notifyListeners();
  }

  void editDescription(String newDescription, int index){
    this._description[index] = newDescription;
    this._originalDescription[index] = newDescription;
    notifyListeners();
  }

  // Manage task's original descriptions
  List<String> getOriginalDescriptions(){
    return _originalDescription;
  }

  String getOriginalDescriptionAt(int i){
    return _originalDescription[i];
  }
}