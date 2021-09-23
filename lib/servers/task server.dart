import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tasks/home.dart';
import 'package:tasks/login-signup.dart';
import 'package:tasks/servers/Task.dart';
import 'package:http/http.dart' as http;
import 'package:tasks/servers/User.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TaskServer extends ChangeNotifier{
  final String _rootUrl = 'http://10.0.2.2:3000/';
  final String _url = 'http://10.0.2.2:3000/tasks';
  Future<List<Task>> _task;
  final _storage = new FlutterSecureStorage();

  // Manage tasks
  Future<List<Task>> getTasks(BuildContext context) async{
    List<Task> tasks = [];
    String token = await _storage.read(key: 'token');
    final response = await http.get(_url,
        headers: <String, String>{
          'Authorization': token
        });

    print('Codigo:' + response.statusCode.toString());
    if(response.statusCode == 403){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    else {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print('All tasks list:' + response.body);
      print(jsonData[0]['title']);
      for (var item in jsonData) {
        tasks.add(Task(
            item['id'], item['title'], item['detail'], item['detail'],
            (item['status'] == 'pending') ? true : false));
      }
    }
    return tasks;
  }

  Future<Task> getTaskAt(int id) async {
    final response = await http.get(_url + '/$id');
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    print('Task $id:' + response.body);
    print(jsonData['title']);
    return Task(jsonData['id'], jsonData['title'], jsonData['detail'], jsonData['detail'], (jsonData['status'] == 'pending' ? true : false));
  }

  void addTask(Task task) async {
    final response = await http.post(_url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "title": task.title,
          "detail": task.description
        }));
    print('Add task response: ' + response.body);
    notifyListeners();
  }

  void editTask(Task task) async {
    final response = await http.put(_url + '/${task.id}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "title": task.title,
          "detail": task.description
        }));
    print('Edit task response: ' + response.body);
    notifyListeners();
  }

  void editStatus(int id, bool state) async {
    String status = (state) ? 'pending' : 'completed';
    final response = await http.put(_url + '/$id?state=' + status);
    print('Edit task status response: ' + response.body);
    notifyListeners();
  }

  void deleteTask(int id) async {
    final response = await http.delete(_url + '/$id');
    print('Delete task response: ' + response.body);
    notifyListeners();
  }

  // Manage users
  dynamic getStorage(){
    return this._storage;
  }

  Future<bool> login(User user, BuildContext context) async {
    final response = await http.post(_rootUrl + 'auth',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": user.username,
          "password": user.pass
        }));
    print('Login response: ' + response.headers.toString());

    if(response.statusCode == 401){
      return false;
    }
    else {
      // Save in secure storage
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData['token']);
      await _storage.write(key: 'token', value: jsonData['token']);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
      return true;
    }

    /*
    // ABM
    // Read value
    String value = await storage.read(key: 'token');

    // Read all values
    Map<String, String> allValues = await storage.readAll();

    // Delete value
    await storage.delete(key: key);

    // Delete all
    await storage.deleteAll();
     */
  }

}