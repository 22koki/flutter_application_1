import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/colors.dart';
import '../configs/routes.dart';
import '../controllers/patient_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientController patientController = Get.find();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Hospital Dashboard'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Obx(
                () => Column(
                  children: [
                    const Icon(
                      Icons.local_hospital,
                      size: 55,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Patient Record System',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Registered patients: ${patientController.patients.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  dashboardItem(
                    title: 'View Patients',
                    icon: Icons.people,
                    onTap: () {
                      Get.toNamed(AppRoutes.patientList);
                    },
                  ),
                  dashboardItem(
                    title: 'Add Patient',
                    icon: Icons.person_add,
                    onTap: () {
                      Get.toNamed(AppRoutes.addPatient);
                    },
                  ),
                  dashboardItem(
                    title: 'Patient Details',
                    icon: Icons.description,
                    onTap: () {
                      if (patientController.patients.isEmpty) {
                        Get.snackbar(
                          'No patients',
                          'Add a patient first',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.patientDetails,
                          arguments: 0,
                        );
                      }
                    },
                  ),
                  dashboardItem(
                    title: 'Edit Patient',
                    icon: Icons.edit,
                    onTap: () {
                      if (patientController.patients.isEmpty) {
                        Get.snackbar(
                          'No patients',
                          'Add a patient first',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      } else {
                        Get.toNamed(
                          AppRoutes.editPatient,
                          arguments: 0,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 45,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}