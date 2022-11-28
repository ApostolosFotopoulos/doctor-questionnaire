import 'dart:io';

import 'package:flutter/material.dart';
import 'package:docapp/views/confirmation_screen.dart';
import 'package:docapp/views/main_screen.dart';
import 'package:get/get.dart';
import 'package:docapp/services/globals.dart' as globals;

import '../models/question_model.dart';
import '../services/user_services.dart';
import 'questionnaire_screen.dart';

class ChosenLatestAnswerSummaryScreen extends StatefulWidget {
  const ChosenLatestAnswerSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ChosenLatestAnswerSummaryScreen> createState() => _ChosenLatestAnswerSummaryScreen();
}

class _ChosenLatestAnswerSummaryScreen extends State<ChosenLatestAnswerSummaryScreen> {
  late final Future<List<QuestionModel>> futureQuestions = UserServices.fetchQuestions(globals.questionaireID);

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
              Get.to(() => const MainScreen())
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
            child: FutureBuilder(
              future: futureQuestions,
              builder: (context, snapshot) {
                // operation for completed state
                if (snapshot.hasData) {
                  List<QuestionModel> questions = snapshot.data as List<QuestionModel>;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ...[
                          (() {
                            List<QuestionModel> answeredQuestions= [];
                            List<String> answers = globals.answersLists[globals.chosenAnswersList].answersList.split(",");
                            if (answers.length == questions.length) {
                              for (int i = 0; i < questions.length; i++) {
                                if (answers[i] != "-") {
                                  answeredQuestions.add(questions[i]); 
                                }
                              }
                            }
                            else {
                              print("Questions Length: " + questions.length.toString());
                              print("Answers Length: " + answers.length.toString());
                              exit(0);
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
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              }
            )
          ),
        ));
  }
}