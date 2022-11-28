import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:docapp/views/login_screen.dart';

import 'main_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Αποτέλεσματα",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.to(() => const MainScreen());
            },
          )
        ],
      ),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (dragDetails) {},
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 30, left: 15, right: 15),
                    child: const Center(
                      child: Text(
                        'Τα ερωτήματα σας αποστάλθηκαν',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 30, bottom: 30, left: 15, right: 15),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                        size: 200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
