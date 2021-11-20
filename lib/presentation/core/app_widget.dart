// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      home: Scaffold(
        appBar: AppBar(title: const Text('Notes'),),
        body: Center(
          child: Container(child: const Text('hello world'),),
        ),
      ),
    );
  }
}
