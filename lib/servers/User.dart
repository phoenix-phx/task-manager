import 'package:flutter/material.dart';

class User{
  int _id;
  String _username;
  String _pass;

  User(this._id, this._username, this._pass);

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get pass => _pass;

  set pass(String value) {
    _pass = value;
  }
}