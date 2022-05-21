import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/views/start_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mafia',
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}