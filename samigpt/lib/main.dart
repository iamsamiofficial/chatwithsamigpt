import 'package:flutter/material.dart';
import 'package:samigpt/chatscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:"SamiGPT",
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        
      ),
      home: ChatScreen(),
    );
  }
}