library docapp.globals;
import 'package:docapp/models/answers_model.dart';
import 'package:docapp/models/doctor_model.dart';
import 'package:docapp/models/patient_model.dart';
import 'package:docapp/models/question_model.dart';

var conn;
bool isLoggedIn = false;

DoctorModel doctor = DoctorModel(
  doctorID: -1,
  email: "",
  password: "",
  firstName: '',
  lastName: '',
  phoneNumber: '',
  confirmed: false,
  );

PatientModel patient = PatientModel(
  patientID: -1, 
  doctorID: -1,
  amka: "",
  email: '',
  firstName: '',
  lastName: '',
  phoneNumber: '',
);

String questionaireID = "-1";
List<QuestionModel> questions = [];
List<AnswersModel> answersLists = [];
int chosenAnswersList = -1;
int nonExtraQuestionsLength = -1;
