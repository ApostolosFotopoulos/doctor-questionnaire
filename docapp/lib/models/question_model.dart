class QuestionModel {
  //database
  int questionID;
  String questionDesc;
  List<String> answers;
  bool isRequired;
  bool isAnExtraQuestion;
  bool hasExtraQuestion;
  List<String> answersWithExtraQuestions;
  List<String> extraQuestions;
  String questionnaireID;

  //app
  String rank;
  String radioButtonAnswer;
  String textfieldAnswer;
  bool gotAnswered;

  QuestionModel({
    required this.questionID,
    required this.questionDesc,
    required this.answers,
    required this.isRequired,
    required this.isAnExtraQuestion,
    required this.hasExtraQuestion,
    required this.answersWithExtraQuestions,
    required this.extraQuestions,
    required this.questionnaireID,
    required this.rank,
    required this.radioButtonAnswer,
    required this.textfieldAnswer,
    required this.gotAnswered,
  });

  @override
  String toString() {
    return "Rank: " + rank.toString() + "\n" +
          "Question ID: " + questionID.toString() + "\n" +
          "Question Description: " + questionDesc + "\n" +
          "Answers: " + answers.toString() + "\n" +
          "Is Required: " + isRequired.toString() + "\n" +
          "Is An Extra Question: " + isAnExtraQuestion.toString() + "\n" +
          "Has Extra Questions: " + hasExtraQuestion.toString() + "\n" +
          "Answers With Extra Questions: " + answersWithExtraQuestions.toString() + "\n" +
          "Extra Questions: " + extraQuestions.toString() + "\n" +
          "Questionnaire: " + questionnaireID + "\n" +
          "Current Radio Button Answer: " + radioButtonAnswer + "\n" +
          "Text Field Answer: " + textfieldAnswer + "\n" +
          "Got Answered: " + gotAnswered.toString() + "\n";
  }
}
