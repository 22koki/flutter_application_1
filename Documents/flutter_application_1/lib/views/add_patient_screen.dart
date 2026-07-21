import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/colors.dart';
import '../controllers/patient_controller.dart';
import '../models/patient.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final illnessController = TextEditingController();

  String selectedGender = 'Male';

  final PatientControllers patientController = Get.find();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    illnessController.dispose();
    super.dispose();
  }

  void savePatient() {
    if (formKey.currentState!.validate()) {
      final patient = Patient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text.trim(),
        age: int.parse(ageController.text.trim()),
        gender: selectedGender,
        phone: phoneController.text.trim(),
        illness: illnessController.text.trim(),
      );

      patientController.addPatient(patient);

      Get.back();

      Get.snackbar(
        'Success',
        'Patient has been added',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Patient'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Patient name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the patient name';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_month),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the patient age';
                  }

                  if (int.tryParse(value) == null) {
                    return 'Enter a valid age';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                initialValue: selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a phone number';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: illnessController,
                decoration: const InputDecoration(
                  labelText: 'Illness or condition',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_information),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the illness or condition';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: savePatient,
                  child: const Text('Save Patient'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}