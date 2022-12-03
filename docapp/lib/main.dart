import 'dart:io';

import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:get/get.dart';
import 'package:docapp/views/login_screen.dart';
import 'package:docapp/services/globals.dart' as globals;

Future<void> main() async {

  //Login info
  
  var conn =
      PostgreSQLConnection(host, port, db, username: user, password: password);
  try {
    await conn.open();
    print("connected");
    globals.conn = conn;
  } catch (e) {
    print(e.toString());
    exit(0);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Survey App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1461D4),
      ),
      home: const LoginScreen(),
    );
  }
}
