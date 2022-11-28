import 'package:flutter/material.dart';
import 'package:docapp/views/confirmation_screen.dart';
import 'package:get/get.dart';
import 'package:docapp/services/globals.dart' as globals;

import '../models/question_model.dart';
import '../services/user_services.dart';
import 'questionnaire_screen.dart';

class AnswerSummaryScreen extends StatefulWidget {
  const AnswerSummaryScreen({Key? key}) : super(key: key);

  @override
  State<AnswerSummaryScreen> createState() => _AnswerSummaryScreen();
}

class _AnswerSummaryScreen extends State<AnswerSummaryScreen> {
  bool isLoading = false;

  Future<void> submitAnswers() async {
    setState(() {
        isLoading = true;
    });

    await UserServices.submitAnswers();
    globals.questions = [];
    Get.to(() => const ConfirmationScreen());
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
          title: const Text("Σύνοψη Απαντήσεων"),
          centerTitle: true,
          leading: InkWell(
            onTap: () => {
              ScaffoldMessenger.of(context).clearSnackBars(),
              Get.to(() => const QuestionnaireScreen())
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
              child: Column(
                children: [
                  ...[
                    (() {
                      List<QuestionModel> answeredQuestions= [];
                      for (int i = 0; i < globals.questions.length; i++) {
                        //print(globals.questions[i].rank);
                        //print(globals.questions[i].gotAnswered);
                        if (globals.questions[i].gotAnswered) {
                          answeredQuestions.add(globals.questions[i]); 
                          if (globals.questions[i].textfieldAnswer != "") {
                            answeredQuestions[i].radioButtonAnswer = globals.questions[i].textfieldAnswer;
                          } 
                        }
                      }
                      
                      return Column(
                        children: [
                          for (int i = 0; i < answeredQuestions.length; i++)
                          Container(
                            width: screenWidth-10,
                            margin: const EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(  
                              color: answeredQuestions[i].isAnExtraQuestion? const Color.fromARGB(255, 219, 228, 233): const Color.fromARGB(255, 255, 255, 255),
                              border: Border.all(
                                color: const Color.fromARGB(255, 59, 49, 49),
                                width: 2.0,
                              )
                            ),
                            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                            child: RichText(
                              text: TextSpan(
                                text:answeredQuestions[i].rank + ") " + answeredQuestions[i].questionDesc + "\n     Απάντηση: ",
                                style: const TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(text: answeredQuestions[i].radioButtonAnswer, style: const TextStyle(color: Colors.blue)),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }())
                  ],
                  Container(
                    padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        submitAnswers();
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
                              child: Text("Επιβεβαίωση Απαντήσεων"),
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
        ));
  }
}
