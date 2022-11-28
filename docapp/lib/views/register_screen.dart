import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:docapp/models/doctor_model.dart';
import 'package:docapp/services/user_services.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool isLoading = false;

  void clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneNumberController.clear();
  }

  Future<void> registerUser() async {
    setState(() {
      isLoading = true;
    });

    await UserServices.register(DoctorModel(
      doctorID: -1,
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      confirmed: true,
    ));

    // Clear the form if the user has successfully created
    clearForm();

    // Inform the user about the result
    var snackBar = const SnackBar(
      content: Text("Ο λογαριασμός σας δημιουργήθηκε."),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Get.to(() => const LoginScreen());
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text(
          "Εγγραφή Γιατρού",
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 30,
          ),
        ),
        //centerTitle: true,
        leading: InkWell(
          onTap: () => {
            ScaffoldMessenger.of(context).clearSnackBars(),
            Get.to(() => const LoginScreen()),
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          color: Colors.white,
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: 'Όνομα',
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
                          Icons.person,
                        ),
                        suffixIcon: _firstNameController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _firstNameController.clear(),
                              ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim() == "") {
                          return 'Το πεδίο Όνομα δε μπορεί να είναι κενό.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Επώνυμο',
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
                          Icons.person,
                        ),
                        suffixIcon: _lastNameController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _lastNameController.clear(),
                              ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim() == "") {
                          return 'Το πεδίο Επώνυμο δε μπορεί να είναι κενό.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
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
                        prefixIcon: const Icon(
                          Icons.email,
                        ),
                        suffixIcon: _emailController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _emailController.clear(),
                              ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim() == "") {
                          return 'Το πεδίο Email δε μπορεί να είναι κενό.';
                        }
                        
                        if (!EmailValidator.validate(value.trim())) {
                          return 'Η διεύθυνση Email δεν είναι έγκυρη.';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
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
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        //print(value);
                        if (value == null || value.isEmpty || value.trim() == "") {
                          return 'Το πεδίο Κωδικός δε μπορεί να είναι κενό.';
                        }
                        
                        if (value.trim().length < 8) {
                          return 'Ο κωδικός πρέπει να περιέχει τουλάχιστον 8\nχαρακτήρες.';
                        }

                        RegExp charRegex = RegExp(r'[a-zA-Z]');
                        RegExp numRegex = RegExp(r'[0-9]');
                        if (!(charRegex.hasMatch(value.trim()) && numRegex.hasMatch(value.trim()))) {
                          return 'Ο Κωδικός πρέπει να περιέχει τουλάχιστον ένα \nγράμμα και έναν αριθμό.';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextFormField(
                      controller: _confirmpasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Επιβεβαίωση Κωδικού',
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
                        suffixIcon: _confirmpasswordController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _confirmpasswordController.clear(),
                              ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim() == "") {
                          return 'Το πεδίο Κωδικός δε μπορεί να είναι κενό.';
                        }

                        if (value != _passwordController.text) {
                          return 'Οι κωδικοί δε συμπίπτουν.';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        hintText: 'Τηλέφωνο',
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
                          Icons.phone,
                        ),
                        suffixIcon: _phoneNumberController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _phoneNumberController.clear(),
                              ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim() == "") {
                          return 'Το πεδίο Τηλέφωνο δε μπορεί να είναι κενό.';
                        }

                        RegExp regex = RegExp(r'^[0-9]+$');
                        if (!regex.hasMatch(value) || value.trim().length != 10) {
                          return 'Ο αριθμός τηλεφώνου δεν είναι έγκυρος.';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          registerUser();
                        }
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
                              child: Text("Δημιουργία Λογαριασμού"),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
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
