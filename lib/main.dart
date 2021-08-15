import 'package:flutter/material.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'servers/task server.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: TaskServer()), ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tasks Manager',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: HomePage(),
      ),
    );
  }
}
