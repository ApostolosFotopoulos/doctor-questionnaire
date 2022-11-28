import 'package:flutter/material.dart';
import 'package:docapp/models/answers_model.dart';
import 'package:docapp/services/globals.dart' as globals;
import 'package:docapp/views/chosen_latest_answer_summary_screen.dart';
import 'package:docapp/views/patient_amka_screen.dart';
import 'package:get/get.dart';

import '../services/user_services.dart';
import 'login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Future<List<AnswersModel>> futureAnswers = UserServices.fetchRecentAnswers();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.doctor.firstName + "  " + globals.doctor.lastName),
        centerTitle: true,
        leading: InkWell(
          onTap: () => {
            ScaffoldMessenger.of(context).clearSnackBars(),
            globals.isLoggedIn = false,
            Get.to(() => const LoginScreen()),
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (dragDetails) {},
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: FutureBuilder(
              future: futureAnswers,
              builder: (context, snapshot) {
                // operation for completed state
                if (snapshot.hasData) {
                  List<AnswersModel> answers = snapshot.data as List<AnswersModel>;
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0,right: 15.0,left: 15.0,bottom: 15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          ...[
                            (() {
                              return Column(
                                children: [
                                  for (int i = 0; i < answers.length; i++)
                                  InkWell(
                                    child: Container(
                                      width: screenWidth-10,
                                      margin: const EdgeInsets.only(top: 10.0),
                                      decoration: BoxDecoration(  
                                        color: Colors.green,
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 59, 49, 49),
                                          width: 2.0,
                                        )
                                      ),
                                      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          answers[i].patientFirstName + " " + answers[i].patientLastName + " " + answers[i].submitDate.toString(),
                                          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.25),
                                        )
                                      ),
                                    ),
                                    onTap: () {            
                                      globals.answersLists = answers;
                                      globals.questionaireID = answers[i].questionnaireID.toString();
                                      globals.chosenAnswersList = i;            
                                      print(globals.chosenAnswersList);
                                      Get.to(() => const ChosenLatestAnswerSummaryScreen());
                                    }
                                  )
                                ],
                              );
                            }())
                          ],
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton( 
                                child: const Icon(Icons.add),
                                onPressed: () {
                                  globals.questionaireID = "1";
                                  Get.to(() => const PatientAmkaScreen());
                                },
                              )
                            )
                          )
                        ],
                      ),
                    )
                  );
                 }
                return Container();
              }
            )
          )
        )
      )
    );
  }
}
