class DoctorModel {
  int doctorID;
  String email;
  String password;
  String firstName;
  String lastName;
  String phoneNumber;
  bool confirmed;
  
  DoctorModel({
    required this.doctorID,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.confirmed,
  });

  @override
  String toString() {
    return "Doctor ID: " + doctorID.toString() + "\n" +
          "Email: " + email + "\n" +
          "First Name: " + firstName + "\n" +
          "Last Name: " + lastName + "\n" +
          "Phone Number: " + phoneNumber + "\n" +
          "Confirmed: " + confirmed.toString() + "\n";
  }
}
