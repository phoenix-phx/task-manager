import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks/management.dart';
import 'package:tasks/servers/Task.dart';
import 'servers/task server.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int position = 0;
  List<Task> tasks = [];
  bool isEmpty = false;

  Future<List<Task>> getTasks() async {
    final response = await http.get('http://10.0.2.2:3000/tasks');
    print(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Init Data
    Provider.of<TaskServer>(context, listen: true).apiGetTasks();
    tasks = Provider.of<TaskServer>(context, listen: true).getTasks();
    if(tasks.length == 0)
      isEmpty = true;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks Manager"),
      ),
      body: (isEmpty) ?
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
          itemCount: tasks.length
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //Provider.of<TaskServer>(context, listen: false).editStateAt(0, true);
          Route route = MaterialPageRoute(builder: (context) => ManageTask(-1));
          Navigator.push(context, route);
        },
        tooltip: 'Add a new task',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget popup(int currentIndex){
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(child: Text("Check"), value: 0,),
        PopupMenuItem(child: Text("Edit"), value: 1,),
        PopupMenuItem(child: Text("Delete"), value: 2,),
      ],
      onSelected: (value){
        position = currentIndex;
        setState(() {
          switch(value){
            case 0:
              print("Check $currentIndex");
              Provider.of<TaskServer>(context, listen: false).editStateAt(position, false);
              break;
            case 1:
              print("Edit $currentIndex");
              Route route = MaterialPageRoute(builder: (context) => ManageTask(currentIndex));
              Navigator.push(context, route);
              break;
            case 2:
              print("Delete $currentIndex");
              Provider.of<TaskServer>(context, listen: false).deleteTaskAt(position);
              break;
          }
        });
      },
    );
  }

  Widget reset(int currentIndex){
    return IconButton(
        icon: Icon(Icons.autorenew),
        onPressed: (){
          Provider.of<TaskServer>(context, listen: false).editStateAt(position, true);
        }
    );
  }
}
