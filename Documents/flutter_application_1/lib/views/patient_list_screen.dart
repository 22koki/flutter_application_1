import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/colors.dart';
import '../configs/routes.dart';
import '../controllers/patient_controllers.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientController patientController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Patients'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () {
          if (patientController.patients.isEmpty) {
            return const Center(
              child: Text(
                'No patients have been added',
                style: TextStyle(fontSize: 17),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: patientController.patients.length,
            itemBuilder: (context, index) {
              final patient = patientController.patients[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Text(
                      patient.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(patient.name),
                  subtitle: Text(
                    '${patient.age} years • ${patient.illness}',
                  ),
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.patientDetails,
                      arguments: index,
                    );
                  },
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Get.toNamed(
                          AppRoutes.editPatient,
                          arguments: index,
                        );
                      }

                      if (value == 'delete') {
                        showDeleteDialog(
                          patientController,
                          index,
                        );
                      }
                    },
                    itemBuilder: (context) {
                      return const [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.toNamed(AppRoutes.addPatient);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showDeleteDialog(
    PatientController patientControllers,
    int index,
  ) {
    Get.defaultDialog(
      title: 'Delete Patient',
      middleText: 'Are you sure you want to delete this patient?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      onConfirm: () {
        patientControllers.deletePatient(index);
        Get.back();

        Get.snackbar(
          'Deleted',
          'Patient record has been deleted',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}