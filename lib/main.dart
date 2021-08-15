import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasks Manager',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Tasks Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int position = 0;
  List<String> title = ['Sample Task'];
  List<String> description = ['The tasks will be displayed like this one. Start being productive!'];
  List<bool> finished = [true];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index){
            return Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                child: Card(
                  elevation: 10,
                  child: ListTile(
                    title: Text(title[index], style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, ),),
                    subtitle: Text(description[index], style: TextStyle(fontSize: 16,),),
                    trailing: popup(index),
                    enabled: finished[index],
                    hoverColor: Colors.lightGreen,
                    contentPadding: EdgeInsets.all(18),
                  ),
                ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 0,),
          itemCount: title.length
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
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
        position = value;
        setState(() {
          switch(value){
            case 0:
              print("Check $currentIndex");
              break;
            case 1:
              print("Edit $currentIndex");
              break;
            case 2:
              print("Delete $currentIndex");
              break;
          }
        });
      },
    );
  }

}
