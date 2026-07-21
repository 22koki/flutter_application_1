import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/colors.dart';
import '../configs/routes.dart';
import '../controllers/patient_controller.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientController patientController = Get.find();
    final int index = Get.arguments ?? 0;

    if (patientController.patients.isEmpty ||
        index < 0 ||
        index >= patientController.patients.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Patient Details'),
        ),
        body: const Center(
          child: Text('Patient record was not found'),
        ),
      );
    }

    final patient = patientController.patients[index];

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Patient Details'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(
                AppRoutes.editPatient,
                arguments: index,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    patient.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  patient.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: 30),
                patientInformation(
                  Icons.numbers,
                  'Patient ID',
                  patient.id,
                ),
                patientInformation(
                  Icons.calendar_month,
                  'Age',
                  '${patient.age} years',
                ),
                patientInformation(
                  Icons.people,
                  'Gender',
                  patient.gender,
                ),
                patientInformation(
                  Icons.phone,
                  'Phone',
                  patient.phone,
                ),
                patientInformation(
                  Icons.medical_information,
                  'Illness',
                  patient.illness,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget patientInformation(
    IconData icon,
    String label,
    String value,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: AppColors.primaryColor,
      ),
      title: Text(label),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }
}