class AnswersModel {
  int answersID;
  String answersList;
  int doctorID;
  int patientID;
  int questionnaireID;
  String submitDate;
  String amka;
  String patientFirstName;
  String patientLastName;

  AnswersModel({
    required this.answersID,
    required this.answersList,
    required this.doctorID,
    required this.patientID,
    required this.questionnaireID,
    required this.submitDate,
    required this.amka,
    required this.patientFirstName,
    required this.patientLastName,
  });

  @override
  String toString() {
    return "Answers ID: " + answersID.toString() + "\n" +
          "Answers List: " + answersList + "\n" +
          "Doctor ID: " + doctorID.toString() + "\n" +
          "Patient ID: " + patientID.toString() + "\n" +
          "Questionnaire ID: " + questionnaireID.toString() + "\n" +
          "Submit Date: " + submitDate + "\n" +
          "AMKA: " + amka + "\n" +
          "Patient First Name: " + patientFirstName + "\n" +
          "Patient Last Name: " + patientLastName + "\n";
  }
}