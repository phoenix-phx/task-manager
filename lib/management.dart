import 'package:flutter/material.dart';
import 'package:tasks/servers/Task.dart';
import 'package:provider/provider.dart';
import 'package:tasks/servers/task%20server.dart';

class ManageTask extends StatefulWidget {
  ManageTask(this.index);

  int index = -1;

  @override
  _ManageTaskState createState() => _ManageTaskState(index);
}

class _ManageTaskState extends State<ManageTask> {
  int index = -1;
  Future<Task> currentTask;
  String _error;

  _ManageTaskState(this.index);

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleCtrl = TextEditingController();
    TextEditingController _descriptionCtrl = TextEditingController();

    if (index != -1){
        currentTask = Provider.of<TaskServer>(context).getTaskAt(index, context);
    }

    var _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text((index == -1) ? "Create Task" : "Edit Task"),
      ),
      body: (index == -1) ?
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    labelText: "Title",
                    errorText: _error,
                    labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ),
                  ),
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ),
                  maxLines: 1,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descriptionCtrl,
                decoration: InputDecoration(
                  hintText: "Description (optional)",
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(fontSize: 21, ),
                ),
                style: TextStyle(fontSize: 16,),
                maxLines: 18,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  ElevatedButton(
                    child: Text("Create!"),
                    onPressed: () {
                      setState(() {
                        if(_titleCtrl.text.length == 0){
                          _error = "Title can't be empty!";
                          return;
                        }
                        else{
                          _error = null;
                        }
                        Task currentTask = Task(-1, _titleCtrl.text, (_descriptionCtrl.text.isEmpty) ? "" : _descriptionCtrl.text, (_descriptionCtrl.text.isEmpty) ? "" : _descriptionCtrl.text, true);
                        Provider.of<TaskServer>(context, listen: false).addTask(currentTask, context);
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ]
              )
            ],
          ),
        ),
      )
      : FutureBuilder(
          future: currentTask,
          builder: (context, snapshot){
            if(snapshot.hasData){
              Task data = snapshot.data;
              _titleCtrl.text = data.title;
              _descriptionCtrl.text = data.description;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: TextField(
                          controller: _titleCtrl,
                          decoration: InputDecoration(
                            labelText: "Title",
                            errorText: _error,
                            labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ),

                          ),
                          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _descriptionCtrl,
                        decoration: InputDecoration(
                          hintText: "Description (optional)",
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(fontSize: 21, ),
                        ),
                        style: TextStyle(fontSize: 16,),
                        maxLines: 18,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[
                            ElevatedButton(
                              child: Text("Edit!"),
                              onPressed: () {
                                setState(() {
                                  if(_titleCtrl.text.length == 0){
                                    _error = "Title can't be empty!";
                                    return;
                                  }
                                  else{
                                    _error = null;
                                  }

                                  Task currentTask = Task(index, _titleCtrl.text, (_descriptionCtrl.text.isEmpty) ? "" : _descriptionCtrl.text, (_descriptionCtrl.text.isEmpty) ? "" : _descriptionCtrl.text, true);
                                  Provider.of<TaskServer>(context, listen: false).editTask(currentTask, context);
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ]
                      )
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator()
            );
          }
      )
    );
  }
}
