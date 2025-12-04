import 'package:flutter/material.dart';

import 'screens/indexed_stack_screen.dart';

void main() {
  runApp(const CatinderApp());
}

class CatinderApp extends StatelessWidget {
  const CatinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: IndexedStackScreen(),
    );
  }
}