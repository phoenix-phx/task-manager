import 'package:flutter/material.dart';

class Credits extends StatelessWidget {
  const Credits({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager Credits!'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Tasks Manager', style: TextStyle(color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),),),
          SizedBox(width: 0, height: 15,),
          Center(child: Text('Version: 1.0.0 (Beta)', style: TextStyle(color: Colors.black, fontSize: 15,),)),
          SizedBox(width: 0, height: 5,),
          Center(child: Text('Developed by: Alexander Sosa', style: TextStyle(color: Colors.black, fontSize: 15,),)),
        ],
      ),
    );
  }
}
