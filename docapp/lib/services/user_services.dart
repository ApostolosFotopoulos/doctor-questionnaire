import 'dart:io';
import 'package:docapp/models/answers_model.dart';
import 'package:docapp/models/doctor_model.dart';
import 'package:docapp/models/question_model.dart';
import 'package:docapp/services/globals.dart' as globals;
import '../models/patient_model.dart';

class UserServices {
  static Future<void> register(DoctorModel user) async {
    try {
      await globals.conn.query(
        "INSERT INTO doctor_user (email, password, first_name, last_name, phone_number, confirmed)"
        "VALUES ('" + user.email + "','" + user.password + "','" + user.firstName + "','" + user.lastName + "','" + user.phoneNumber + "'," + user.confirmed.toString() + ")");
    } catch (e) {
      print(e.toString());
      exit(0);
    }
  }

  static Future<bool> doctorExists(DoctorModel user) async {
    List<List<dynamic>> results;
    try {
      results = await globals.conn.query(
        "SELECT doctor_id, email, password, first_name, last_name, phone_number, confirmed"
        " FROM doctor_user"
        " WHERE email='" + user.email + "' AND password='" + user.password + "'");
    } catch (e) {
      print(e.toString());
      exit(0);
    }
    
    if (results.isNotEmpty) {
      for (final row in results) {
        int doctor_id = row[0];
        String email = row[1];
        String password = row[2];
        String first_name = row[3];
        String last_name = row[4];
        String phone_number = row[5];
        bool confirmed = row[6];

        globals.doctor = DoctorModel(
          doctorID: doctor_id,
          email: email,
          password: password,
          firstName: first_name,
          lastName: last_name,
          phoneNumber: phone_number,
          confirmed: confirmed,
        );
      }
    }
    //print(globals.doctor);
    return results.isNotEmpty;
  }

  static Future<List<AnswersModel>> fetchRecentAnswers() async {
    String limit = "3";
    List<List<dynamic>> results;
    try {
      results = await globals.conn.query(
        "SELECT answers_id, answers_list, a.doctor_id, a.patient_id, questionnaire_id, submit_date, amka, first_name, last_name"
        " FROM answers a, patient p" 
        " WHERE a.patient_id = p.patient_id AND a.doctor_id = " + globals.doctor.doctorID.toString() +
        " ORDER BY answers_id DESC"
        " LIMIT " + limit);  
    } catch (e) {
      print(e.toString());
      exit(0);
    }

    List<AnswersModel> answers = [];
    if (results.isNotEmpty) {
      for (final row in results) {
        var answers_id = row[0];
        var answers_list = row[1];
        var doctor_id = row[2];
        var patient_id = row[3];
        var questionnaire_id = row[4];
        DateTime submit_date = row[5];
        var amka = row[6];
        var first_name = row[7];
        var last_name = row[8];

        String time = submit_date.day.toString() + "-" + submit_date.month.toString() + "-" + submit_date.year.toString() + " " +
                  submit_date.hour.toString() + ":" + submit_date.minute.toString() + ":" + submit_date.second.toString();

        print(time);
        AnswersModel answer = AnswersModel(
          answersID: answers_id,
          answersList: answers_list,
          doctorID: doctor_id,
          patientID: patient_id,
          questionnaireID: questionnaire_id,
          amka: amka,
          submitDate: time,
          patientFirstName: first_name,
          patientLastName: last_name,
        );
        print(answer.toString());
        answers.add(answer);
      } 
    }
    return answers;
  }

  static Future<bool> patientExists(PatientModel user) async {
    List<List<dynamic>> results;
    try {
      results = await globals.conn.query(
        "SELECT patient_id, first_name, last_name, email, phone_number, amka"
        " FROM patient"
        " WHERE amka='" + user.amka + "' AND doctor_id='" + user.doctorID.toString() + "'");
    } catch (e) {
      print(e.toString());
      exit(0);
    }
    
    if (results.isNotEmpty) {
      for (final row in results) {
        int patient_id = row[0];
        String first_name = row[1];
        String last_name = row[2];
        String email = row[3];
        String phone_number = row[4];
        String amka = row[5];

        globals.patient = PatientModel(
          patientID: patient_id,
          amka: amka,
          doctorID: globals.doctor.doctorID,
          email: email,
          firstName: first_name,
          lastName: last_name,
          phoneNumber: phone_number,
        );
      }
    }
    //print(globals.patient.toString());
    return results.isNotEmpty;
  }

  static Future<void> registerPatient(PatientModel user) async {
    try {
      await globals.conn.query(
        "INSERT INTO patient (amka, email, first_name, last_name, phone_number, doctor_id)"
        " VALUES ('" + user.amka + "','" + user.email + "','" + user.firstName + "','" + user.lastName + "','" + user.phoneNumber + "','" + globals.doctor.doctorID.toString() + "')");
    } catch (e) {
      print(e.toString());
      exit(0);
    }
  }

  static Future<List<QuestionModel>> fetchQuestions(String questionnaireID) async {
    if (globals.questions.isNotEmpty) {
      return globals.questions;
    }

    List<List<dynamic>> results;
    try {
      results = await globals.conn.query(
        "SELECT question_id, question_desc, answers, is_required, is_an_extra_question, has_extra_question, answers_with_extra_question, extra_questions"
        " FROM question"
        " WHERE questionnaire_id='"+ questionnaireID + "'");  
    } catch (e) {
      print(e.toString());
      exit(0);
    }

    List<QuestionModel> questions = [];
    int actualQuestionsLength = 0;
    if (results.isNotEmpty) {
      int i = 1;

      int index = -1;
      for (final row in results) {
        var question_id = row[0];
        var question_desc = row[1];
        var answers = row[2].split(',');
        var is_required = row[3];
        var is_an_extra_question = row[4];
        var has_extra_question = row[5];
        var answers_with_extra_question = row[6].split(',');
        var extra_questions = row[7].split(',');

        String rank = "";
        /*if (is_required) {
          rank = "*";
        }*/

        if (has_extra_question) {
          index = i;
        }

        if (is_an_extra_question) {
          rank = rank + index.toString() + "i";
        } else {
          actualQuestionsLength++;
          rank = rank + i.toString();
          i++;
        }
        //print(rank);

        QuestionModel question = QuestionModel(
          questionID: question_id,
          rank: rank,
          questionDesc: question_desc,
          answers: answers,
          isRequired: is_required,
          isAnExtraQuestion: is_an_extra_question,
          hasExtraQuestion: has_extra_question,
          answersWithExtraQuestions: answers_with_extra_question,
          extraQuestions: extra_questions,
          questionnaireID: questionnaireID.toString(),
          radioButtonAnswer: answers[0],
          textfieldAnswer: "",
          gotAnswered: false,
        );
        //print(question.toString());
        questions.add(question);
      }
    }
    //print(actualQuestionsLength);
    globals.nonExtraQuestionsLength = actualQuestionsLength;
    return questions;
  }

  static Future<void> submitAnswers() async {
    String answersList = "";
    final now = DateTime.now();
    String time = now.year.toString() + "-" + now.month.toString() + "-" + now.day.toString() + " " +
                  now.hour.toString() + ":" + now.minute.toString() + ":" + now.second.toString();
    print(time);
    for (int i = 0; i < globals.questions.length; i++) {
      if (globals.questions[i].gotAnswered) {
        if (globals.questions[i].textfieldAnswer != "" && i==0) {
          answersList = globals.questions[i].textfieldAnswer;
        }
        else if (globals.questions[i].textfieldAnswer != "" && i>0) {
          answersList = answersList + "," + globals.questions[i].textfieldAnswer;
        }
        else {
          if (i==0) {
            answersList = globals.questions[i].radioButtonAnswer;
          }
          else {
            answersList = answersList + "," + globals.questions[i].radioButtonAnswer;
          }
        }
      }
      else {
        if (i==0) {
          answersList = "-";
        }
        else {
          answersList = answersList + ",-";
        }
      }
      print(answersList);
    }

    try {
      await globals.conn.query(
        "INSERT INTO answers (answers_list,patient_id,doctor_id,questionnaire_id,submit_date)"
        " VALUES ('" + answersList + "','" + globals.patient.patientID.toString() + "','" + globals.doctor.doctorID.toString() + "','" + globals.questionaireID + "','" + time + "')");
    } catch (e) {
      //print(e.toString());
      exit(0);
    }
  }
}
