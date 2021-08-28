import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tasks/servers/Task.dart';
import 'package:http/http.dart' as http;

class TaskServer extends ChangeNotifier{
  final String _url = 'http://10.0.2.2:3000/tasks';
  Future<List<Task>> _task;

  // Manage tasks
  Future<List<Task>> getTasks() async{
    List<Task> tasks = [];
    final response = await http.get(_url);
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body);
    //print('All tasks list:' + response.body);
    //print(jsonData[0]['title']);
    for(var item in jsonData){
      tasks.add(Task(item['id'], item['title'], item['detail'], item['detail'], (item['status'] == 'pending') ? true : false));
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
}