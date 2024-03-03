import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        leading: Icon(Icons.person),

        title: Text('Welcome to Flutter'),

        centerTitle: true,

        actions:
        [
          Text('Hello'),
        ],

      ),
      body: Image(
        image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZrzDoUcc2w8PSG04L5LvwR06bJikpOus_Ug&usqp=CAU'),
      ),
    );
  }

}

