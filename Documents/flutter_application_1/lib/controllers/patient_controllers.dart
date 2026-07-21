import 'package:get/get.dart';

import '../models/patient.dart';

class PatientController extends GetxController {
  var patients = <Patient>[].obs;

  @override
  void onInit() {
    super.onInit();

    patients.add(
      Patient(
        id: '1',
        name: 'Mary Wanjiku',
        age: 29,
        gender: 'Female',
        phone: '0712345678',
        illness: 'Malaria',
      ),
    );

    patients.add(
      Patient(
        id: '2',
        name: 'John Kamau',
        age: 40,
        gender: 'Male',
        phone: '0723456789',
        illness: 'High Blood Pressure',
      ),
    );
  }

  void addPatient(Patient patient) {
    patients.add(patient);
  }

  void updatePatient(int index, Patient patient) {
    patients[index] = patient;
    patients.refresh();
  }

  void deletePatient(int index) {
    patients.removeAt(index);
  }
}