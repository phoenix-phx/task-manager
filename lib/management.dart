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
  String _error;

  _ManageTaskState(this.index);

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleCtrl = TextEditingController();
    TextEditingController _descriptionCtrl = TextEditingController();

    if (index != -1){
        _titleCtrl.text = Provider.of<TaskServer>(context).getTaskAt(index).title;
        _descriptionCtrl.text = Provider.of<TaskServer>(context).getTaskAt(index).description;
    }

    var _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text((index == -1) ? "Create Task" : "Edit Task"),
      ),
      body: Padding(
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
                    child: Text((index == -1) ? "Create!" : "Edit!"),
                    onPressed: () {
                      setState(() {
                        if(_titleCtrl.text.length == 0){
                          _error = "Title can't be empty!";
                          return;
                        }
                        else{
                          _error = null;
                        }

                        Task currentTask = Task(_titleCtrl.text, (_descriptionCtrl.text.isEmpty) ? "" : _descriptionCtrl.text, (_descriptionCtrl.text.isEmpty) ? "" : _descriptionCtrl.text, true);
                        if(index == -1) {
                          Provider.of<TaskServer>(context, listen: false).addTask(currentTask);
                        }
                        else{
                          Provider.of<TaskServer>(context, listen: false).editTitleAt(_titleCtrl.text, index);
                          Provider.of<TaskServer>(context, listen: false).editDescriptionAt((_descriptionCtrl.text.isEmpty) ? "" : _descriptionCtrl.text, index);
                        }
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
      ),
    );
  }
}
