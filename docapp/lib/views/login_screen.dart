import 'dart:io';

import 'package:flutter/material.dart';
import 'package:docapp/models/doctor_model.dart';
import 'package:docapp/services/user_services.dart';
import 'package:docapp/views/register_screen.dart';
import 'package:get/get.dart';
import 'package:postgres/postgres.dart';
import 'main_screen.dart';
import 'package:docapp/services/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void clearForm() {
    _emailController.clear();
    _passwordController.clear();
  }

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
    });
    
    var doctorExists = await UserServices.doctorExists(DoctorModel(
      doctorID: -1,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      firstName: '',
      lastName: '',
      phoneNumber: '',
      confirmed: false,
    ));

    if (doctorExists) {
      globals.isLoggedIn = true;
    }

    if (_formKey.currentState!.validate()) {
      Get.to(() => const MainScreen());
    }
    else {
      globals.isLoggedIn = false;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double r = (280 / 360);
    final coverHeight = screenWidth * r;
    bool _pinned = false;
    bool _snap = false;
    bool _floating = false;

    final widgetList = [
      Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          children: const [
            SizedBox(
              width: 28,
            ),
            Text(
              'Είσοδος Χρήστη',
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 15.0,
      ),
      Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF1461D4),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.mail),
                  suffixIcon: _emailController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _emailController.clear(),
                        ),
                ),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim() == "") {
                    return 'Το πεδίο Email δε μπορεί να είναι κενό.';
                  }

                  return null;
                }
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Κωδικός',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF1461D4),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock,
                  ),
                  suffixIcon: _passwordController.text.isEmpty
                      ? Container(width: 0)
                      : IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _passwordController.clear(),
                        ),
                ),
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const [AutofillHints.email],
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim() == "") {
                    return 'Το πεδίο Κωδικός δε μπορεί να είναι κενό.';
                  }

                  if (!globals.isLoggedIn) {
                    return 'Ο λογαριασμός δεν υπάρχει.'; 
                  }

                  if (!globals.doctor.confirmed) {
                    return 'Ο λογαριασμός σας δεν έχει επιβεβαιωθεί.'; 
                  }

                  return null;
                }
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
      Container(
        padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
        child: ElevatedButton(
          onPressed: () {
            loginUser();
          },
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.only(
                    top: 6,
                    bottom: 6,
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.only(
                    right: 12,
                    top: 6,
                    bottom: 6,
                  ),
                  child: Text("Συνδεθείτε"),
                ),
        ),
      ),
      const SizedBox(
        height: 20.0,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Κουντουράς Project"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: _pinned,
                snap: _snap,
                floating: _floating,
                expandedHeight: coverHeight, //304,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  background: Image.asset(
                    "assets/images/login_image.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return widgetList[index];
                  },
                  childCount: widgetList.length,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 240, 237, 237),
            height: 50.0,
            child: Center(
              child: Wrap(
                children: [
                  Text(
                    "Δεν έχετε λογαριασμό;",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        Get.to(() => const RegisterScreen());
                      },
                      child: const Text(
                        "Εγγραφή",
                        style: TextStyle(
                          color: Color(0xFF1461D4),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
