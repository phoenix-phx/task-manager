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
  String _username;

  String getUsername(){
    return this._username;
  }

  // Manage tasks
  Future<List<Task>> getTasks(BuildContext context) async{
    print("Getting tasks from server...");
    List<Task> tasks = [];
    String token = await _storage.read(key: 'token');
    final response = await http.get(_url,
        headers: <String, String>{
          'Authorization': token
        });

    print('Codigo:' + response.statusCode.toString());
    if(response.statusCode != 200){
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
            item['task_id'], item['title'], item['detail'], item['detail'],
            (item['task_status'] == 'pending') ? true : false));
      }
    }
    return tasks;
  }

  Future<Task> getTaskAt(int id, BuildContext context) async {
    String token = await _storage.read(key: 'token');
    final response = await http.get(_url + '/$id',
        headers: <String, String>{
          'Authorization': token
        });

    print('Response Code:' + response.statusCode.toString());
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    else {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print('Task $id:' + response.body);
      print(jsonData[0]['title']);
      return Task(jsonData[0]['task_id'], jsonData[0]['title'], jsonData[0]['detail'],
          jsonData[0]['detail'], (jsonData[0]['task_status'] == 'pending' ? true : false));
    }
  }

  void addTask(Task task, BuildContext context) async {
    String token = await _storage.read(key: 'token');
    final response = await http.post(_url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "title": task.title,
          "detail": task.description
        }));
    print('Add task response: ' + response.body);
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    notifyListeners();
  }

  void editTask(Task task, BuildContext context) async {
    String token = await _storage.read(key: 'token');
    final response = await http.put(_url + '/${task.id}',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, String>{
          "title": task.title,
          "detail": task.description
        }));
    print('Edit task response: ' + response.body);
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    notifyListeners();
  }

  void editStatus(int id, bool state, BuildContext context) async {
    String status = (state) ? 'pending' : 'completed';
    String token = await _storage.read(key: 'token');
    final response = await http.put(_url + '/$id?state=' + status,
        headers: <String, String>{
          'Authorization': token
        });
    print('Edit task status response: ' + response.body);
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
    notifyListeners();
  }

  void deleteTask(int id, BuildContext context) async {
    String token = await _storage.read(key: 'token');
    final response = await http.delete(_url + '/$id',
        headers: <String, String>{
          'Authorization': token
        });
    print('Delete task response: ' + response.body);
    if(response.statusCode != 200){
      await _storage.delete(key: 'token');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (route) => false);
    }
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
      this._username = jsonData['name'];
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

  Future<bool> signup(User user, BuildContext context) async {
    final response = await http.post(_rootUrl + 'user',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": user.username,
          "password": user.pass
        }));
    print('Login response: ' + response.headers.toString());

    if(response.statusCode != 200){
      return false;
    }
    else {
      // Save in secure storage
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      print(jsonData['token']);
      await _storage.write(key: 'token', value: jsonData['token']);
      this._username = jsonData['username'];
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (route) => false);
      return true;
    }
  }
}