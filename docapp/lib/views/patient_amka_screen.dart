import 'package:flutter/material.dart';
import 'package:docapp/services/globals.dart' as globals;
import 'package:docapp/services/user_services.dart';
import 'package:docapp/views/questionnaire_screen.dart';
import 'package:docapp/views/register_patient_screen.dart';
import 'package:get/get.dart';
import 'package:docapp/models/patient_model.dart';
import 'main_screen.dart';

class PatientAmkaScreen extends StatefulWidget {
  const PatientAmkaScreen({Key? key}) : super(key: key);

  @override
  State<PatientAmkaScreen> createState() => _PatientAmkaScreen();
}

class _PatientAmkaScreen extends State<PatientAmkaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amkaController = TextEditingController(text: globals.patient.amka);
  bool isLoading = false;

  void clearForm() {
    _amkaController.clear();
  }

  Future<void> checkAmka() async {
    setState(() {
      isLoading = true;
    });

    globals.patient.amka = _amkaController.text;
    var patientExists = await UserServices.patientExists(PatientModel(
      patientID: -1,
      amka: _amkaController.text,
      doctorID: globals.doctor.doctorID,
      email: '',
      firstName: '',
      lastName: '',
      phoneNumber: '',
    ));

    if (patientExists) {
      clearForm();
      Get.to(() => const QuestionnaireScreen());
    } else {
      addNewPatientConfirm(context);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Επιλογή Ασθενή",
          style: TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 30,
          ),
        ),
        leading: InkWell(
          onTap: () => {
            ScaffoldMessenger.of(context).clearSnackBars(),
            Get.to(() => const MainScreen()),
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: TextFormField(
                      controller: _amkaController,
                      decoration: InputDecoration(
                        hintText: 'ΑΜΚΑ Ασθενή',
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
                        suffixIcon: _amkaController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => _amkaController.clear(),
                            ),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty || value.trim() == "") {
                          return 'Το πεδίο AMKA δε μπορεί να είναι κενό.';
                        }

                        RegExp regex = RegExp(r'^[0-9]+$');
                        if (!regex.hasMatch(value) || value.trim().length != 11) {
                          return 'Ο αριθμός AMKA δεν είναι έγκυρος.';
                        }

                        return null;
                      }
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
                          checkAmka();
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
                              child: Text("Επιβεβαίωση Στοχείων"),
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

  void addNewPatientConfirm(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("Ακύρωση"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Συνέχεια"),
      onPressed: () {
        Get.to(() => const RegisterPatientScreen());
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Νέος Ασθενής"),
      content: Text("Ο ασθενής με ΑΜΚΑ: " +
          globals.patient.amka +
          " δεν έχει καταχωρηθεί. Θέλετε να εισάγετε τα στοιχεία του;"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
