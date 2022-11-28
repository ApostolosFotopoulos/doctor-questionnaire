class PatientModel {
  int patientID;
  int doctorID;
  String amka;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;

  PatientModel({
    required this.patientID,
    required this.amka,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.doctorID,
  });

  @override
  String toString() {
    return "Patient ID: " + patientID.toString() + "\n" +
          "Doctor ID: " + doctorID.toString() + "\n" +
          "AMKA: " + amka + "\n" +
          "Email: " + email + "\n" +
          "First Name: " + firstName + "\n" +
          "Last Name: " + lastName + "\n" +
          "Phone Number: " + phoneNumber + "\n";
  }
}
