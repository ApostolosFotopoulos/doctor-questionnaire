import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:docapp/models/question_model.dart';
import 'package:docapp/views/confirmation_screen.dart';
import 'package:docapp/services/globals.dart' as globals;

import '../services/user_services.dart';
import 'answer_summary_screen.dart';
import 'main_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerController = TextEditingController();
  late final Future<List<QuestionModel>> futureQuestions = UserServices.fetchQuestions(globals.questionaireID);
  int questionIndex = 0;

  nextQuestion(List<QuestionModel> questions) {
    questions[questionIndex].gotAnswered = true;
    int inc = 1;
    bool answerFound = false;
    if (questions[questionIndex].hasExtraQuestion) {
      for (int i = 0; i < questions[questionIndex].extraQuestions.length; i++) {
        if (questions[questionIndex].radioButtonAnswer == questions[questionIndex].answersWithExtraQuestions[i]) {
          answerFound = true;
          inc += i;
          break;
        }
      }
      if (!answerFound) {
        inc += questions[questionIndex].extraQuestions.length;
      }
    }

    int index = questionIndex;
    if (questions[questionIndex].isAnExtraQuestion) {
      int i = 0;
      while (true) {
        index++;
        if (!questions[index].isAnExtraQuestion) {
          inc += i;
          break;
        }
        i++;
      }
    }
    //print(questionIndex.toString() + " " + inc.toString());
    _answerController.text = "";
    setState(() {
      questionIndex += inc;
    });
  }

  previousQuestion(List<QuestionModel> questions) {
    int index = questionIndex;
    int dec = 1;
    if (questions[questionIndex].isAnExtraQuestion) {
      int i = 0;
      while (true) {
        index--;
        if (questions[index].hasExtraQuestion) {
          dec += i;
          break;
        }
        i++;
      }
    } else {
      int i = 0;
      while (true) {
        index--;
        if (questions[index].gotAnswered) {
          questions[index].gotAnswered = false;
          dec += i;
          break;
        } else {
          if (!questions[index].isAnExtraQuestion) {
            questions[index].gotAnswered = false;
            dec += i;
            break;
          }
        }
        i++;
      }
    }

    //print(questionIndex.toString() + " " + dec.toString());
    _answerController.text = questions[questionIndex - dec].textfieldAnswer;
    setState(() {
      questionIndex -= dec;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            "Ερωτήσεις",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {Get.to(() => const MainScreen());
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
            child: FutureBuilder(
              future: futureQuestions,
              builder: (context, snapshot) {
                // operation for completed state
                if (snapshot.hasData) {
                  List<QuestionModel> questions = snapshot.data as List<QuestionModel>;
                  return SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 30, left: 15, right: 15),
                            child: Text(
                              questions[questionIndex].questionDesc,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          ...(questions[questionIndex].answers)
                            .map((answer) => Container(
                                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
                                  child: RadioListTile(
                                    title: Text(answer),
                                    value: answer,
                                    groupValue: questions[questionIndex].radioButtonAnswer,
                                    onChanged: (newAnswer) {
                                      setState(() {
                                        questions[questionIndex].radioButtonAnswer = answer;
                                        print(answer);
                                      });
                                    },
                                  ),
                                ))
                            .toList(),
                          Container(
                            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                            child: TextFormField(
                              controller: _answerController,
                              onChanged: (newAnswer) {
                                setState(() {
                                  questions[questionIndex].textfieldAnswer =  _answerController.text;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Περιγραφή',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF1461D4),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                            child: Center(
                              child: Text(
                                questions[questionIndex].rank.toString() + " από " + globals.nonExtraQuestionsLength.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          ...[
                            (() {
                              if (questionIndex == 0) {
                                return ElevatedButton(
                                  onPressed: () {
                                    nextQuestion(questions);
                                  },
                                  child: const Text("Επόμενο"),
                                );
                              }
                              if (questionIndex == (questions.length - 1)) {
                                return ButtonTheme(
                                  child: ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          previousQuestion(questions);
                                        },
                                        child: const Text("Προηγούμενο"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          questions[questionIndex].gotAnswered = true;
                                          globals.questions = questions;
                                          Get.to(() => const AnswerSummaryScreen());
                                        },
                                        child: const Text("Υποβολή"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (questionIndex > 0) {
                                return ButtonTheme(
                                  child: ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          previousQuestion(questions);
                                        },
                                        child: const Text("Προηγούμενο"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          nextQuestion(questions);
                                        },
                                        child: const Text("Επόμενο"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            }())
                          ],
                          const SizedBox(
                            height: 50.0,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                // spinner for uncompleted state
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 6,
                      bottom: 6,
                    ),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
