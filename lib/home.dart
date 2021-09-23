import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks/management.dart';
import 'package:tasks/servers/Task.dart';
import 'package:tasks/servers/User.dart';
import 'servers/task server.dart';
import 'credits.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int position = 0;
  Future<List<Task>> tasks;
  bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    // Init Data
    tasks = Provider.of<TaskServer>(context, listen: true).getTasks(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks Manager"),
        actions: [
          PopupMenuButton(
            itemBuilder: (ctx) => [
              PopupMenuItem(child: Text("User: " + Provider.of<TaskServer>(context, listen: false).getUsername()), value: '0',),
              PopupMenuItem(child: Text('Refresh'), value: '1',),
              PopupMenuItem(child: Text('Credits'), value: '2',),
            ],
            onSelected: (value){
              setState(() {
                switch(value){
                  case '0':
                    // tasks = Provider.of<TaskServer>(context, listen: false).getTasks(context);

                    break;
                  case '1':
                    tasks = Provider.of<TaskServer>(context, listen: false).getTasks(context);
                    break;
                  case '2':
                    Route route = MaterialPageRoute(builder: (context) => Credits());
                    Navigator.of(context).push(route);
                    break;
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: tasks,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 1,
                  children: _taskList(snapshot.data),
                  childAspectRatio: (3),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Route route = MaterialPageRoute(builder: (context) => ManageTask(-1));
          Navigator.push(context, route);
        },
        tooltip: 'Add a new task',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget popup(int id){
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(child: Text("Check"), value: 0,),
        PopupMenuItem(child: Text("Edit"), value: 1,),
        PopupMenuItem(child: Text("Delete"), value: 2,),
      ],
      onSelected: (value){
        position = id;
        setState(() {
          switch(value){
            case 0:
              print("Check $id");
              Provider.of<TaskServer>(context, listen: false).editStatus(id, false, context);
              break;
            case 1:
              print("Edit $id");
              Route route = MaterialPageRoute(builder: (context) => ManageTask(id));
              Navigator.push(context, route);
              break;
            case 2:
              print("Delete $id");
              Provider.of<TaskServer>(context, listen: false).deleteTask(id, context);
              break;
          }
        });
      },
    );
  }

  Widget reset(int id){
    return IconButton(
        icon: Icon(Icons.autorenew),
        onPressed: (){
          Provider.of<TaskServer>(context, listen: false).editStatus(id, true, context);
        }
    );
  }

  /*
  Widget listview(List<Task> tasks, int index, int length, bool isEmpty){
    return (isEmpty) ?
    Center(
      child: Text("Go create some tasks!", style: TextStyle(fontSize: 15),),
    )
        : ListView.separated(
        itemBuilder: (BuildContext context, int index){
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Card(
          elevation: 10,
          child: ListTile(
            title: Text(tasks[index].title, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ),),
            subtitle: Text(tasks[index].description, style: TextStyle(fontSize: 16,),),
            trailing: (tasks[index].state) ? popup(index) : reset(index),
            enabled: tasks[index].state,
            contentPadding: EdgeInsets.all(18),
          ),
        ),
      );
    },
    separatorBuilder: (BuildContext context, int index) => SizedBox(height: 0,),
    itemCount: tasks.length,
  }

   */

  List<Widget> _taskList(List<Task> data){
    List<Widget> taskWidgets = [];
    for(var taskItem in data){
      taskWidgets.add(
        Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
            child: Card(
              elevation: 10,
              child: ListTile(
                title: Text(taskItem.title, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ), overflow: TextOverflow.ellipsis, maxLines: 1),
                subtitle: Text(taskItem.description, style: TextStyle(fontSize: 16,), overflow: TextOverflow.ellipsis, maxLines: 3,),
                trailing: (taskItem.state) ? popup(taskItem.id) : reset(taskItem.id),
                enabled: taskItem.state,
                contentPadding: EdgeInsets.all(18),
              ),
            ),
        )
      );
    }
    return taskWidgets;
  }
}
