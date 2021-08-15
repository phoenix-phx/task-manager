import 'package:flutter/material.dart';

class Task{
  String _title;
  String _description;
  String _originalDescription;
  bool _state;

  Task(this._title, this._description, this._originalDescription, this._state);

  bool get state => _state;

  set state(bool value) {
    _state = value;
  }

  String get originalDescription => _originalDescription;

  set originalDescription(String value) {
    _originalDescription = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}